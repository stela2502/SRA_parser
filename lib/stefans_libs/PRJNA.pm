package stefans_libs::PRJNA;

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

#use FindBin;
#use lib "$FindBin::Bin/../lib/";
use strict;
use warnings;
use base ('stefans_libs::SRA_parser::web_parser_ext');
use stefans_libs::SRA_parser;
use WWW::Mechanize;
use stefans_libs::flexible_data_structures::data_table;

=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

stefans_libs::SRA_parser::PRJNA

=head1 DESCRIPTION

This is the most pverful class in this tool - it will expand and slurp all information on one or more than one project

=head2 depends on


=cut

=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::SRA_parser::PRJNA.

=cut

sub new {

	my ( $class, $path, ) = @_;

	my ($self);

	$self = {
		'SRA_parser' => stefans_libs::SRA_parser->new($path),
		'path'       => $path,
		'url' =>
"http://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=",
		'no_compaction' => 1,
	};

	bless $self, $class if ( $class eq "stefans_libs::PRJNA" );

	return $self;

}

sub preprocess_ID {
	if ( $_[1] =~ m/PRJNA(\d+)/ ) {
		return $1;
	}
	return $_[1];
}

sub get_web {
	my ( $self, $GEO_ID, $outpath ) = @_;
	$GEO_ID = $self->preprocess_ID($GEO_ID);
	return "$self->{'path'}/$GEO_ID.html_mod"
	  if ( -f "$self->{'path'}/$GEO_ID.html_mod" );
	open( OUT, ">$self->{'path'}/$GEO_ID.html_mod" )
	  or die "$self->{'path'}/$GEO_ID.html_mod\n" . $!;
	my $mech = WWW::Mechanize->new();
	$mech->get("$self->{'url'}$GEO_ID");
	print OUT $mech->content();
	while ( eval { $mech->follow_link( text_regex => qr/Next/i ) } ) {
		print OUT $mech->content();
	}
	close(OUT);
	$mech = undef;
	return "$self->{'path'}/$GEO_ID.html_mod";
}

sub get_info_4 {
	my ( $self, $accession ) = @_;
	$accession = $self->preprocess_ID($accession);
	open( IN, "<" . $self->get_web($accession) ) or die $!;
	my ($loi);
	$self->{'data_table'} ||= data_table->new();
	while (<IN>) {
		if ( $_ =~ m/title="Next page of results"/ ) {
			warn
"Better to download the whole page including all samples from NCBI manually and parsing ths page instead!\n";
		}
		foreach ( $_ =~ m/([ES]RX\d+)/g ) {
			print "Get info for $_:\n";
			$loi = $self->{'SRA_parser'}->get_info_4( $_, 1 );
			next unless ( defined $loi );
			foreach ( keys %${ $self->{'key_trans'} } ) {
				$self->{'data_table'}->Add_2_Header($_)
				  if ( defined $loi->{$_} );
			}
			$self->{'data_table'}->Add_2_Header( [ keys %$loi ] );
			$self->{'data_table'}->AddDataset($loi);
		}
	}
	close(IN);
	return $self->reformat_table( $self->{'data_table'} );
}

sub get_info_from_file {
	my ( $self, $file ) = @_;
	open( IN, "<" . $file ) or die $!;
	my ($loi);
	$self->{'data_table'} ||= data_table->new();
	while ( my $line = <IN> ) {
		chomp($line);
		foreach ( $line =~ m/([ES]RX\d+)/g ) {
			print "Get info for $_:\n";
			$loi = $self->{'SRA_parser'}->get_info_4( $_, 1 );
			next unless ( defined $loi );
			foreach (
				values %{ $self->{'SRA_parser'}->{'sample_acc'}->{'key_trans'} }
			  )
			{
				next if ( $_ eq "Abstract" );
				$self->{'data_table'}->Add_2_Header($_)
				  if ( defined $loi->{$_} );
			}
			$self->{'data_table'}
			  ->Add_2_Header( [ 'Strategy', 'Layout', 'Source' ] );
			$self->{'data_table'}->Add_2_Header( [ keys %$loi ] );
			$self->{'data_table'}->AddDataset($loi);
		}
		map { $self->get_info_4($_) } ( $line =~ m/(PRJNA\d+)/g );
	}
	close(IN);
	return $self->reformat_table( $self->{'data_table'} );

}

