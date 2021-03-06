# DOS::VGA::Tweak ![static](https://github.com/uperl/DOS-VGA-Tweak/workflows/static/badge.svg) ![linux](https://github.com/uperl/DOS-VGA-Tweak/workflows/linux/badge.svg)

Read a VGA register tweak file

# SYNOPSIS

```perl
my $tweak = DOS::VGA::Tweak->new($filename);

# create a tweak file that can be included into
# your C application
open my $fh, '>', 'tweak.c';
print $fh $tweak->to_c_struct;
close $fh;
```

# DESCRIPTION

This module is designed to work with VGA Tweak files generated by
Robert Schmidt's TWEAK.  This allows generating data and code which
can be used in your MS-DOS application to enter various creative and
undocumented VGA modes, like the famous Mode-X.

# CONSTRUCTOR

## new

```perl
my $tweak = DOS::VGA::Tweak->new($filename);
```

The constructor takes a single argument: the filename of the tweak
file.

# METHODS

## to\_c\_struct

```perl
my $c_code = $tweak->to_c_struct;
my $c_code = $tweak->to_c_struct($name);
```

This converts the tweak data into a C struct which can be used with
`TWKUSR` based applications.  This is the equivalent to the `TWEAK2C`
application.  The output should be equivalent C code, but may vary in
spacing.

# SEE ALSO

[http://bbc.nvg.org/private/programming.html](http://bbc.nvg.org/private/programming.html)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
