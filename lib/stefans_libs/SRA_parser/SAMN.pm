package stefans_libs::SRA_parser::SAMN;
#  Copyright (C) 2015-10-30 Stefan Lang

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

stefans_libs::SRA_parser::SAMN

=head1 DESCRIPTION

get and parse SAMN pages

=head2 depends on


=cut


=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::SRA_parser::SAMN.

=cut

sub new{

	my ( $class, $path ) = @_;

	my ($self);
	Carp::confess("path $path is not defined/acessible!\n$!\n")
	  if ( !-d $path );
	$self = {
		'path' => $path,
		'url'  => "http://www.ncbi.nlm.nih.gov/biosample/",
	};

	bless $self, $class  if ( $class eq "stefans_libs::SRA_parser::SAMN" );

	return $self;

}

sub get_web {
	my ( $self, $GEO_ID, $outpath ) = @_;
	system( "wget $self->{'url'}$GEO_ID -O $self->{'path'}/$GEO_ID.html" )
	  unless ( -f "$self->{'path'}/$GEO_ID.html" );
	return "$self->{'path'}/$GEO_ID.html";
}

sub get_info_4 {
	my ( $self, $accession, $ret ) = @_;
	open( IN, "<" . $self->get_web($accession) ) or die $!;
	my ( $loi );
	while (<IN>) {
		$loi = $_
		  if ( $_ =~ m/<div><div class="rprt"><h2 class="title">/ );
	}
	close ( IN);
	$loi =~ s|<.+?>|!!|g;
	$loi = [ split( /!!*/, $loi ) ];
	map {
		if ( $_ =~ m/^([A-z]+)\d+$/ ) { $ret->{$1} = $_ }
		elsif ( $_ =~ m/(GSM\d+)/ ) { $ret->{'GSM'} = $1 }
		elsif ( $_ =~ m/Mb downloads/ ) { $ret->{'file_stats'}= $_ }
	} @$loi;
	my ($a,$b);
	for ( my $i = 0; $i< @$loi; $i+=2 ) {
		@$loi[$i] =~ s/: $//;
		$a ->{@$loi[$i]} = @$loi[$i+1];
	}
	for ( my $i = 1; $i< @$loi; $i+=2 ) {
		@$loi[$i] =~ s/: $//;
		$b ->{@$loi[$i]} = @$loi[$i+1];
	}
	foreach ( qw(Layout Library Sample Construction protocol Strategy Source ), 'cell type' ) {
		if ($a->{$_}) {
			$ret->{$_} = $a->{$_};
		}else {
			$ret->{$_} = $b->{$_};
		}
	}
	die "\$exp = ".root->print_perl_var_def( { 'a' => $a, 'b' => $b, 'ret' => $ret } ).";\n";
	return $ret;
}

1;
