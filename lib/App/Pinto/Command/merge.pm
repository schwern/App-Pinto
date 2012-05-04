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
        [ 'dryrun'  => 'Do not commit any changes' ],
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

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    my $usage =  <<"END_USAGE";
%c --root=REPOSITORY_ROOT $command [OPTIONS] FROM_STACK TO_STACK
END_USAGE

    chomp $usage;
    return $usage;
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

Whenever there is a conflict, the merge is aborted.  All the pins from
the C<SOURCE> are also placed on the C<TARGET>.  Both C<SOURCE> and
C<TARGET> stacks must already exist before merging.  Please see the
C<copy> or C<new> commands to create stacks.

=head1 COMMAND ARGUMENTS

Required arguments are the name of the C<SOURCE> stack and the name of
the C<TARGET> stack.

=head1 COMMAND OPTIONS

=over 4

=item --dryrun

Go through all the motions, but do not actually commit any changes to
the repository.  Use this option to see potential conflicts that a
would prevent a real merge.

=back

=cut
