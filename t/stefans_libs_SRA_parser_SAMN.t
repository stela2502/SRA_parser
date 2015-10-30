#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok 'stefans_libs::SRA_parser::SAMN' }

use FindBin;
my $plugin_path = '$FindBin::Bin';

my ( $value, @values, $exp );
my $stefans_libs_SRA_parser_SAMN = stefans_libs::SRA_parser::SAMN -> new($plugin_path."/data/output/");
is_deeply ( ref($stefans_libs_SRA_parser_SAMN) , 'stefans_libs::SRA_parser::SAMN', 'simple test of function stefans_libs::SRA_parser::SAMN -> new()' );

$value = $stefans_libs_SRA_parser_SAMN -> get_info_4 ( 'SAMN02929016' );
print "\$exp = ".root->print_perl_var_def($value ).";\n";
is_deeply( $value, $exp, "get info for SAMN ID" );

#print "\$exp = ".root->print_perl_var_def($value ).";\n";


