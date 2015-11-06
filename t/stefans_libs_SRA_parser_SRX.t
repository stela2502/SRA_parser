#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 3;
BEGIN { use_ok 'stefans_libs::SRA_parser::SRX' }
use stefans_libs::root;
use FindBin;
my $plugin_path = $FindBin::Bin;

my ( $value, @values, $exp );
my $stefans_libs_SRA_parser_SRX = stefans_libs::SRA_parser::SRX -> new($plugin_path."/data/output/");
is_deeply ( ref($stefans_libs_SRA_parser_SRX) , 'stefans_libs::SRA_parser::SRX', 'simple test of function stefans_libs::SRA_parser::SRX -> new()' );

$exp = {
  'Sample_ACC' => [ 'SRX658436' ],
  'Sample' => [ 'H3K4me3_NK.ucsc' ],
  'Run_ACC' => [ 'SRR1521941', 'SRR1521941', 'SRR1521941', 'SRR1521942' ],
  'file_stats' => [ '2 ILLUMINA (Illumina HiSeq 1500) runs: 4.1M spots, 245.6M bases, 111.2Mb downloads' ],
  'Source' => [ 'GENOMIC' ],
  'Abstract' => [ 'We develop a new ChIpseq method (iChIP) to profile chromatin states of low cell number samples. We use IChIP to profile the chromatin dynamics during hematopoiesis across 16 different cell types which include the principal hematopoietic progenitors Overall design: Examination of 2 different histone modifications in 2 cell types.' ],
  'Strategy' => [ 'ChIP-Seq' ],
  'GEO' => [ 'GSM1441331', 'GSM1441331' ],
  'Project_ID' => [ 'PRJNA255796' ],
  'Layout' => [ 'SINGLE' ],
  'Sample_ID' => [ 'SAMN02929016' ],
  'Study_ACC' => [ 'SRP044685' ]
};

$value = $stefans_libs_SRA_parser_SRX -> get_info_4 ( 'SRX658436' );
is_deeply( $value, $exp, "get info for SRX ID" );
#print "\$exp = ".root->print_perl_var_def($value ).";\n";

#print "\$exp = ".root->print_perl_var_def($value ).";\n";


