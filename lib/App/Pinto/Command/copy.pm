# ABSTRACT: create a new stack by copying another

package App::Pinto::Command::copy;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw(copy cp) }

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'description|d=s' => 'Brief description of the stack' ],
        [ 'dryrun'          => 'Do not commit any changes'      ],
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

  pinto --root=REPOSITORY_ROOT copy [OPTIONS] FROM_STACK TO_STACK

=head1 DESCRIPTION

This command creates a new stack by copying an existing one.  All the
pins and properties from the existing stack will also be copied to the
new one.  The new stack must not already exist.

Please see the L<new|App::Pinto::Command::new> command to
create a new empty stack, or the
L<edit|App::Pinto::Command::edit> command to change a stack's
properties after it has been created.

=head1 COMMAND ARGUMENTS

The two required arguments are the name of the source and target
stacks.  Stack names must be alphanumeric (including "-" or "_") and
will be forced to lowercase.

=head1 COMMAND OPTIONS

=over 4

=item --description TEXT

Annotates the new stack with a brief description of its purpose.

=item --dryrun

Go through all the motions, but do not actually commit any changes to
the repository.  Use this option to see how operations would
potentially impact the stack.

=back

=cut
