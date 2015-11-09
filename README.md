# SRA_parser

Reads a SRA archive and all linked archives starting with any SRA ID.

##requirement

Perl and my perl lib <a href="https://github.com/stela2502/Stefans_Lib_Esentials">Stefans_Libs_essentials</a> that you also find on github.


## usage

I recommend to download the SRA summary page from NCBI 

wget http://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=257488 -O All_SRA257488.html
 

SRA_from_summary_page.pl -web_file All_SRA257488.html -outfile All_SRA257488.xls -tempath ~/tmp

The tool is going to download all information available on NCBI web pages and parses the data into a tab separated table file.
All html documents from NCBI will be downloaded into the temp path and can be deleted afterwards.

 