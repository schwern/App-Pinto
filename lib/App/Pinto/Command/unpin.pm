package App::Pinto::Command::unpin;

# ABSTRACT: free packages that have been pinned

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
        [ 'message|m=s' => 'Message to describe the change'       ],
        [ 'stack|s=s'   => 'Stack from which to unpin the target' ],
    );
}

#------------------------------------------------------------------------------

sub args_attribute { return 'targets' }

#------------------------------------------------------------------------------

sub args_from_stdin { return 1 }

#------------------------------------------------------------------------------

1;

__END__


=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT unpin [OPTIONS] TARGET ...
  pinto --root=REPOSITORY_ROOT unpin [OPTIONS] < LIST_OF_TARGETS

=head1 DESCRIPTION

This command unpins package in the stack, so that the stack can be
merged into another stack with a newer packages, or so the packages
can be upgraded to a newer version within this stack.

=head1 COMMAND ARGUMENTS

Arguments are the targets you wish to unpin.  Targets can be
specified as packages or distributions, such as:

  Some::Package
  Some::Other::Package

  AUTHOR/Some-Dist-1.2.tar.gz
  AUTHOR/Some-Other-Dist-1.3.zip

When unpinning a distribution, all the packages in that distribution
become unpinned.  Likewise when unpinning a package, all its sister
packages in the same distributon also become unpinned.

You can also pipe arguments to this command over STDIN.  In that case,
blank lines and lines that look like comments (i.e. starting with "#"
or ';') will be ignored.

=head1 COMMAND OPTIONS

=over 4

=item --message=TEXT

=item -m TEXT

Use TEXT as the revision history log message.  At the moment, this is
optional but it will become mandatory in the future.

=item --stack=NAME

Unpins the package on the stack with the given NAME.  Defaults to the
name of whichever stack is currently marked as the default stack.  Use
the L<stacks|App::Pinto::Command::stacks> command to see your
stacks.

=back

=cut
