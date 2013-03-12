# ABSTRACT: show or set stack properties

package App::Pinto::Command::props;

use strict;
use warnings;

use Pinto::Util qw(interpolate);

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {

  return (
      [ 'format=s' => 'Format specification (See POD for details)' ],
      [ 'properties|prop|P=s%' => 'name=value pairs of properties' ],
  );
}

#------------------------------------------------------------------------------


sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Cannot specify multiple stacks')
        if @{$args} > 1;

    $opts->{format} = interpolate( $opts->{format} )
        if exists $opts->{format};

    $opts->{stack} = $args->[0]
        if $args->[0];

    $opts->{no_color} = $self->app->global_options->{no_color};

    return 1;
}

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT props [OPTIONS] [STACK]

=head1 DESCRIPTION

This command shows or sets stack configuration properties.  If the
C<--properties> option is given, then the properties will be set.  If
the C<--properties> option is not given, then properties will just be
shown.

=head1 COMMAND ARGUMENTS

If the C<STACK> argument is given, then the properties for that stack
will be set/shown.  If the C<STACK> argument is not given, then
properties for the default stack will be set/shown.


=head1 COMMAND OPTIONS

=over 4

=item --format=FORMAT_SPECIFICATION

Format the output using C<printf>-style placeholders.  This only
matters when showing properties.  Valid placeholders are:

  Placeholder    Meaning
  -----------------------------------------------------------------------------
  %p             Property name
  %v             Package value

=item --properties name=value

=item --prop name=value

=item -P name=value

Specifies property names and values.  You can repeat this option to
set multiple properties.  If the property with that name does not
already exist, it will be created.  Property names must be
alphanumeric plus hyphens and underscores, and will be forced to
lower case.  Setting a property to an empty string will cause it 
to be deleted.

Properties starting with the prefix C<pinto-> are reserved for
internal use, SO DO NOT CREATE OR CHANGE THEM.

=back

=cut
