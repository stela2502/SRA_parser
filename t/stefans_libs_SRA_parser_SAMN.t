#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 3;
BEGIN { use_ok 'stefans_libs::SRA_parser::SAMN' }

use stefans_libs::root;
use FindBin;
my $plugin_path = $FindBin::Bin;

my ( $value, @values, $exp );
my $stefans_libs_SRA_parser_SAMN = stefans_libs::SRA_parser::SAMN -> new($plugin_path."/data/output/");
is_deeply ( ref($stefans_libs_SRA_parser_SAMN) , 'stefans_libs::SRA_parser::SAMN', 'simple test of function stefans_libs::SRA_parser::SAMN -> new()' );

$value = $stefans_libs_SRA_parser_SAMN -> get_info_4 ( 'SAMN02929016' );
#print "\$exp = ".root->print_perl_var_def($value ).";\n";
$exp = {
  'cell type' => [ 'NK Cells', 'NK Cells' ],
  'BioProjects' => [ 'PRJNA257488' ],
  'source_name' => [ 'NK Cells', 'NK Cells' ],
  'GEO' => [ 'GSM1441331', 'GSM1441331' ],
  'chip antibody' => [ 'H3K4me3' ],
  'Links' => [ 'GEO Sample GSM1441331' ],
  'Sample_ID' => [ 'SAMN02929016' ],
  'Project_ID' => [ 'PRJNA257488', 'PRJNA255796' ],
  'Organism' => [ 'Mus musculus' ],
  'strain' => [ 'C57BL/6', 'C57BL/6' ],
  'passages' => [ 'In vivo FACS purified cells', 'In vivo FACS purified cells' ],
  'Accession' => [ 'SAMN02929016' ]
};

is_deeply( $value, $exp, "get info for SAMN ID" );


#print "\$exp = ".root->print_perl_var_def($value ).";\n";
