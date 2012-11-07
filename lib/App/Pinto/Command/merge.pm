# ABSTRACT: merge one stack into another

package App::Pinto::Command::merge;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'dryrun'                => 'Do not commit any changes'      ],
        [ 'message|m=s'           => 'Message to describe the change' ],
        [ 'use-default-message|M' => 'Use the generated message'      ],
    );
}

#------------------------------------------------------------------------------
sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Must specify FROM_STACK and TO_STACK')
        if @{$args} != 2;

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my %stacks = ( from_stack => $args->[0], to_stack => $args->[1] );
    my $result = $self->pinto->run($self->action_name, %{$opts}, %stacks);

    return $result->exit_status;
}

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT merge [OPTIONS] SOURCE_STACK TARGET_STACK

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

This command merges the packages from one stack (the C<SOURCE>) into
another (the C<TARGET>).  Merge rules are as follows:

=over 4

=item * If a package in the C<SOURCE> is newer than the corresponding
package in the C<TARGET>, then the package in the C<TARGET> is
upgraded to the same version as the package in the C<SOURCE>.

=item * If the package in the C<TARGET> is pinned and the
corresponding package in the C<SOURCE> is newer, then a conflict
occurrs.

=item * If the package in the C<SOURCE> is pinned and the
corresponding package in the C<TARGET> is newer, then a conflict
occurrs.

=back

Whenever there is a conflict, the merge is aborted.  All the pins
from the C<SOURCE> are also placed on the C<TARGET>.  Both C<SOURCE>
and C<TARGET> stacks must already exist before merging.  Please see
the L<copy|App::Pinto::Command::copy> or L<new|App::Pinto::Command::new>
commands to create stacks.

=head1 COMMAND ARGUMENTS

Required arguments are the name of the C<SOURCE> stack and the name of
the C<TARGET> stack.

=head1 COMMAND OPTIONS

=over 4

=item --dryrun

Go through all the motions, but do not actually commit any changes to
the repository.  Use this option to see potential conflicts that would
prevent a real merge.

=item --message=TEXT

=item -m TEXT

Use TEXT as the revision history log message.  If you do not use the
C<--message> option or C<--use-default-message> option, then you will
be prompted to enter the message via your text editor.  Use the
C<EDITOR> or C<VISUAL> environment variables to control which editor
is used.  A log message is not required whenever the C<--dryrun>
option is set, or if the action did not yield any changes to the
repository.

=item --use-default-message

=item -M

Use the default value for the revision history log message.  Pinto
will generate a semi-informative log message just based on the command
and its arguments.  If you set an explicit message with C<--message>,
the C<--use-default-message> option will be silently ignored.

=back

=cut
