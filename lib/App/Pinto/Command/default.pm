# ABSTRACT: mark the default stack

package App::Pinto::Command::default;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return ( [ 'none' => 'Unmark the default stack' ] );
}

#-----------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Cannot specify multiple stacks')
        if @{$args} > 1;

    $self->usage_error('Must specify a STACK or --none')
        if ! ( @{$args} xor $opts->{none} );

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
  pinto --root=REPOSITORY_ROOT default --none

=head1 DESCRIPTION

This command marks the given C<STACK> as the default stack for the
repository.  The existing default stack (if one exists) is thereby
unmarked as the default.  The default stack is used by most L<pinto>
commands where a stack is not explicitly specified either by option or
argument.

If the C<--none> option is given instaed of a C<STACK> argument, then
the default stack is unmarked as the default (if one exists).  If the
repository has no default stack, then you will have to explicitly
specified the stack as option or argument for most L<pinto> commands.

Changing the default stack does not create an event in the revision
history, so the L<revert|App::Pinto::Command::revert> command will not
"undo" this change.  However, you can change the default stack back at
any time just by using this command again.

Use the L<stacks|App::Pinto::Command::stacks> command to list the
stacks that currently exist in the repository and show which one is
the default.

=head1 BEWARE

Think carefully before changing the default stack.  This will
dramatically affect all users of the repository, so it is wise to
notify them well in advance.

=head1 COMMAND ARGUMENTS

The argument is the name of the stack you wish to mark as the default.
The stack must already exist.  A stack argument cannot be used when the
C<--none> option is specified.

=head1 COMMAND OPTIONS

=over 4

=item --none

Unmarks the default stack (if one exists).  This option cannot be used
when the C<STACK> argument is specified.

=back


=back

=cut

