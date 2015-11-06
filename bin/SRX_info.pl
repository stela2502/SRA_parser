#! /usr/bin/perl -w

#  Copyright (C) 2015-11-02 Stefan Lang

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

=head1 SRX_info.pl

This script downloads all inforation to a SRX ncbi id.

To get further help use 'SRX_info.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;
use stefans_libs::SRA_parser;

use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';


my ( $help, $debug, $database, $acc, $outfile, $tempath);

Getopt::Long::GetOptions(
	 "-acc=s"    => \$acc,
	 "-outfile=s"    => \$outfile,
	 "-tempath=s"    => \$tempath,

	 "-help"             => \$help,
	 "-debug"            => \$debug
);

my $warn = '';
my $error = '';

unless ( defined $acc) {
	$error .= "the cmd line switch -acc is undefined!\n";
}
unless ( defined $outfile) {
	$error .= "the cmd line switch -outfile is undefined!\n";
}
unless ( defined $tempath) {
	$warn .= "the cmd line switch -tempath is undefined!\n";
}


if ( $help ){
	print helpString( ) ;
	exit;
}

if ( $error =~ m/\w/ ){
	print helpString($error ) ;
	exit;
}

sub helpString {
	my $errorMessage = shift;
	$errorMessage = ' ' unless ( defined $errorMessage); 
 	return "
 $errorMessage
 command line switches for SRX_info.pl

   -acc       :<please add some info!>
   -outfile       :<please add some info!>
   -tempath       :<please add some info!>

   -help           :print this help
   -debug          :verbose output
   

"; 
}


my ( $task_description);

$task_description .= 'perl '.$plugin_path .'/SRX_info.pl';
$task_description .= " -acc $acc" if (defined $acc);
$task_description .= " -outfile $outfile" if (defined $outfile);
$task_description .= " -tempath $tempath" if (defined $tempath);


open ( LOG , ">$outfile.log") or die $!;
print LOG $task_description."\n";
close ( LOG );

my $det = root->filemap( $outfile );
unless ( defined $tempath ) {
	$tempath = $det->{'path'}."/".$det->{'filename_core'};
}
mkdir $tempath unless ( -d $tempath );

my $SRA_parser = stefans_libs::SRA_parser -> new( $tempath );

my $value = $SRA_parser->get_info_4( $acc );
my $data_table = data_table->new({'no_doubble_cross'=>1});
$data_table->Add_2_Header([ keys %$value ]);
$data_table->AddDataset( $value );
print $data_table->AsString();
$data_table->write_table( $outfile );

