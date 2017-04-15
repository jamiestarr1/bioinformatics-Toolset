#!/pkg/bin/perl -w

print "type the input file name please\n";
open (INFO, <>);  

print "type the output file name please\n";
$myoutfile = <>;  
open (OUTFO, "> $myoutfile"); 

$line = <INFO>;
@matches = $line =~ m/.*?ACCESSION.*?([A-Z]{1,2}\d{3,7})[ ,.;:?]/g;  

print OUTFO "$_\n" for @matches;


#print OUTFO "$1.  \n"; 

#The input line does contain what looks like a dna sequence of length at least three, and it is ACC 
#The input line is 
#The primary ACCESSION number might be something like U63121 or maybe the ACCESSION is FA10325, or the ACCESSION is PQ3469. I don't know what the sequences are for these numbers. Maybe they are atcGGGAcatcaGGG or maybe not. Is this another ACCESSION number NO9978 or is it a telephone number. Perhaps XYzCATCGGAPQ is a DNA string? What will the program do with it? Is that what you want it to do? 



