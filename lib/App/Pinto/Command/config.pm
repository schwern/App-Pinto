# ABSTRACT: show or set configuration properties

package App::Pinto::Command::config;

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

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my %stack = $args->[0] ? (stack => $args->[0]) : ();
    my %props = $opts->{properties} ? (properties => $opts->{properties}) : ();
    my $result = $self->pinto->run($self->action_name, %stack, %props);

    return $result->exit_status;
}

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT config [OPTIONS] [STACK]

=head1 DESCRIPTION

This command shows or sets configuration properties.  If the
C<--properties> option is given, then the properties will be set.  If
the C<--properties> option is not given, then properties will just be
shown.

If the C<STACK> argument is given, then the properties for the stack
will be set/shown.  If the C<STACK> argument is not given, then global
properties for the repository will be set/shown.


=head1 COMMAND OPTIONS

=over 4

=item --format=FORMAT_SPECIFICATION

Format the output using C<printf>-style placeholders.  This only
matters when showing properties.  Valid placeholders are:

  Placeholder    Meaning
  -----------------------------------------------------------------------------
  %n             Property name
  %v             Package value

=item --properties name=value

=item --prop name=value

=item -P name=value

Specifies property names and values.  You can repeat this option to
set multiple properties.  If the property with that name does not
already exist, it will be created.  Property names must be
alphanumeric plus hyphens and underscores, and will be forced to
lower case.

Properties starting with the prefix C<pinto-> are reserved for
internal use, SO DO NOT CREATE OR CHANGE THEM.  At present there is no
way to delete a property -- you can only set them to an empty string.

=back

=cut

