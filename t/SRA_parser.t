#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok 'stefans_libs::SRA_parser' }

use FindBin;
my $plugin_path = $FindBin::Bin;

my ( $value, @values, $exp );
my $SRA_parser = stefans_libs::SRA_parser -> new( $plugin_path."/data/output/" );
is_deeply ( ref($SRA_parser) , 'stefans_libs::SRA_parser', 'simple test of function stefans_libs::SRA_parser -> new()' );


$SRA_parser->get_info_4( 'SRX658436' );
#print "\$exp = ".root->print_perl_var_def($value ).";\n";


