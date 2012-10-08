# ABSTRACT: show who put each package on a stack

package App::Pinto::Command::blame;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw( blame praise ) }

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'stack|s=s'  => 'Show blame for stack other than the default' ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Multiple arguments are not allowed') if @{ $args } > 1;

    $opts->{stack} = $args->[0] if @{ $args };

    return 1;
}

#------------------------------------------------------------------------------

1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT blame [STACK] [OPTIONS]

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

This comand shows who put each package in the head revision of the
stack, and which revision it was last added, pinned, or unpinned.

=head1 COMMAND ARGUMENTS

As an alternative to the C<--stack> option, you can specify it as an
argument.  So the following examples are equivalent:

  pinto --root REPOSITORY_ROOT blame --stack=dev
  pinto --root REPOSITORY_ROOT blame dev

A C<STACK> argument will silently override anything specified with the
C<--stack> option.

=head1 COMMAND OPTIONS

=over 4

=item --stack NAME

=item -s NAME

Show blame for the stack with the given NAME.  Defaults to the name of
whichever stack is currently marked as the default stack.  Use the
L<stacks|App::Pinto::Command::stack> command to see the stacks in the
repository.

=back

=cut
