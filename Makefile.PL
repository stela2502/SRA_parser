#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;


name 'SRA_parser';
all_from 'lib/';


requires_external_bin('make');
requires_external_bin( "pdflatex");

requires 'DBI';
requires 'DateTime::Format::MySQL';
requires 'Statistics::Descriptive';
requires 'Date::Simple';
requires 'Number::Format';
requires 'GD';
requires 'SVG';
requires 'GD::SVG' => '0.33';

catalyst;

install_script glob('bin/*.pl');
auto_install;
WriteAll;
