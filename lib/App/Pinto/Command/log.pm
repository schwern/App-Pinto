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

    $self->usage_error('Multiple arguments are not allowed')
        if @{ $args } > 1;

    ($opts->{stack}, $opts->{revision}) = split /@/, $args->[0]
        if $args->[0];

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

As an alternative to the C<--stack> option, you can also specify the
stack as an argument. So the following examples are equivalent:

  pinto --root REPOSITORY_ROOT list --stack dev
  pinto --root REPOSITORY_ROOT list dev

A stack specified as an argument in this fashion will override any
stack specified with the C<--stack> option.

You can also append a single revision number to the stack argument
with the '@' characters.  So the following examples are also
equivalent:

  pinto --root REPOSITORY_ROOT list --stack dev --revision 289
  pinto --root REPOSITORY_ROOT list dev@289

A revision number specified in this fashion will override any
revision number specified with the C<--revision> option.

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
