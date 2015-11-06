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

=head1 SRA_from_summary_page.pl

This tool can either download a list of NGS experiments from NCBI using a PRJNA ID or you download the list yerselve and let the tool parse that list.

To get further help use 'SRA_from_summary_page.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;

use stefans_libs::PRJNA;

use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';


my ( $help, $debug, $database, $web_file, $acc, $outfile, $tempath);

Getopt::Long::GetOptions(
	 "-web_file=s"    => \$web_file,
	 "-acc=s"    => \$acc,
	 "-outfile=s"    => \$outfile,
	 "-tempath=s"    => \$tempath,

	 "-help"             => \$help,
	 "-debug"            => \$debug
);

my $warn = '';
my $error = '';
my $err = 0;
unless ( defined $web_file) {
	$err++;
	$warn .= "the cmd line switch -web_file is undefined!\n";
}
unless ( defined $acc) {
	$err++;
	$warn .= "the cmd line switch -acc is undefined!\n";
}
if ( $err == 2  ){
	$error .= "I need either a downloaded html like file containing SRX ids or a PRJNA ID (-web_file or -acc)\n";
}
unless ( defined $outfile) {
	$error .= "the cmd line switch -outfile is undefined!\n";
}
unless ( defined $tempath) {
	$error .= "the cmd line switch -tempath is undefined!\n";
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
 command line switches for SRA_from_summary_page.pl

   -web_file       :<please add some info!>
   -acc       :<please add some info!>
   -outfile       :<please add some info!>
   -tempath       :<please add some info!>

   -help           :print this help
   -debug          :verbose output
   

"; 
}


my ( $task_description);

$task_description .= 'perl '.root->perl_include().' '.$plugin_path .'/SRA_from_summary_page.pl';
$task_description .= " -web_file $web_file" if (defined $web_file);
$task_description .= " -acc $acc" if (defined $acc);
$task_description .= " -outfile $outfile" if (defined $outfile);
$task_description .= " -tempath $tempath" if (defined $tempath);


open ( LOG , ">$outfile.log") or die $!;
print LOG $task_description."\n";
close ( LOG );
my $det = root->filemap( $outfile );
my $value;
unless ( defined $tempath ) {
	$tempath = $det->{'path'}."/".$det->{'filename_core'};
}
mkdir $tempath unless ( -d $tempath );
my $obj= stefans_libs::PRJNA -> new($tempath);
if ( -f $web_file ){
	$value = $obj-> get_info_from_file ( $web_file );
}elsif ( defined $acc ){
	$value = $obj ->get_info_4 ( $acc ) ;
}

$value -> write_file( $outfile );



## Do whatever you want!

