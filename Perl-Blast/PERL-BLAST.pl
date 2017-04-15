
#!/pkg/bin/perl -w
# Program kmerfirst.pl
# This program finds all the overlapping k-mers of the input string. It builds
# an associative array where each key is one distinct k-mer in the string,
# and the associated value is the starting position where that
#k-mer is FIRST found.  Compare this to kmer2.pl


use warnings;


# Query file open!!!
open(DATA, "<query.txt")
  or die;
  $/ = "";
  $dna1 = <DATA>;


 chomp $dna1;
  chomp $dna1;
 
$k = 4; # 4-mer :) used to seed

#--------------------------------------------------------------
#Query string kmer hash
#--------------------------------------------------------------
%kmer = ();                      # This initializes the hash called kmer.
$i = 1;
while (length($dna1) >= $k) {
  $dna1 =~ m/(.{$k})/; 
  print "$1, $i \n";
    if (! defined $kmer{$1}) {
    $kmer{$1} = [$i];    # here we tell Perl that the value of a kmer entry will
                         # be an array. This is done by enclosing $i with [ ].
                         # More correctly, $kmer{$1} is a reference to an array
                         # whose first value is the value of $i.
   }
 else { push (@{$kmer{$1}}, $i)}  # here we expand the array associated with key
                                  # value $1 by adding another
                                  # element to the array.  We first have to dereference
                                  # the reference $kmer{$1} which is done by enclosing
                                  # it with curly brackets.

  $i++;
$dna1 = substr($dna1, 1, length($dna1) -1);
}

foreach $kmerkey (sort keys(%kmer)) {
 $occrs = join(', ' , @{$kmer{$kmerkey}});
 print "The occurrences of string $kmerkey are in positions $occrs \n";
}
#--------------------------------------------------------------
#Database strings kmer hash
#--------------------------------------------------------------
         %stringhash = (); # for storing matches in the database and preventing HPS repeats
# blast data file open!!!
my $file = 'genbank.txt';
open my $info, $file or die;
$/ = "";
while( my $DNAline = <$info>)  {   


 #prints which line in the database we are checking the query against. 
    print "*********** \n Database DNA: $DNAline \n*********** ";    
  
   $dna2 = $DNAline;
  $currentLine = $DNAline; #for later checking aginst the whole line:
  

$i = 1;
while (length($dna2) >= $k) {
  $dna2 =~ m/(.{$k})/; 
  
  #if defined comes back true, we have a match :)
   if (defined $kmer{$1}) {     

 foreach $a (@{$kmer{$1}}){



   #prints the hash index location where the match occurs
   # print "$1, $i \n";  #for testing
   open(TEMP, "<query.txt")
  or die;
  $dnaTemp = <TEMP>;
 chomp $dnaTemp;
 
 
    #expanding backward from kmer match on both query and database string
    #we know we have a kmer sized match so we should match 4 positions beyond this
    #original query string from position to end
        
        
     #need a section here which for loops through the array in the $kmer location   
        
        
        
        
    $position1 = ($a+3);
    $subStringPosition1 = substr($dnaTemp, $position1) ;
     @string1 =  split(//, $subStringPosition1);
    
    # current line of the database at the same kmer location 
    #(index that location and then place the relavent characters in an array)
       $local1 =  index ($currentLine,  $1);
       $local1 = $local1+4;
       $databaseForward = substr($currentLine,  $local1);
       chomp $databaseForward;
       @string2=  split(//, $databaseForward);
    
   
   #expanding forward from kmer match on both query and database string
   
        #we know we have a kmer sized match so we should match 1 positions before this
        #original query string from position to beginning
        #will need to reverse order too
    $position2 = ($a-1);
    $subStringPosition2 = substr($dnaTemp, 0, $position2) ;
    $subStringPosition2Reversed = scalar reverse ($subStringPosition2);
    @string3 =  split(//, $subStringPosition2Reversed);
    
    
     # current line of the database at the same kmer location  going forwards
    #(index that location and then place the relavent characters in an array)
       $local1 =  index ($currentLine,  $1);
       $databaseReverse = substr($currentLine, 0, $local1);
       $databaseReverse = scalar reverse ($databaseReverse);
       @string4 =  split(//, $databaseReverse);
       
       
       #---------------------------------
       #HSP finder
       #---------------------------------
    
    #this allows the string match not to exceed the shorter string
     $n = @string1; 
     $m = @string2;
     $x = 0;
      if  ($n >= $m) {
       $x = $m;
       } else {
        $x = $n;
        }
      $counter1 = 0; #  in one direction.
      $counter2= 0; #  in other direction.
      
      my $match = 1; #cant keep counting once a mismatch is found
      for ($i = 1; $i < $x+1; $i++) {
      if ($string1[$i-1] eq $string2[$i-1] ){ if ($match == 1){ 
           $counter1++; } else {$match = 0;} } else { $match = 0; }
         }
   

         
     #this allows the string match not to exceed the shorter string (done again for the opposite direction)
     $n = @string3; 
     $m = @string4;
     $x = 0;
      if  ($n >= $m) {
       $x = $m;
       } else {
        $x = $n;
        }

       $match = 1; #cant keep counting once a mismatch is found (reset it)
      for ($i = 1; $i < $x+1; $i++) {
       
          if ($string3[$i-1] eq $string4[$i-1] ){ if ($match == 1){ 
           $counter2++ ; } else {$match = 0;} } else { $match = 0; }

         }
         

         #only report counts of 11 or more. add up both directions
         $counter = 4 + $counter1 + $counter2;
         

         

      

     
       #---------------------------------
       #HSP not over reporting
       #---------------------------------
       
       
     
         # current line of the database at the same kmer location 
		#(index that location and then place the relavent characters in an array)
#local1 is the position in the database where this string is found
       $local1 =  index ($currentLine,  $1);

       
       $stringEnd = 4 + $counter1;
       $databaseForward = substr($currentLine, $local1,  $stringEnd);
       #chomp $databaseForward;

#counter2
     # current line of the database at the same kmer location  going forwards
    #(index that location and then place the relavent characters in an array)
       $local1 =  index ($currentLine,  $1);
       $startPoint = $local1 - $counter2;
      $length2 = $counter2;
       $databaseReverse = substr($currentLine, $startPoint, $length2);


     #full string match
        $fullMatch = $databaseReverse.$databaseForward;



#start location in original query
$QuerystartPoint = $a - $counter2;
     
     #concatinate the full match with the start point in the search query allowing for two different matches in the search to be stored uniquely.
     $fullMatchUnique = $QuerystartPoint.$fullMatch;
     
     
     
    if( $counter > 10){

      if (!defined $stringhash{$fullMatchUnique}) { 
       $stringhash{$fullMatchUnique} = $startPoint;
       print "a good HSP has been found between the query and the database: \n $currentLine \n";
       print "match of $fullMatch at location $QuerystartPoint in Search term \n";
       
                    }
       
      }

       }
       
   }
   
 $i++;
  $dna2 = substr($dna2, 1, length($dna2) -1);
}

}

close $info;
#----------------------------------------------------------------