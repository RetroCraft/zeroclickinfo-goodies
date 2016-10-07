#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'scrabble_score';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($score, $word) = @_;
    
    $word =~ tr/a-z/A-Z/;
    
    my $point_plural = ($score == 1 ? "point" : "points");

    return qq($word is worth $score Scrabble $point_plural.),
        structured_answer => {
            data => {
                title    => $score,
                subtitle => "Scrabble score: $score"
            },

            templates => {
                group => 'text'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::ScrabbleScore )],
    # Basic tests
    'scrabble duckduckgo' => build_test(25, 'duckduckgo'),
    'scrabble score duckduckgo' => build_test(25, 'duckduckgo'),
    
    # Quotes should not affect result
    'scrabble "duckduckgo"' => build_test(25, 'duckduckgo'),
    'scrabble \'duckduckgo\'' => build_test(25, 'duckduckgo'),
    
    # Inclusion of "of" should not affect result
    'scrabble score of duckduckgo' => build_test(25, 'duckduckgo'),
    
    # No word does not trigger
    'scrabble' => undef,
    
    # Multiple words does not trigger
    'scrabble duckduckgo duckduckgo' => undef
);

done_testing;
