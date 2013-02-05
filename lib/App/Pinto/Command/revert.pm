# ABSTRACT: restore stack to a prior commit

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
        [ 'commit|c=s'     => 'Commit to revert to'                 ],
        [ 'dryrun'         => 'Do not commit any changes'           ],
        [ 'message|m=s'    => 'Message to describe the change'      ],
        [ 'stack|s=s'      => 'Revert stack other than the default' ],
        [ 'use-default-message|M' => 'Use the generated message'    ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Multiple arguments are not allowed')
        if @{ $args } > 1;

   if ($args->[0]) {

        my ($stack, $commit) = split /@/, $args->[0], 2;

        # split returns '' for empty fields.  But to make Moose
        # happy, they need to be undef if they really don't exist.

        $opts->{stack}  = $stack  if length $stack;
        $opts->{commit} = $commit if length $commit;
    }

    return 1;
}

#------------------------------------------------------------------------------

1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT revert [STACK[@COMMIT]] [OPTIONS]

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

This command restores a stack to a prior commit by patching the head
of the stack so it match the state at the prior commit.

=head1 COMMAND ARGUMENTS

As an alternative to the C<--stack> and C<--commit> options, you
can also specify them as a single argument. So the following examples
are equivalent:

  pinto --root REPOSITORY_ROOT revert --stack=dev --commit=9ef38
  pinto --root REPOSITORY_ROOT revert dev@9ef38

A C<STACK@COMMIT> argument will silently override anything specified
with the C<--stack> or C<--commit> options.

If neither the stack nor commit is specified using neither arguments
nor options, then the last commit of the default stack will be
reverted.  So if the default stack is called C<dev> and the previous
commit was C<9ef38>, then all the following would be equivalent:

  pinto --root REPOSITORY_ROOT revert --stack=dev --commit=9ef38
  pinto --root REPOSITORY_ROOT revert dev@9ef38
  pinto --root REPOSITORY_ROOT revert dev
  pinto --root REPOSITORY_ROOT revert

=head1 COMMAND OPTIONS

=over 4

=item --commit=ID

=item -c ID

The ID commit that the stack will be reverted to.  The ID may be
abbreviated to uniqueness, but can be no less than four characters.

=item --dryrun

Go through all the motions, but do not actually commit any changes to
the repository.  Use this option to see how the command would
potentially impact the stack.

=item --message=TEXT

=item -m TEXT

Use TEXT as the revision history log message.  If you do not use the
C<--message> option or the C<--use-default-message> option, then you
will be prompted to enter the message via your text editor.  Use the
C<EDITOR> or C<VISUAL> environment variables to control which editor
is used.  A log message is not required whenever the C<--dryrun>
option is set, or if the action did not yield any changes to the
repository.

=item --stack NAME

=item -s NAME

Reverts the stack with the given NAME.  Defaults to the name of
whichever stack is currently marked as the default stack.  Use the
L<stacks|App::Pinto::Command::stacks> command to see the stacks in the
repository.

=item --use-default-message

=item -M

Use the default value for the revision history log message.  Pinto
will generate a semi-informative log message just based on the command
and its arguments.  If you set an explicit message with C<--message>,
the C<--use-default-message> option will be silently ignored.

=back

=cut
