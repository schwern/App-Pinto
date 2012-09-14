package App::Pinto::Command::log;

# ABSTRACT: show the revision history of a stack

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
        [ 'detailed|d'        => 'Show detailed history'                         ],
        [ 'revision|R=i'      => 'Only show selected revision'                   ],
        [ 'stack|s=s'         => 'Show history for stack other than the default' ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $DB::single = 1;
    $self->usage_error('Multiple arguments are not allowed')
        if @{ $args } > 1;


    if ($args->[0]) {

        ($opts->{stack}, $opts->{revision}) = split /@/, $args->[0], 2;

        # split returns '' for empty fields.  But to make Moose
        # happy, they need to be undef if they really don't exist.

        delete $opts->{stack}    if not length $opts->{stack};
        delete $opts->{revision} if not length $opts->{revision};
    }

    return 1;
}

#------------------------------------------------------------------------------

1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT log [OPTIONS]

=head1 DESCRIPTION

This command shows the revision history for the stack.  You can see
the log messages as well as which packages were added or removed
in each revision.

=head1 COMMAND ARGUMENTS

As an alternative to the C<--stack> and C<--revision> options, you can
also specify them stack as a single argument. So the following
examples are equivalent:

  pinto --root REPOSITORY_ROOT log --stack=dev --revision=289
  pinto --root REPOSITORY_ROOT log dev@289

A C<stack@revision> argument in this fashion will override anything
specified with the C<--stack> or C<--revision> options.

=head1 COMMAND OPTIONS

=over 4

=item --detailed

=item -d

Show detailed history, including which packages were added and removed
in the revision.

=item --revision=NUMBER

=item -R NUMBER

Show only the history for the revision with the given NUMBER.  Defaults
to the head revision of the stack.

=item --stack NAME

=item -s NAME

Show the revision history of the stack with the given NAME.  Defaults
to the name of whichever stack is currently marked as the default
stack.  Use the L<stacks|App::Pinto::Command::stack> command to see
the stacks in the repository.

=back

=cut
