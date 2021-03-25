#!/usr/local/bin/perl

#Usage: porf_bedformat.pl <Reference genome file; fasta file> <Genome Name> <Total pORF list output file> <bed file> <mininum length of pORF> <maximun length of pORF>
#Example: perl porf_bedformat.pl ecoli_U00096_genome.fa U00096.3 pORFList.txt pORF.bed 9 150

$version = 1;

&usage if (@ARGV != 6);
$genomeFile = shift(@ARGV);#genome file in fasta format
$genomeName = shift(@ARGV);#genome name
$allList = shift(@ARGV);#pORFs list in txt format (all length - small/long) 
$bedFile = shift(@ARGV);#pORFs in bed format (6 columns)
$minLength = shift(@ARGV);#min length to put (here we put 9 nt)
$maxLength = shift(@ARGV);#max length to put (here we put 150 nt)

@STA=("ATG","GTG","TTG","CTG"); #start codons
@STO=("TGA","TAG","TAA"); #stop codons


open(OUT, "> $allList") or die "Can't open $allList\n"; 
print OUT "pORF_id\tStart\tEnd\tStrand\tLength(bp)\tStart\tStop\n"; #print in txt file- pORF_id,Start,End,Strand,Length(bp),Start,Stop

open(BED,"> $bedFile") or die "Can't open $bedFile\n";
print BED "Genomename\tSTART\tEND\tpORF_id\tScore\tSTRAND\n"; #print in bed file- Genomename,Start,End,pORF_id,Score,Strand

open(IN, "$genomeFile");  
$seq = "";
$line = <IN>;
while ($line = <IN>) {
   chomp($line);
   $lineLeng = length($line);  #length of genome in base pair 
   if ( $lineLeng > 0 ) {
    $seq = $seq.$line;
   }
}
close(IN);

$seqLength = length($seq);
#print "$seqLength\n";

###Forward strand
$posi = 0;  
$newStart = 0;
$newCod = "";
$newPosi = 0;
$newEnd = 0;
$cod= "";
$stc = "";
$foundSt = 0;

while ($posi < $seqLength -2) {
   $cod = substr($seq,$posi,3);
   for ( $i = 0; $i < 4; $i++ ) {
      if ( $cod eq $STA[$i] ) {
         $newStart = $posi;
         $stc = $cod;
         $foundSt = 1;
         last;
      }
   }

   if ( $foundSt == 1 ) {
         $cod = substr($seq,$posi); 
         for ( $i = 0; $i < 4; $i++ ) {
            if (index($cod,$STA[$i]) != -1 ) {
               $newPosi = $newStart + 3;
               $found = 0;
               while ($newPosi < $seqLength-2) {
                  $newCod = substr($seq,$newPosi,3); 
                  for ( $j = 0; $j < 3; $j++ ) {
                     if ( $newCod eq $STO[$j]) {
                        $newEnd = $newPosi+2;
                        $stnum = $newStart ;
                        $ennum = $newEnd + 1; 
                        $id = "pORF+";
                        #print "$stc\t$newCod\t$newStart\t$newEnd\n";
                        $porfLeng = $newEnd - $newStart +1;
                        print OUT "$id\t$stnum\t$ennum\t+\t$porfLeng\t$stc\t$newCod\n";
                        # BED Format: Genomename\tSTART\tEND\tpORF_id\tScore\tSTRAND
                        if ( $porfLeng >= $minLength and $porfLeng <= $maxLength ) {
                           print BED "$genomeName\t$stnum\t$ennum\t$id\t.\t+\n";
                        }
                        $found = 1;
                        last;
                     }
                  }
                  if ($found == 1 ) {
                     last;
                  }
                  else {
                     $newPosi = $newPosi+3;
                  }
               }
               $foundUP = 1;
            }
            if ($foundUP == 1 ) {
               last;
            }
         }
   }
   $foundSt = 0;
   $posi++;
}

###Reverse strand

$rc = reverse($seq);
@rcToks = split("",$rc);
for ( $i = 0; $i < $seqLength;$i++ ) {
   if ($rcToks[$i] eq "A" ) {
      $rcToks[$i] = "T";
   }
   elsif ($rcToks[$i] eq "T" ) {
      $rcToks[$i] = "A";
   }
   elsif ($rcToks[$i] eq "C" ) {
      $rcToks[$i] = "G";
   }
   elsif ($rcToks[$i] eq "G" ) {
      $rcToks[$i] = "C";
   }
}

$rcSeq = join("",@rcToks);

$posi = 0;
while ($posi < $seqLength -2) {
   $cod = substr($rcSeq,$posi,3); 
   for ( $i = 0; $i < 4; $i++ ) {
      if ( $cod eq $STA[$i] ) {
         $newStart = $posi;
         $stc = $cod;
         $foundSt = 1;
         last;
      }
   }
   if ( $foundSt == 1 ) {
         $cod = substr($rcSeq,$posi);    
         $foundUP = 0;
         for ( $i = 0; $i < 4; $i++ ) {
            if (index($cod,$STA[$i]) != -1 ) {
               $newPosi = $newStart + 3;
   				#print "$newPosi\n";
               $found = 0;
               while ($newPosi < $seqLength-2) {
                  $newCod = substr($rcSeq,$newPosi,3); 
                  for ( $j = 0; $j < 3; $j++ ) {
                     if ( $newCod eq $STO[$j]) {
                        $newEnd = $newPosi+2;
                        $porfLeng = $newEnd -  $newStart + 1; 
                        $newStart = $seqLength - $newStart - 1; 
                        $newEnd = $seqLength - $newEnd - 1;
                        $stnum = $newStart + 1;
                        $ennum = $newEnd ; 
                        $id = "pORF-";
                        #print "$stc\t$newCod\t$newEnd\t$newStart\n";
                        print OUT "$id\t$ennum\t$stnum\t-\t$porfLeng\t$stc\t$newCod\n";
                        if ( $porfLeng >= $minLength and $porfLeng <= $maxLength ) {
                           print BED "$genomeName\t$ennum\t$stnum\t$id\t.\t-\n";
                        }
                        $found = 1;
                        last;
                     }
                  }
                  if ($found == 1 ) {
                     last;
                  }
                  else {
                     $newPosi = $newPosi+3;
                  }
               }
               $foundUP = 1;
            }
            if ($foundUP == 1 ) {
               last;
            }
      }
   }
   $foundSt = 0;
   $posi++;
}

close(OUT);
close(BED);

sub usage {
	die qq(
\n);
}
