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
	
	unless ( -d $path ){
		mkdir( $path ) or Carp::confess ( "Could neither access nor create the outpath '$path'\n$!\n" );
	}

	$self = {
		'path' => $path,
		'sample_acc' => stefans_libs::SRA_parser::SRX->new($path),
		'sample_id' => stefans_libs::SRA_parser::SAMN->new( $path),
		'searched' => {},
  	};
  	$self ->{'samea'} = $self->{'samn'};

  	bless $self, $class  if ( $class eq "stefans_libs::SRA_parser" );
	
	
  	return $self;

}


sub get_info_4 {
	my ( $self, $accession, $not_further_prjna ) = @_;
	return undef if ( $self->{'searched'}->{$accession});
	$self->{'searched'}->{$accession} = 1;
	my $ret ;
	if ( $accession =~ m/^SAM/ ) {
		$ret = $self->{'sample_id'} -> get_info_4 ( $accession );
	}
	elsif ( $accession =~ m/^[ES]R[SX]/ ) {
		$ret = $self->{'sample_acc'} -> get_info_4 ( $accession ); 
	}
	else {
		warn "Sorry I can not process an acc like '$accession'\n";
	}
	
	foreach my $key ( keys %$ret ) {
		if ( defined $self->{lc($key)} ) {
			warn "More than one $_ acc for $accession\n" if ( @{$ret->{$key}} > 1 );
			foreach my $acc ( @{$ret->{$key}} ) {
				unless ( $self->{'searched'}->{$acc}){
				$self->{'searched'}->{$acc} = 1;
				$ret = $self->{lc($key)} -> get_info_4 ( $acc, $ret,  $not_further_prjna );
				}
			}
		}
	}
	foreach ( keys %$ret ) {
		$ret->{$_} = join(" ", $self->uniq ( @{$ret->{$_}}) ) if ( ref($ret->{$_}) eq "ARRAY");
		delete ( $ret->{$_} ) if  ( ! ( defined $ret->{$_} && $ret->{$_} =~ m/\w/ ) );
	}
	return $ret
}

sub uniq {
	my $self= shift;
	return do { my %seen; grep { !$seen{$_}++ } @_ }
}


1;
