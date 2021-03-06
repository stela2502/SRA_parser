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
use base ('stefans_libs::SRA_parser::web_parser_ext');

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

sub get_info_4 {
	my ( $self, $accession, $ret ) = @_;
	open( IN, "<" . $self->get_web($accession) ) or die $!;
	$self->{'act_ret'} = $ret;
	my ( $loi );
	while (<IN>) {
		$loi = $_
		  if ( $_ =~ m/<div><div class="rprt"><h2 class="title">/ );
	}
	close ( IN);
	if ( ! defined $loi ){
		Carp::confess ( "Probably an NCBI web file change!\n"
		."I can no longer find my line of interest in the html file!\n"
		."Please check the file '".$self->get_web($accession) ."'\n");
	}
	$loi = $self->_rem_tags_splice($loi);
	my ( $a, $b);
	( $a, $b ) = $self->preprocess_loi ( $loi );
	
	## All values after atributes are of interest!
	my $use = 0;
	foreach ( @$loi ){
		$use ++;
		if ( $_ eq "Attributes") {
			for ( my $i = $use; $i < @$loi; $i+=2 ){
				last if ( @$loi[$i] eq " ");
				$self->_add_2_IDs(@$loi[$i], @$loi[$i+1]);
			}
			last;
		}
	}
	foreach ( qw(Organism strain source_name passages), 'cell type', 'ID', 'Accession' ) {
		if ($a->{$_}) {
			$self->_add_2_IDs($_, $a->{$_} );
		}else {
			$self->_add_2_IDs($_, $b->{$_} );
		}
	}
	
#	die "\$exp = ".root->print_perl_var_def( { 'a' => $a, 'b' => $b, 'ret' => $ret, 'loi' => $loi } ).";\n";
	return $self->{'act_ret'};
}

1;
