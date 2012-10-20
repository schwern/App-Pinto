# ABSTRACT: change stack properties

package App::Pinto::Command::edit;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {

    return (
        ['default'              => 'mark stack as the default'     ],
        ['properties|prop|P=s%' => 'name=value pairs of properties'],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Cannot specify multiple stacks')
        if @{$args} > 1;

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my $stack = $args->[0];
    my $result = $self->pinto->run($self->action_name, %{$opts},
                                                       stack => $stack);

    return $result->exit_status;
}

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT edit [OPTIONS] [STACK]

=head1 DESCRIPTION

This command edits the properties of a stack.  See the
L<props|App::Pinto::Command::props> command to display stack
properties.

=head1 COMMAND ARGUMENTS

The argument is the name of the stack you wish to edit the properties
for.  If you do not specify a stack, it defaults to whichever stack
is currently marked as default.  Stack names must be alphanumeric
plus hyphens and underscores, and are not case-sensitive.

=head1 COMMAND OPTIONS

=over 4

=item --default

Causes the selected stack to be marked as the "default".  The
default stack becomes the default for all operations where you do no
not specify an explicit stack.  The default stack also governs the
static index file for your repository.  DO NOT CHANGE THE DEFAULT STACK
WITHOUT DUE DILLIGENCE.  It has broad impact, especially if your
repository has multiple users.

=item --properties name1=value1

=item --prop name1=value1

=item -P name1=value1

Specifies property names and values.  You can repeat this option
to set multiple properties.  If the property with that name does
not already exist, it will be created.  Property names must be
alphanumeric plus hyphens and underscores, and are not case
sensitive.  Properties starting with the prefix 'pinto-' are reserved
for internal use, SO DO NOT CHANGE THEM.

=back

=cut

