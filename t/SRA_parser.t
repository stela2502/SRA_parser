#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 5;
BEGIN { use_ok 'stefans_libs::SRA_parser' }

use FindBin;
my $plugin_path = $FindBin::Bin;

my ( $value, @values, $exp );
my $SRA_parser = stefans_libs::SRA_parser -> new( $plugin_path."/data/output/" );
is_deeply ( ref($SRA_parser) , 'stefans_libs::SRA_parser', 'simple test of function stefans_libs::SRA_parser -> new()' );


$value= $SRA_parser->get_info_4( 'SRX658436' );
#print "\$exp = ".root->print_perl_var_def($value ).";\n";

$exp = {
  'Source' => 'GENOMIC',
  'Accession' => 'SAMN02929016',
  'passages' => 'In vivo FACS purified cells',
  'Sample' => 'H3K4me3_NK.ucsc',
  'Sample_ID' => 'SAMN02929016',
  'Abstract' => 'We develop a new ChIpseq method (iChIP) to profile chromatin states of low cell number samples. We use IChIP to profile the chromatin dynamics during hematopoiesis across 16 different cell types which include the principal hematopoietic progenitors Overall design: Examination of 2 different histone modifications in 2 cell types.',
  'Strategy' => 'ChIP-Seq',
  'cell type' => 'NK Cells',
  'chip antibody' => 'H3K4me3',
  'source_name' => 'NK Cells',
  'Study_ACC' => 'SRP044685',
  'Links' => 'GEO Sample GSM1441331',
  'file_stats' => '2 ILLUMINA (Illumina HiSeq 1500) runs: 4.1M spots, 245.6M bases, 111.2Mb downloads',
  'GEO' => 'GSM1441331',
  'Organism' => 'Mus musculus',
  'Project_ID' => 'PRJNA255796 PRJNA257488',
  'Run_ACC' => 'SRR1521941 SRR1521942',
  'Sample_ACC' => 'SRX658436',
  'strain' => 'C57BL/6',
  'Layout' => 'SINGLE'
};

is_deeply( $value, $exp, "get info for SRA dataset SRX658436" );

