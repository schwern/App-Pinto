# ABSTRACT: pull archives from upstream repositories

package App::Pinto::Command::pull;

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
        [ 'dryrun'      => 'Do not commit any changes'         ],
        [ 'norecurse'   => 'Do not recursively pull prereqs'   ],
        [ 'pin'         => 'Pin all the packages to the stack' ],
        [ 'stack|s=s'   => 'Put packages into this stack'      ],
    );
}

#------------------------------------------------------------------------------

sub args_attribute { return 'targets' }

#------------------------------------------------------------------------------

sub args_from_stdin { return 1 }

#------------------------------------------------------------------------------

1;

__END__

=for stopwords norecurse

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT pull [OPTIONS] TARGET ...
  pinto --root=REPOSITORY_ROOT pull [OPTIONS] < LIST_OF_TARGETS

=head1 DESCRIPTION

This command locates packages in your upstream repositories and then
pulls the distributions providing those packages into your repository.
Then it recursively locates and pulls all the distributions that are
necessary to satisfy their prerequisites.  You can also request to
directly pull particular distributions.

When locating packages, Pinto first looks at the the packages that
already exist in the local repository, then Pinto looks at the
packages that are available available on the upstream repositories.

=head1 COMMAND ARGUMENTS

Arguments are the targets that you want to pull.  Targets can be
specified as packages (with or without a minimum version number) or
a distributions.  For example:

  Foo::Bar                                 # Pulls any version of Foo::Bar
  Foo::Bar~1.2                             # Pulls Foo::Bar 1.2 or higher
  SHAKESPEARE/King-Lear-1.2.tar.gz         # Pulls a specific distribuion
  SHAKESPEARE/tragedies/Hamlet-4.2.tar.gz  # Ditto, but from a subdirectory

You can also pipe arguments to this command over STDIN.  In that case,
blank lines and lines that look like comments (i.e. starting with "#"
or ';') will be ignored.

=head1 COMMAND OPTIONS

=over 4

=item --dryrun

Go through all the motions, but do not actually commit any changes to
the repository.  Use this option to see how upgrades would potentially
impact the stack.

=item --norecurse

Do not recursively pull any distributions required to satisfy
prerequisites for the targets.

=item --stack=NAME

Puts all the packages onto the stack with the given NAME.  Defaults
to the name of whichever stack is currently marked as the default
stack.  Use the L<stacks|App::Pinto::Command::stacks> command
to see the stacks in the repository.

=back

=cut
