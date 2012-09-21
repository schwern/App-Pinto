# ABSTRACT: substitue an archive in the repository

package App::Pinto::Command::replace;

use strict;
use warnings;

#------------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#-----------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'author=s'    => 'Your (alphanumeric) author ID'          ],
        [ 'dryrun'      => 'Do not commit any changes'              ],
        [ 'message|m=s' => 'Message to describe the change'         ],
        [ 'norecurse|n' => 'Do not recursively pull prereqs'        ],
        [ 'pin'         => 'Pin packages to all affected stacks'    ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Must specify OLD_DIST_SPEC and NEW_ARCHIVE')
        if @{$args} != 2;

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my %args = ( archive => $args->[0], target => $args->[1] );
    my $result = $self->pinto->run($self->action_name, %{$opts}, %args);

    return $result->exit_status;
}

#------------------------------------------------------------------------------

1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT replace [OPTIONS] ARCHIVE_FILE TARGET

=head1 DESCRIPTION

This command adds a new distribution archive to the repository and
puts its packages into all stacks that currently contain packages from
the old distribution.  Effectively, it replaces one distribution with
another across all stacks.

This is useful when you want to "hotfix" an existing distribution and
immediately propagate it to all stacks that use it.  However, each
distribution archive in the repository must have a unqiue path, so you
must give the new archive a different name or assign it to a different
author.

=head1 COMMAND ARGUMENTS

There are two required arguments.  The first argument is the path to
the replacement distribution archive.  The second argument is the
target you want to replace.  The target is specified as
C<AUTHOR/ARCHIVE>).  For example: C<JOHN/Foo-Bar-1.0.tar.gz>

=head1 COMMAND OPTIONS

=over 4

=item --author NAME

Set the identity of the replacement distribution author.  The C<NAME>
must be alphanumeric characters (no spaces) and will be forced to
uppercase.  Defaults to the C<user> specified in your C<~/.pause>
configuration file (if such file exists).  Otherwise, defaults to your
current login username.

=item --dryrun

Go through all the motions, but do not actually commit any changes to
the repository.  Use this option to see how the command would
potentially impact the stack.

=item --message=TEXT

=item -m TEXT

Use TEXT as the revision history log message.  If you do not use
C<--message> option, then you will be prompted to enter the message
via your text editor.  Use the C<EDITOR> or C<VISUAL> environment
variables to control which editor is used.  A log message is not
required whenever the C<--dryrun> option is set, or if the action did
not yield any changes to the repository.

=item --norecurse

=item -n

Do not recursively pull distributions required to satisfy the
prerequisites of the added distribution.

=item --pin

Pins all the packages in the added distributions to all the affected
stacks, so they cannot be changed until you unpin them.  The pin does
not apply to any prerequisites that are pulled in for this
distribution.  However, you may pin them separately with the
L<pin|App::Pinto::Command::pin> command, if you so desire.

=back

=cut
