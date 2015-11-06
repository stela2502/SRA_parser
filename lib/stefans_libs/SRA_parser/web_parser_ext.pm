package stefans_libs::SRA_parser::web_parser_ext;
#  Copyright (C) 2015-11-02 Stefan Lang

#  This program is free software; you can redistribute it 
#  and/or modify it under the terms of the GNU General Public License 
#  as published by the Free Software Foundation; 
#  either version 3 of the License, or (at your option) any later version.

#  This program is distributed in the hope that it will be useful, 
#  but WITHOUT ANY WARRANTY; without even the implied warranty of 
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#  See the GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License 
#  along with this program; if not, see <http://www.gnu.org/licenses/>.

#use FindBin;
#use lib "$FindBin::Bin/../lib/";
use strict;
use warnings;


=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

stefans_libs::SRA_parser::web_parser_ext

=head1 DESCRIPTION

A base class that should not be called directly

=head2 depends on


=cut


=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::SRA_parser::web_parser_ext.

=cut

sub new{
	Car::confess ( "Do not create an instance of this!\n" );
}

sub preprocess_ID{
	return $_[1];
}
sub get_web {
	my ( $self, $GEO_ID, $outpath ) = @_;
	$GEO_ID = $self->preprocess_ID( $GEO_ID );
	unless ( -f "$self->{'path'}/$GEO_ID.html" ) {
		system( "wget '$self->{'url'}$GEO_ID' -O $self->{'path'}/$GEO_ID.html" );
		sleep(2);
	}
	return "$self->{'path'}/$GEO_ID.html";
}

sub _setup{
	my $self = shift;
	$self->{'key_trans'} ||= {
		'SRX' => 'Sample_ACC',
		'ERX' => 'Sample_ACC',
		'ERR' => 'Run_ACC',
		'SRR' => 'Run_ACC',
		'SRP' => 'Study_ACC',
		'ERP' => 'Study_ACC',
		'SAMN' => 'Sample_ID',
		'SAMEA' => 'Sample_ID',
		'PRJEB' => 'Project_ID',
		'BioProjects' => 'Project_ID',
		'BioProject' => 'Project_ID',
		'PRJNA' => 'Project_ID',
		'GSM' => 'GEO',
		'hide Abstract' => 'Abstract',
		'Description' => 'Abstract',
	};
	$self->{'exclude'} ||= { map { $_ => 1} ('Retrieve', 'ID', 'all samples') };
	return $self;
}
sub rn_key{
	my ( $self, $key ) = @_;
	return $self->{'key_trans'}->{$key} if ( defined $self->{'key_trans'}->{$key} );
	return $key;
}

sub _add_2_IDs {
	my ( $self, $tag, $value ) =@_;
	return 0 unless ( $self->key_ok($tag)); 
	$self->{'act_ret'} ||= {};
	if ( defined $value && $value =~m/\w/ ) {
		## fix some tags
		$tag = $self->rn_key( $tag );
		$self->{'act_ret'}->{$tag} ||= [];
		push ( @{$self->{'act_ret'}->{$tag}}, $value);
	}
}

sub search_4_acc_type{
	my ( $self, $line, $acc ) =@_;
	Carp::confess( "line not defined!\n")  unless( defined $line);
	return [ $line=~ m/($acc\d+)/ ];
}

sub uniq {
	my $self= shift;
	return do { my %seen; grep { !$seen{$_}++ } @_ }
}
sub polish {
	my ($self, @v ) = @_;
	for (my $i = 0; $i < @v; $i++ ){
		$v[$i] =~s/^\s+//;
	    $v[$i] =~s/:?\s+$//;
	    $v[$i] =~s/['"]//g;
	}
	return @v;
}

sub key_ok {
	my ( $self, $key ) = @_;
	return 0 unless (defined $key && $key =~m/\w/);
	return 0 if ( $self->{'exclude'}->{$key});
	return 0 if ( scalar(split(/\s+/,$key)) > 2);
	return 0 if ( $key =~m/^[A-Za-z]*\d+$/ );
	return 1;
}

sub preprocess_loi {
	my ( $self, $loi ) = @_;
	my ( $a, $b );
	map {
		if ( $_ =~ m/^([A-Za-z]+)\d+$/ ) {$self->_add_2_IDs( $1, $_  ) }
		elsif ( $_ =~ m/(GS[A-Y]\d+)/ ) { $self->_add_2_IDs( 'GEO',$1 ) }
		elsif ( $_ =~ m/Mb downloads/ ) { $self->_add_2_IDs('file_stats', $_) }
	} @$loi;
	for ( my $i = 0; $i< @$loi; $i+=2 ) {
		next unless ( $self->key_ok(@$loi[$i]));
		$a ->{@$loi[$i]} = @$loi[$i+1];
	}
	for ( my $i = 1; $i< @$loi; $i+=2 ) {
		next unless ( $self->key_ok(@$loi[$i]));
		$b ->{@$loi[$i]} = @$loi[$i+1];
	}
	return ( $a, $b );
}

sub _rem_tags_splice {
	my ( $self, $l )=@_;
	$self->_setup();
	chomp($l);
	## first check for some extremely important IDs that might be hidden in ome links etc
	map {$self->_add_2_IDs ('SRR', $_ )} @{$self->search_4_acc_type($l,'SRR')};
	map {$self->_add_2_IDs ('PMID', $_ )} @{$self->search_4_acc_type($l,'PMID')};
	$l =~ s|<.+?>|!!|g;
	return [ $self->polish(split( /!!*/, $l ) ) ];
}
1;
