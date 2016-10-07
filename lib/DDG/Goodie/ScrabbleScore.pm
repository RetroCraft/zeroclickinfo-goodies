package DDG::Goodie::ScrabbleScore;
# ABSTRACT: Generates the worth of a word in Scrabble

use DDG::Goodie;
use Text::Trim;
use strict;
use warnings;

zci answer_type => 'scrabble_score';
zci is_cached => 1;

triggers any => 'scrabble', 'scrabble score';

# Handle statement
handle remainder => sub {    
    my ($word) = @_;
    
    # To upper case
    $word = uc $word;
    
    # Remove "of"
    $word =~ s/^\s*OF\b//;
    
    # Remove spaces
    $word = trim($word);
    
    # Remove quotes
    $word =~ s/^["'](.*)["']$/$1/;
    
    return unless $word =~ /^[A-Z]+$/;
    
    # Letter values
    my @letter_values;
    $letter_values[$_] //= 1 for ord('L'), ord('S'), ord('U'), ord('N'), ord('R'), ord('T'), ord('O'), ord('A'), ord('I'), ord('E');
    $letter_values[$_] //= 2 for ord('G'), ord('D');
    $letter_values[$_] //= 3 for ord('B'), ord('C'), ord('M'), ord('P');
    $letter_values[$_] //= 4 for ord('F'), ord('H'), ord('V'), ord('W'), ord('Y');
    $letter_values[$_] //= 5 for ord('K');
    $letter_values[$_] //= 8 for ord('J'), ord('X');
    $letter_values[$_] //= 10 for ord('Q'), ord('Z');
    
    # Calculate score
    my $score = 0;
    foreach my $letter (split('', $word)) {
        $score += @letter_values[ord($letter)];
    }
    
    # Proper grammar of the word "point" 
    my $point_plural = ($score == 1 ? "point" : "points");

    return "$word is worth $score Scrabble $point_plural.",
        structured_answer => {
            data => {
                title => "$score $point_plural",
                subtitle => "Scrabble score of $word"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
      };
};

1;
