#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 3;
BEGIN { use_ok 'stefans_libs::PRJNA' }

use FindBin;
my $plugin_path = $FindBin::Bin;

my ( $value, @values, $exp );
my $obj= stefans_libs::PRJNA -> new($plugin_path."/data/output/");
is_deeply ( ref($obj) , 'stefans_libs::PRJNA', 'simple test of function stefans_libs::PRJNA -> new()' );


$value = $obj ->get_info_4 ( 'PRJNA285688') ;
ok( ref($value) eq 'data_table', 'get_info_4 returns a data_table');

print "\$exp = ".root->print_perl_var_def($value ).";\n";

print $value->AsString();
$value -> write_file( 'Example.PRJNA285688.xls');
#print "\$exp = ".root->print_perl_var_def($value ).";\n";


