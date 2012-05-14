# ABSTRACT: show the index for a stack

package App::Pinto::Command::index;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Cannot specify multiple stacks')
        if @{ $args } > 1;

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my $stack = $args->[0];
    my $result = $self->pinto->run($self->action_name, stack => $stack);

    return $result->exit_status;
}

#------------------------------------------------------------------------------

1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT index [STACK]

=head1 DESCRIPTION

This command shows the index of a stack.  Unlike the
L<list|App::Pinto::Command::list> command, this command shows the
index exactly as it would appear to an installer client.

=head1 COMMAND ARGUMENTS

The argument is the name of the stack you wish to see the index for.
If you do not specify a stack, it defaults to whichever stack is
marked as the default.  Stack names must be alphanumeric (including
"-" or "_") and will be forced to lowercase.

=head1 COMMAND OPTIONS

None.

=cut
