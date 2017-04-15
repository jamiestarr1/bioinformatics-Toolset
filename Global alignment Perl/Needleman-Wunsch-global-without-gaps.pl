#!/pkg/bin/perl -w
#This is the Needleman-Wunsch global alignment algorithm without gaps 
#in the model and
#with match value = 1, and mismatch and indel value = -1.
#dg
open (OUT, '> outer');         #Open a file called 'outer' for outputing.

print "input match value V \n";
$matchVal = <>;

print "input mismatch cost Cm \n";
$mismatchVal = <>;

print "input indel cost Im \n";
$space = <>;

print "Input string 1 \n";
$line = <>;
chomp $line;
@string1 =  split(//, $line);  #split up the line into individual characters
                               #and place the characters into a list, whose
                               #first index is 0 (here Perl has inherited
                               #one of the worst features of C) See Johnson
                               # 4.3 for an introduction to lists.  Look up
                               # split in the index and read it.

print "Input string 2 \n";
$line = <>;
chomp $line;
@string2 =  split(//, $line);

$n = @string1;                 #assigning a list to a scalar just assigns the
                               #number of elements in the list to the scalar.
$m = @string2;

print "The lengths of the two strings are $n, $m \n";   # Just to make sure this works.

$V[0][0] = 0;                  # Assign the 0,0 entry of the V matrix

for ($i = 1; $i <= $n; $i++) { # Assign the column 0  values and print 
                               # String 1  See section 5.2 of Johnson
                               # for loops
   $V[$i][0] = (-$space)*$i;
   print OUT "$string1[$i-1]";  # Note the -1 here because array indexes start at 0 (ug!)
}
   print OUT "\n\n";

for ($j = 1; $j <= $m; $j++) { # Assign the row 0 values and print String 2
   $V[0][$j] = (-$space)*$j;
   print OUT "$string2[$j-1]";
}

$booleanGap=0;

for ($i = 1; $i <= $n; $i++) {      # follow the recurrences to fill in the V matrix.
 for ($j = 1; $j <= $m; $j++) {
#   print OUT "$string1[$i-1], $string2[$j-1]\n"; # This is here  for debugging purposes.
   if ($string1[$i-1] eq $string2[$j-1]) {
     $t = 1*$matchVal; }
   else {
	$t = -1*$mismatchVal;
   }

  $max = $V[$i-1][$j-1] + $t;  
#  print OUT "For $i, $j, t is $t \n"; # Another debugging line.
  
  
  if ($max < $V[$i][$j-1] -1*$space) {
    if (!$booleanGap){
	$max = $V[$i][$j-1] -1*$space;
	$booleanGap = 1;
	} else {
		$booleanGap = 0;
		}	
  }

  if ($V[$i-1][$j] -1*$space > $max) {
        if (!$booleanGap){
	$max = $V[$i-1][$j] -1*$space;
		$booleanGap = 1;
		} else {
		$booleanGap = 0;
		}
  }
  
  
  
  $V[$i][$j] = $max; # actually assign value to square based on which (diag, horizontal or vertical) gave best value
 print OUT "V[$i][$j] has value $V[$i][$j]\n";

  
  }
}
print OUT "\n The similarity value of the two strings is $V[$n][$m]\n";

close(OUT);
