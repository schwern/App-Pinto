# ABSTRACT: permanently delete a stack

package App::Pinto::Command::kill;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw(kill) }

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

    my $result = $self->pinto->run($self->action_name, %{$opts},
                                                       stack => $args->[0]);

    return $result->exit_status;
}

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT kill STACK

=head1 DESCRIPTION

This command permanently deletes a stack and its entire revision
history.  Once a stack is killed, there is no way to get it back.
However, any distributions that were registered on the stack will
still remain in the repository.

=head1 COMMAND ARGUMENTS

The required argument is the name of the stack you wish to delete.
Stack names must be alphanumeric plus hyphens and undersocres, and
are not case-sensitive.

=head1 COMMAND OPTIONS

None.

=cut

