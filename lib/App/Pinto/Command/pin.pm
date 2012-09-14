package App::Pinto::Command::pin;

# ABSTRACT: force a package to stay in a stack

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
        [ 'message|m=s' => 'Message to describe the change'   ],
        [ 'stack|s=s'   => 'Stack on which to pin the target' ],
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

  pinto --root=REPOSITORY_ROOT pin [OPTIONS] TARGET ...
  pinto --root=REPOSITORY_ROOT pin [OPTIONS] < LIST_OF_TARGETS

=head1 DESCRIPTION

This command pins a package so that it stays in the stack even if a
newer version is subsequently mirrored, imported, or added to that
stack.  The pin is local to the stack and does not affect any other
stacks.

A package must be in the stack before you can pin it.  To bring a
package into the stack, use the
L<pull|App::Pinto::Command::pull> command.  To remove the pin
from a package, please see the
L<unpin|App::Pinto::Command::unpin> command.

=head1 COMMAND ARGUMENTS

Arguments are the targets you wish to unpin.  Targets can be
specified as packages or distributions, such as:

  Some::Package
  Some::Other::Package

  AUTHOR/Some-Dist-1.2.tar.gz
  AUTHOR/Some-Other-Dist-1.3.zip

When pinning a distribution, all the packages in that distribution
become pinned.  Likewise when pinning a package, all its sister
packages in the same distributon also become pinned.

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

Pins the package on the stack with the given NAME.  Defaults to the
name of whichever stack is currently marked as the default stack.  Use
the L<stacks|App::Pinto::Command::stacks> command to see the
stacks in the repository.

=back

=cut
