package DOS::VGA::Tweak;

use strict;
use warnings;
use Carp qw( croak );
use 5.008008;

use constant ATTRCON_ADDR    => 0x3c0;
use constant MISC_ADDR       => 0x3c2;
use constant VGAENABLE_ADDR  => 0x3c3;
use constant SEQ_ADDR        => 0x3c4;
use constant GRACON_ADDR     => 0x3ce;
use constant CRTC_ADDR       => 0x3d4;
use constant STATUS_ADDR     => 0x3da;

# ABSTRACT: Read a VGA register tweak file
# VERSION

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 CONSTRUCTOR

=head2 new

 my $tweak = DOS::VGA::Tweak->new($filename);

=cut

sub new
{
  my($class, $filename) = @_;
  croak "no filename given" unless defined $filename;
  croak "unable to read $filename" unless -r $filename;
  my $fh;
  open $fh, '<', $filename or croak "error reading $filename $!";
  binmode $fh;
  my $raw = do { local $/; <$fh> };
  close $fh or croak "error closing $filename $!";
  croak "bad format $filename: file is not divisible by 4" if length($raw) % 4;
  my @list = unpack "(vCC)*", $raw;

  my $self = bless {}, $class;

  while(@list)
  {
    my($port, $index, $value) = splice @list, 0, 3;
    push @{ $self->{data} }, [$port, $index, $value];
  }

  return $self;
}

=head1 METHODS

=head2 to_c_struct

 my $c_code = $tweak->to_c_struct;

=cut

sub to_c_struct
{
  my($self, $array) = @_;
  $array = 'tweak_registers' unless defined $array;
  my $str = "#include \"TwkUser.h\" // get Register definition\nRegister $array\[] =\n{\n";

  my @data = @{ $self->{data} };
  my $last = pop @data;

  foreach my $entry (@data)
  {
    my($port, $index, $value) = @$entry;
    $str .= sprintf "  { 0x%x, 0x%x, 0x%x },\n", $port, $index, $value;
  }

  {
    my($port, $index, $value) = @$last;
    $str .= sprintf "  { 0x%x, 0x%x, 0x%x }\n", $port, $index, $value;
  }
  $str .= "};";

  return $str;
}

1;
