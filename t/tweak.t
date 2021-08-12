use strict;
use warnings;
use Test::More;
use DOS::VGA::Tweak;
use Data::Dumper qw( Dumper );

sub expected ($)
{
  my($filename) = @_;
  my $fh;
  open $fh, '<', $filename;
  binmode $fh;
  my @lines = <$fh>;
  close $fh;
  chomp @lines;
  return @lines;
}

subtest 'basic' => sub {
  my $tweak = DOS::VGA::Tweak->new('corpus/320X240.256');
  isa_ok $tweak, 'DOS::VGA::Tweak';

  subtest 'to_c_struct' => sub {

    note $tweak->to_c_struct('Mode320x240');

    my @actual   = split /\n/, $tweak->to_c_struct('Mode320x240');
    my @expected = expected 'corpus/320X240.C';

    for(my $i=0; $i < @expected; $i++)
    {
      is $actual[$i], $expected[$i], "line $i";
    }
  };

  subtest 'to_c_function' => sub {

    note $tweak->to_c_function;
    pass 'okay';
  };

};

done_testing;


