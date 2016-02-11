package stefans_libs::SRA_parser::SRX;

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
use base ('stefans_libs::SRA_parser::web_parser_ext');

=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

stefans_libs::SRA_parser::SRX

=head1 DESCRIPTION

get and parse SRX pages

=head2 depends on


=cut

=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::SRA_parser::SRX.

=cut

sub new {

	my ( $class, $path ) = @_;

	my ($self);
	Carp::confess("path $path is not defined/acessible!\n$!\n")
	  if ( !-d $path );
	$self = {
		'path' => $path,
		'url'  => "http://www.ncbi.nlm.nih.gov/sra/",
	};

	bless $self, $class if ( $class eq "stefans_libs::SRA_parser::SRX" );

	return $self;

}


sub get_info_4 {
	my ( $self, $accession, $ret ) = @_;
	open( IN, "<" . $self->get_web($accession) ) or die $!;
	$self->{'act_ret'} = $ret;
	my ( $loi, @SRR );
	$self->_setup();
	while (<IN>) {
		$loi = $_
		  if ( $_ =~ m/<div><p class="details expand e-hidden"><b><a href="/ );
		if ( $_ =~ m/This record has not yet been released./ ){
			warn "record $accession has not been released to the public!\n";
			return undef;
		}
		map {$self->_add_2_IDs ( 'SRR', $_ )} @{$self->search_4_acc_type($_,'SRR')};
	}
	close ( IN);
	Carp::confess ( "I could not find the line of interest for acc '$accession' In file ".$self->get_web($accession)."\n") unless ( defined $loi );
	$loi = $self->_rem_tags_splice($loi);
	( $a, $b ) = $self->preprocess_loi ( $loi );
	
	foreach ( qw(Layout Sample Construction protocol Strategy Source ), 'hide Abstract' ,'Description') {
		if ($a->{$_}) {
			$self->_add_2_IDs( $_, $a->{$_} );
		}else {
			$self->_add_2_IDs( $_, $b->{$_} );
		}
	}
	return $self->{'act_ret'};
}

1;
