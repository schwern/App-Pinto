# ABSTRACT: show the commit logs of a stack

package App::Pinto::Command::log;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw( log hist ) }

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'commit|c=s'  => 'Only show selected commit'                     ],
        [ 'stack|s=s'   => 'Show history for stack other than the default' ],
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

  pinto --root=REPOSITORY_ROOT log [STACK[@COMMIT]] [OPTIONS]

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

This command shows the commit log for the stack.  To see the precise
changes in any particular commit, use the L<App::Pinto::Command::show>
command.

=head1 COMMAND ARGUMENTS

As an alternative to the C<--stack> and C<--revision> options, you can
also specify them stack as a single argument. So the following
examples are equivalent:

  pinto --root REPOSITORY_ROOT log --stack=dev --commit=e45fa21
  pinto --root REPOSITORY_ROOT log dev@e45fa21

A C<stack@commit> argument will override anything specified with the
C<--stack> or C<--commit> options.

If neither the stack nor commit is specified using neither the
arguments nor options, then all commits of the default stack
will be shown.  So if the default stack is called C<dev> then
the following are all equivalent:

  pinto --root REPOSITORY_ROOT log --stack=dev
  pinto --root REPOSITORY_ROOT log dev
  pinto --root REPOSITORY_ROOT log

=head1 COMMAND OPTIONS

=over 4

=item --commit=COMMIT

=item -c COMMIT

Show only the commit with the given COMMIT ID.  Otherwise, the entire
history of the stack is shown in reverse-chronological order.  The
COMMIT ID may be abbreviated to uniqueness, but can be no less than
four characters.

=item --stack NAME

=item -s NAME

Show the history of the stack with the given NAME.  Defaults to the
name of whichever stack is currently marked as the default stack.  Use
the L<stacks|App::Pinto::Command::stack> command to see the stacks in
the repository.

=back

=cut
