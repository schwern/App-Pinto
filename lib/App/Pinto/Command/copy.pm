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
        [ 'default'         => 'Make the new stack the default stack' ],
        [ 'description|d=s' => 'Brief description of the stack' ],
        [ 'message|m=s'     => 'Message to describe the change' ],
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
stacks.  Stack names must be alphanumeric plus hyphens and underscores,
and are not case-sensitive.


=head1 COMMAND OPTIONS

=over 4

==item --default

Also mark the new stack as the default stack.

=item --description=TEXT

=item -d TEXT

Use TEXT for the description of the stack.  This is usually used to
help explain the purpose of the stack.

=item --message=TEXT

=item -m TEXT

Use TEXT as the revision history log message.  If you do not use
C<--message> option, then you will be prompted to enter the message
via your text editor.  Use the C<EDITOR> or C<VISUAL> environment
variables to control which editor is used.

=back

=cut