$value= $SRA_parser->get_info_4( 'SAMEA2341981' );
#print "\$exp = ".root->print_perl_var_def($value ).";\n";
$exp = {
  'Project_ID' => 'PRJEB5296',
  'Abstract' => 'Protocols: Bone marrow was isolated from hindlegs (femur, tibia), hips (ilium) and backbone (vertebra). Muscle, connective tissue and spinal cord were removed, bones were crushed in RPMI/ 2 percent FBS (Gibco, Carlsbad, CA) using mortar and pestle. Single cell-suspensions were made by flushing through a 40 um filter mesh. Cell numbers and viability were determined using a ViCell Counter (Beckman Coulter, Brea, CA). To deplete lineage-positive cells, total bone marrow was stained 30 minutes with a combination of the following monoclonal rat antibodies directed against mature cell specific lineage markers: anti-CD4 (clone GK1.5), anti-CD8a (53.6.7), anti-CD11b (M1/70), anti-B220 (RA3.6B2), anti-GR1 (RB6.8C5) and anti-TER119 (Ter119). Labeled cells were incubated for 20 minutes with polyclonal sheep anti-rat IgG coated magnetic Dynabeads (Invitrogen, Hercules, CA) at a ratio 2:1 beads to cell and depleted using a magnet, enriching for the lineage-negative (Lin-neg) cell fraction. Beads were washed twice with RPMI/ 2 percent FBS to harvest residual cell fractions. Centrifugation steps were carried out at 1,500 rpm and 4 C for 5 minutes (5810r, Eppendorf, Hamburg, Germany). To specify hematopoietic stem and progenitor cells, the Linneg fraction was stained 30 minutes at fixed cell density using the following rat monoclonal fluorochrome-coupled antibodies: anti-Streptavidin, phycoerythrobilin-cyanine dye 7 (PE-Cy7) conjugated; anti-CD117/c-Kit (2B8)-APC-eFl780; anti-Ly6a/Sca-1 (E13-161.7)-APC; anti-CD34 (RAM34)-FITC; anti-CD135 (A2F10)-PE; anti-CD150 (TC15-12F12.2)-PE-Cy5; anti-CD48 (HM-48-1)-PB. Monoclonal antibody conjugates were purchased from eBioscience (San Diego, CA) or BioLegend (San Diego, CA). All antibodies were titrated prior to use.  Cell sorting was performed on a FACS Aria I or FACS Aria II (Becton Dickinson, San Jose, CA) at the DKFZ Flow Cytometry Service Unit, Heidelberg, Germany. The following sort parameters were used: 70 um nozzle; 10,000 evt/s.; 70 psi. HSC, MPP1, MPP2, MPP3 and MPP4 were obtained by sorting as described (Wilson et al. 2008, Hematopoietic Stem Cells Reversibly Switch from Dormancy to Self-Renewal during Homeostasis and Repair, http://dx.doi.org/10.1016/j.cell.2008.10.048), respectively, in biological triplicate. Sorted cells were collected into ice-cold RNA lysis buffer (ARCTURUS(R) PicoPure(R) RNA Isolation Kit (Life Technologies, Invitrogen)) and stored at -80 C until further usage. Of note, to determine samples purity we re-sorted a fraction of each population (each population showed a purity greater than 95 percent). Total RNA isolation was performed from the indicated populations using ARCTURUS(R) PicoPure(R) RNA Isolation Kit (Life Technologies, Invitrogen) according to the manufacturers instructions. DNAse treatment was performed using RNAse-free DNAse Set (Qiagen). Total RNA was used for quality controls and for normalization of starting material. cDNA-libraries were generated with 10 ng of total RNA using the SMARTer(TM) Ultra Low RNA Kit for Illumina Sequencing (Clontech) according to the manufacturers indications. Of note, twelve cycles were used for the amplification of cDNA respectively. Paired-end adaptors were applied to each population.',
  'organism' => 'mus musculus',
  'strain' => 'C57BL/6J',
  'Accession' => 'SAMEA2341981',
  'genotype' => 'wild type',
  'Submission' => 'EBI; 2014-08-22',
  'Organism' => 'Mus musculus',
  'cell type' => 'multipotent progenitor cell, fraction 3',
  'Sample_ID' => 'SAMEA2341981'
};

is_deeply( $value, $exp, "get info for SRA dataset SAMEA2341981" );


$value= $SRA_parser->get_info_4( 'SRX669488' );
#print "\$exp = ".root->print_perl_var_def($value ).";\n";

$exp = {
  'Run_ACC' => 'SRR1536397 SRR1536398 SRR1536399 SRR1536400',
  'cell type' => 'Bone Marrow Macrophages',
  'source_name' => 'Bone Marrow Macrophages',
  'Abstract' => 'We develop a new ChIpseq method (iChIP) to profile chromatin states of low cell number samples. We use IChIP to profile the chromatin dynamics during hematopoiesis across 16 different cell types which include the principal hematopoietic progenitors Overall design: 3 RNA-seq for digital gene expression quantitation across multiple cell types.',
  'Project_ID' => 'PRJNA257656 PRJNA257488',
  'Sample_ID' => 'SAMN02952066',
  'strain' => 'C57BL/6',
  'Layout' => 'SINGLE',
  'Sample_ACC' => 'SRX669488',
  'Study_ACC' => 'SRP045264',
  'Sample' => 'MF',
  'tissue' => 'Bone Marrow',
  'Organism' => 'Mus musculus',
  'Links' => 'GEO Sample GSM1464974',
  'Accession' => 'SAMN02952066',
  'GEO' => 'GSM1464974',
  'Strategy' => 'RNA-Seq',
  'selection marker' => 'B220-, CD3-, NK1.1-,  F4/80+, CD115-, low SSC',
  'Source' => 'TRANSCRIPTOMIC',
  'treatment' => 'none'
};

is_deeply( $value, $exp, "get info for SRA dataset SRX669488" );
#print "\$exp = ".root->print_perl_var_def($value ).";\n";


