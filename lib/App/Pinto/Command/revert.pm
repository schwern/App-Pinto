# ABSTRACT: restore stack to a prior revision

package App::Pinto::Command::revert;


use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw( revert rollback ) }

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'message|m=s'    => 'Message to describe the change'      ],
        [ 'revision|R=i'   => 'Revision number to revert to'        ],
        [ 'stack|s=s'      => 'Revert stack other than the default' ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Multiple arguments are not allowed')
        if @{ $args } > 1;

   if ($args->[0]) {

        my ($stack, $revision) = split /@/, $args->[0], 2;

        # split returns '' for empty fields.  But to make Moose
        # happy, they need to be undef if they really don't exist.

        $opts->{stack}    = $stack    if length $stack;
        $opts->{revision} = $revision if length $revision;
    }

    return 1;
}

#------------------------------------------------------------------------------

1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT revert [OPTIONS]

=head1 DESCRIPTION

This command restores a stack to the state at a prior revision.  That state
becomes the new head revision of the stack.

=head1 COMMAND ARGUMENTS

As an alternative to the C<--stack> and C<--revision> switches, you
also specify them as a single argument. So the following examples are
equivalent:

  pinto --root REPOSITORY_ROOT revert --stack=dev --revision=298
  pinto --root REPOSITORY_ROOT revert dev@298

A C<stack@revision> argument will override anything specified with the
C<--stack> or C<--revision> switches.

If neither the stack nor revision is specified using either the
arguments or switches, then the last revision of the default stack
will be reverted.  So if the default stack is called C<"dev"> then
the following are all equivalent:

  pinto --root REPOSITORY_ROOT revert --stack=dev --revision=-1
  pinto --root REPOSITORY_ROOT revert dev@-1
  pinto --root REPOSITORY_ROOT revert
  pinto --root REPOSITORY_ROOT revert @-1
  pinto --root REPOSITORY_ROOT revert

=head1 COMMAND OPTIONS

=over 4

=item --message=TEXT

=item -m TEXT

Use TEXT as the revision history log message.  At the moment, this is
optional but it will become mandatory in the future.

=item --revision=NUMBER

=item -R NUMBER

The number of the revision that the stack will be reverted to.  If
NUMBER is negative, it means to revert than many revisions from the
current head.

=item --stack NAME

=item -s NAME

Reverts the stack with the given NAME.  Defaults to the name of
whichever stack is currently marked as the default stack.  Use the
L<stacks|App::Pinto::Command::stack> command to see the stacks in the
repository.

=back

=cut
