#!/usr/bin/perl

use strict;
use utf8;
use warnings;
use FindBin;
use Getopt::Long;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

open PC, "slovar_pc" or die $!;
binmode(PC, ':utf8');

open UMC, "raw_umc" or die $!;
binmode(UMC, ':utf8');

read_umc();
read_pc();


my %pair_umc; #my @czech_words;
sub read_umc{
 while(<UMC>){
 chomp;
 my($frequency_umc, $czech_word_umc, $russian_word_umc) = split /\t/;
 $czech_word_umc =~ s/-.+//; 
 $czech_word_umc =~ s/_.+//;
 $pair_umc{$czech_word_umc."\t".$russian_word_umc} = $frequency_umc;
 }
}

my %pair_pc;
sub read_pc{
 while(<PC>){
 chomp;
 
 my($czech_word_pc, $russian_word_pc) = split /\t/;
 $pair_pc{$czech_word_pc."\t".$russian_word_pc} = $czech_word_pc;
 }
}

my%ambig; my %seen_czech = (); my @uniq_czech=();
foreach my $umc (sort hashValueAscendingNum (keys(%pair_umc))){
 if (exists $pair_pc{$umc}){
 my ($czech, $russian) = split(/\t/, $umc);
 $ambig{$czech}{$russian} = $pair_umc{$umc}; 
 print "$czech\t$russian\t$pair_umc{$umc}\n";
    
         #print "$czech | ";
         #for $russian (sort keys %{ $ambig{$czech} } ){
         #    print "$russian | $ambig{$czech}{$russian}\n";
         #}
  #             print "\n";   
              
     
    
  } 
 
}

#Tady jeste musime najit absolutni frekvenci ceskych slov z umc, aby bylo videt (hm, je to hodne trivialni),
#ze cim je slovo frekventovanejsi, tim vice ma moznosti prekladovych paru (a spravnych prekladovych paru).
#absolutni frekvence - kolikrat se slovo s necim sparovalo.


sub hashValueAscendingNum {
   $pair_umc{$b} <=> $pair_umc{$a};
}



#while(my ($pairumc, $frequency_umc) = each%pair_umc) {
#  print "$pairumc\n";
#  while (my ($pairpc, $frequency_pc) = each %pair_pc){
  #print "$pairpc\n";
#   if ($pairumc eq $pairpc) {
  # print "$pairumc\n";
#   } 
#  } 
#}


