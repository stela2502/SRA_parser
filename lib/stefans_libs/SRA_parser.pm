package stefans_libs::SRA_parser;


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
use Cwd;

use stefans_libs::SRA_parser::SRX;
use stefans_libs::SRA_parser::SAMN;
use stefans_libs::flexible_data_structures::data_table;

=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

SRA_parser

=head1 DESCRIPTION

This lib helps in parsing html pages from the NCBI short reads archive

=head2 depends on


=cut


=head1 METHODS

=head2 new

new returns a new object reference of the class SRA_parser.

=cut

sub new{

	my ( $class, $path ) = @_;

	my ( $self );
	$path ||= getcwd;

	$self = {
		'path' => $path,
		'srx' => stefans_libs::SRA_parser::SRX->new($path),
		'samn' => stefans_libs::SRA_parser::SAMN->new( $path),
  	};

  	bless $self, $class  if ( $class eq "stefans_libs::SRA_parser" );

  	return $self;

}


sub get_info_4 {
	my ( $self, $accession ) = @_;
	my $ret ;
	if ( $accession =~ m/^SAMN/ ) {
		$ret = $self->{'samn'} -> get_info_4 ( $accession ); 
	}
	if ( $accession =~ m/^SRX/ ) {
		$ret = $self->{'srx'} -> get_info_4 ( $accession ); 
	}
	foreach ( keys %$ret ) {
		if ( defined $self->{lc($_)} ) {
			$ret = $self->{lc($_)} -> get_info_4 ( $ret->{$_}, $ret );
		}
	}
	return $ret
}


1;
