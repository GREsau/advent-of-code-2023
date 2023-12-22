#!/usr/bin/perl
use strict;
use warnings;
use v5.32;
use autodie;
use Data::Dumper;

sub pushUniq {
    my %hash = map { $_, 1 } @{$_[0]};
    push @{(shift)}, (grep !$hash{$_}++, @_);
}

my @inputBricks;
my $lineNum = 1;

open(my $fh, "<", "input.txt");
while (<$fh>) {
  my ($x0, $y0, $z0, $x1, $y1, $z1) = ($_ =~ /(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/);
  my @temp = $x0..$x1;

  push @inputBricks, {
    lineNum => $lineNum,
    xRange => [$x0..$x1],
    yRange => [$y0..$y1],
    zRange => [$z0..$z1]
  };

  $lineNum++;
}
close($fh);

@inputBricks = sort { $a->{zRange}->[0] <=> $b->{zRange}->[0] } @inputBricks;

my %settledBricks;
my @criticalBricks;

for my $inputBrick (@inputBricks) {
  my $lineNum = $inputBrick->{lineNum};
  my $xRange = $inputBrick->{xRange};
  my $yRange = $inputBrick->{yRange};
  my $zRange = $inputBrick->{zRange};

  my $height = $zRange->[0];
  my $potentialFall = 1;
  my @supportingBricks;

  while ($potentialFall < $height) {
    for my $x (@$xRange) {
      for my $y (@$yRange) {
        for my $z0 (@$zRange) {
          my $z = $z0 - $potentialFall;
          my $p = "$x,$y,$z";

          if (exists($settledBricks{$p})) {
            pushUniq \@supportingBricks, $settledBricks{$p};
          }
        }
      }
    }

    last unless (scalar @supportingBricks == 0);

    $potentialFall++;
  }

  if (scalar @supportingBricks == 1) {
    pushUniq \@criticalBricks, @supportingBricks;
  }

  my $actualFall = $potentialFall-1;

  for my $x (@$xRange) {
    for my $y (@$yRange) {
      for my $z0 (@$zRange) {
        my $z = $z0 - $actualFall;
        my $p = "$x,$y,$z";

        if (exists($settledBricks{$p})) {
          print "ERROR! $p is already $settledBricks{$p}, can't add $lineNum!\n";
        } else {
          $settledBricks{$p} = $lineNum;
        }
      }
    }
  }
}

my $unneededBricks = scalar @inputBricks - scalar @criticalBricks;

print "Part 1: $unneededBricks";