sub uniq {
	my $self = shift;
	return do {
		my %seen;
		grep { !$seen{$_}++ } @_;
	  }
}

sub reformat_table {
	my ( $self, $table ) = @_;

	## check whether any columns contains onyl one type of info
	my $col = 0;
	my ( @simple, @v, $overlapp );
	map {
		my $OK = 1;
		map {    ## sum up filled cells
			if ( $_ =~ m/\w/ ) {
				$v[$col] ||= $_;
				if ($OK){
				if ( $v[$col] eq $_ ) {
					$simple[$col] = $col;
				}
				else {
					$OK = 0;
					$simple[$col] = undef;
				}
				}
			}
		} @{ $table->GetAsArray($_) };
		$col++;
	} @{ $table->{'header'} };
	@simple = grep defined, @simple;
	
	map {
		$overlapp->{ $v[$simple[$_]] } ||= [];
		push( @{ $overlapp->{ $v[$simple[$_] ] } }, $simple[$_] )
	} 0..$#simple;
	#print "\$exp = ".root->print_perl_var_def( { 'simple' => \@simple, 'v' => [@v[@simple]], '$overlapp' => $overlapp} ).";\n";
	foreach ( keys %$overlapp ) {
		if ( @{$overlapp->{$_}} > 1 ) {
			print "I try to merge the columns ".join(", ",  @{$table->{'header'}}[@{$overlapp->{$_}}] )."\n";
			$table = $table->merge_cols ( @{$table->{'header'}}[@{$overlapp->{$_}}] );
		}
	}
	
	return $table if ( $self->{'no_compaction'} );
	## all columns that do not contain ID's or are available for all rows need to be combined into a summary description column
	$col = 0;
	my @acc;
	my @occ = map {
		my $i = 0;
		map {            ## sum up filled cells
			if ( $_ =~ m/\w/ ) {
				$i++;
				if ( $_ =~ m/^[A-Za-z]+\d+$/ ) {
					$acc[$col] = $col;
				}        ## filled with (only) ID's
				else { $acc[$col] = undef }    ## filed with not only ID's
			}
		} @{ $table->GetAsArray($_) };
		$col++;
		$i
	} @{ $table->{'header'} };
	foreach (
		'Description', 'hide Abstract', 'genotype', 'cell type',
		'Strategy',    'strain',        'tissue',   'source_name'
	  )
	{
		push( @acc, $table->Header_Position($_) );
	}
	@acc = grep defined, @acc;
	$col = -1;
	my @OK = grep defined, map {
		$col++;
		if   ( $_ == $table->Rows() ) { $col }
		else                          { undef }
	} @occ;
	my $OK = { map { $_ => 1 } $self->uniq( @acc, @OK ) };
	$col = -1;
	my @notUse = @{ $table->{'header'} }[
	  grep defined,
	  map {
		  $col++;
		  if ( $OK->{$_} ) { undef }
		  else { $col }
	  } 0 .. ( $table->Lines() - 1 )
	];
	my @use = @{ $table->{'header'} }[ $self->uniq( @acc, @OK ) ];

	#$table -> define_subset ( 'notUse', @{$table->{'header'}}[@notUse] );
	my $ret = data_table->new();
	$ret->Add_2_Header( [ @use, 'summary description' ] );
	foreach my $hash ( @{ $table->GetAsHashedArray() } ) {
		my $desc = { 'summary description' => '' };
		map {
			$desc->{'summary description'} .= "$_=$hash->{$_};"
			  if ( defined $hash->{$_} && $hash->{$_} =~ m/\w/ );
		} @notUse;
		chop( $desc->{'summary description'} );
		foreach (@use) {
			$desc->{$_} = $hash->{$_};
		}
		$ret->AddDataset($desc);
	}
	return $ret;

}

1;
