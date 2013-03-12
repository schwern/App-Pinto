# ABSTRACT: permanently remove an archive

package App::Pinto::Command::delete;

use strict;
use warnings;

#------------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#-----------------------------------------------------------------------------

sub command_names { return qw(delete remove del rm) }

#-----------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'force'  => 'Delete even if packages are pinned'  ],
    );
}

#------------------------------------------------------------------------------

sub args_attribute { return 'targets'; }

#------------------------------------------------------------------------------

sub args_from_stdin { return 1; }

#------------------------------------------------------------------------------
1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT deiete [OPTIONS] TARGET ...

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

This command permanently removes an archive from the repository and
unregisters it from all stacks.  Beware that once an archive is
deleted it cannot be recovered.

To merely remove packages from a stack (while preserving the archive),
use the L<unregister|App::Pinto::Command::unregister> command.

=head1 COMMAND ARGUMENTS

Arguments are the archives that you want to delete.  Archives are
specified as C<AUTHOR/ARCHIVE-NAME>.  For example:

  SHAKESPEARE/King-Lear-1.2.tar.gz

You can also pipe arguments to this command over STDIN.  In that case,
blank lines and lines that look like comments (i.e. starting with "#"
or ';') will be ignored.

=head1 COMMAND OPTIONS

=over 4

=item --force

Deletes the archive even if its packages are pinned to a stack.  Take
care when deleting pinned packages, as it usually means that
particular package is important to someone.

=back

=cut
