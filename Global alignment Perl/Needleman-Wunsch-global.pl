#!/pkg/bin/perl -w
#This is the Needleman-Wunsch global alignment algorithm without gaps 

#two counters for gaps, horizontal and virtical, if go diagonal zero out both.


open (OUT, '> outer');         #Open a file called 'outer' for outputing.

print "input match value V \n"; # added match, mismatch, and space costs here
$matchVal = <>;

print "input mismatch cost Cm \n";# added match, mismatch, and space costs here
$mismatchVal = <>;

print "input indel cost Im \n";# added match, mismatch, and space costs here
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
   $V[$i][0] = (-$space)*$i; # added space costs here
   print OUT "$string1[$i-1]";  # Note the -1 here because array indexes start at 0 (ug!)
}
   print OUT "\n\n";

for ($j = 1; $j <= $m; $j++) { # Assign the row 0 values and print String 2
   $V[0][$j] = (-$space)*$j;# addedspace costs here
   print OUT "$string2[$j-1]";
}

for ($i = 1; $i <= $n; $i++) {      # follow the recurrences to fill in the V matrix.
 for ($j = 1; $j <= $m; $j++) {
#   print OUT "$string1[$i-1], $string2[$j-1]\n"; # This is here  for debugging purposes.
   if ($string1[$i-1] eq $string2[$j-1]) {
     $t = 1*$matchVal; } # added match,  costs here
   else {
	$t = -1*$mismatchVal; # added mismatch costs here
   }

  $max = $V[$i-1][$j-1] + $t;  
#  print OUT "For $i, $j, t is $t \n"; # Another debugging line.
  if ($max < $V[$i][$j-1] -1*$space) {# added space costs here
    $max = $V[$i][$j-1] -1*$space; # added space costs here
  }

  if ($V[$i-1][$j] -1*$space > $max) {# added space costs here
    $max = $V[$i-1][$j] -1*$space;# added space costs here
  }
  $V[$i][$j] = $max; # actually assign value to square based on which (diag, horizontal or vertical) gave best value
 print OUT "V[$i][$j] has value $V[$i][$j]\n";
  }
}
print OUT "\n The similarity value of the two strings is $V[$n][$m]\n";

close(OUT);

=begin comment
AATAAGGTTGA

ATAATCGTTAAV[1][1] has value 1
V[1][2] has value -1
V[1][3] has value -3
V[1][4] has value -5
V[1][5] has value -7
V[1][6] has value -9
V[1][7] has value -11
V[1][8] has value -13
V[1][9] has value -15
V[1][10] has value -17
V[1][11] has value -19
V[2][1] has value -1
V[2][2] has value 0
V[2][3] has value 0
V[2][4] has value -2
V[2][5] has value -4
V[2][6] has value -6
V[2][7] has value -8
V[2][8] has value -10
V[2][9] has value -12
V[2][10] has value -14
V[2][11] has value -16
V[3][1] has value -3
V[3][2] has value 0
V[3][3] has value -1
V[3][4] has value -1
V[3][5] has value -1
V[3][6] has value -3
V[3][7] has value -5
V[3][8] has value -7
V[3][9] has value -9
V[3][10] has value -11
V[3][11] has value -13
V[4][1] has value -5
V[4][2] has value -2
V[4][3] has value 1
V[4][4] has value 0
V[4][5] has value -2
V[4][6] has value -2
V[4][7] has value -4
V[4][8] has value -6
V[4][9] has value -8
V[4][10] has value -8
V[4][11] has value -10
V[5][1] has value -7
V[5][2] has value -4
V[5][3] has value -1
V[5][4] has value 2
V[5][5] has value 0
V[5][6] has value -2
V[5][7] has value -3
V[5][8] has value -5
V[5][9] has value -7
V[5][10] has value -7
V[5][11] has value -7
V[6][1] has value -9
V[6][2] has value -6
V[6][3] has value -3
V[6][4] has value 0
V[6][5] has value 1
V[6][6] has value -1
V[6][7] has value -1
V[6][8] has value -3
V[6][9] has value -5
V[6][10] has value -7
V[6][11] has value -8
V[7][1] has value -11
V[7][2] has value -8
V[7][3] has value -5
V[7][4] has value -2
V[7][5] has value -1
V[7][6] has value 0
V[7][7] has value 0
V[7][8] has value -2
V[7][9] has value -4
V[7][10] has value -6
V[7][11] has value -8
V[8][1] has value -13
V[8][2] has value -10
V[8][3] has value -7
V[8][4] has value -4
V[8][5] has value -1
V[8][6] has value -2
V[8][7] has value -1
V[8][8] has value 1
V[8][9] has value -1
V[8][10] has value -3
V[8][11] has value -5
V[9][1] has value -15
V[9][2] has value -12
V[9][3] has value -9
V[9][4] has value -6
V[9][5] has value -3
V[9][6] has value -2
V[9][7] has value -3
V[9][8] has value 0
V[9][9] has value 2
V[9][10] has value 0
V[9][11] has value -2
V[10][1] has value -17
V[10][2] has value -14
V[10][3] has value -11
V[10][4] has value -8
V[10][5] has value -5
V[10][6] has value -4
V[10][7] has value -1
V[10][8] has value -2
V[10][9] has value 0
V[10][10] has value 1
V[10][11] has value -1
V[11][1] has value -19
V[11][2] has value -16
V[11][3] has value -13
V[11][4] has value -10
V[11][5] has value -7
V[11][6] has value -6
V[11][7] has value -3
V[11][8] has value -2
V[11][9] has value -2
V[11][10] has value 1
V[11][11] has value 2

 The similarity value of the two strings is 2
