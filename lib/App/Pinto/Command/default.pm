# ABSTRACT: mark the default stack

package App::Pinto::Command::default;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Must specify exactly one stack')
        if @{$args} != 1;

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my $result = $self->pinto->run($self->action_name, stack => $args->[0]);

    return $result->exit_status;
}

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT default STACK

=head1 DESCRIPTION

This command marks the given C<STACK> as the default stack for the
repository.  The default stack is used for all L<pinto> commands where
a stack is not explicitly given either by option or argument.

At all times, there is exactly one default stack in the repository.
Use the L<stacks|App::Pinto::Command::stacks> command to list the
stacks that currently exist in the repository and show which one is
the default.

Changing the default stack does not create an event in the revision
history, so the L<revert|App::Pinto::Command::revert> command will not
"undo" this change.  However, you can change the default stack back to
the prior stack at any time just by using this command again.

=head1 BEWARE

Think carefully before changing the default stack.  This will
dramatically affect all users of the repository, so it is wise to
notify them well in advance.

=head1 COMMAND ARGUMENTS

The required argument is the name of the stack you wish to mark as
the default.  The stack must already exist.

=head1 COMMAND OPTIONS

None.

=back

=cut

