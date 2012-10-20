# ABSTRACT: delete a stack

package App::Pinto::Command::delete;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw(delete del rm) }

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

  pinto --root=REPOSITORY_ROOT delete [OPTIONS] STACK

=head1 DESCRIPTION

This command permanently deletes a stack.  Once a stack is deleted,
there is no way to get it back.  However, any distributions that were
registered on the stack will always remain in the repository.

The stack that is currently marked as the default can never be
deleted.  If you wish to delete it, you must first mark another stack
as the default. Use the L<edit|App::Pinto::Command::edit> command
to control which stack is the default.

=head1 COMMAND ARGUMENTS

The required argument is the name of the stack you wish to delete.
Stack names must be alphanumeric plus hyphens and undersocres, and
are not case-sensitive.


=head1 COMMAND OPTIONS

None.

=cut

