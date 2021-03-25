#! /usr/bin/perl
# Alexander Bartholomäus - 
# Email: bartholomaeus.alexander@gmail.com
### Script to extract middle nucleotide for each sequencing read of BAM file
# usage: samtools view input.bam -h | perl parse_readMiddle.pl | samtools view -Sb | samtools sort - out; samtools index out.bam 
# short usage (without sorting): samtools view input -h | perl parse_readMiddle.pl | samtools view -bS > out.bam

use strict;
use warnings;


while(<STDIN>){
	my $in=$_;
#	print $in;	# debug
	# all lines not starting with @ (header)
	if($in =~ m/^[^@]/) {
		my @splitter=split(/\t/,$in);
		#print $splitter[0]."\n";	# debug
		# if mapped to F
		if($splitter[1] == 0) {
			# for F genes go one to the right if odd number
			my $mid=(length($splitter[9])+(length($splitter[9])%2))/2;
			print $splitter[0]."\t".$splitter[1]."\t".$splitter[2]."\t".($splitter[3]+$mid)."\t".$splitter[4]."\t1M\t".$splitter[6]."\t".$splitter[7]."\t".$splitter[8]."\t".substr($splitter[9],($mid-1),1)."\t".substr($splitter[10],($mid-1),1)."\n";
		}
		# if mapped to reverse
		elsif($splitter[1] == 16) {
			# for R genes go one to the left if odd number
			my $mid=(length($splitter[9])-(length($splitter[9])%2))/2;
			print $splitter[0]."\t".$splitter[1]."\t".$splitter[2]."\t".($splitter[3]+$mid)."\t".$splitter[4]."\t1M\t".$splitter[6]."\t".$splitter[7]."\t".$splitter[8]."\t".substr($splitter[9],($mid-1),1)."\t".substr($splitter[10],($mid-1),1)."\n";
		}
	}
	# should be the header
	else {
		print $in;
	}
}

exit;
