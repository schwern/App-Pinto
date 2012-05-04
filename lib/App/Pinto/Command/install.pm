# ABSTRACT: install stuff from the repository

package App::Pinto::Command::install;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'cpanm_exe|cpanm=s'  => 'Path to the cpanm executable'      ],
        [ 'cpanm_options|o:s%' => 'name=value pairs of cpanm options' ],
        [ 'stack|s=s'          => 'Use the index for this stack'      ],

    );
}

#------------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names;

    my $usage =  <<"END_USAGE";
%c --root=REPOSITORY_ROOT $command [OPTIONS] TARGET...
%c --root=REPOSITORY_ROOT $command [OPTIONS] < LIST_OF_TARGETS
END_USAGE

    chomp $usage;
    return $usage;
}

#------------------------------------------------------------------------------

sub args_attribute { return 'targets' }

#------------------------------------------------------------------------------

sub args_from_stdin { return 1 }

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT install [OPTIONS] TARGET...
  pinto --root=REPOSITORY_ROOT install [OPTIONS] < LIST_OF_TARGETS

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

Installs packages from the repository into your environment.  This is
just a thin wrapper around L<cpanm> that is wired to fetch everything
from the Pinto repository, rather than a public CPAN mirror.

=head1 COMMAND ARGUMENTS

Arguments are the things you want to install.  These can be package
names, distribution paths, URLs, local files, or directories.  Look at
the L<cpanm> documentation to see all the different ways of specifying
what to install.

You can also pipe arguments to this command over STDIN.  In that case,
blank lines and lines that look like comments (i.e. starting with "#"
or ';') will be ignored.

=head1 COMMAND OPTIONS

=over 4

=item --cpanm_exe=PATH

=item --cpanm=PATH

Sets the path to the L<cpanm> executable.  If not specified, the
C<PATH> will be searched for the executable.  At present, cpanm
version 1.500 or newer is required.

=item --cpanm_options NAME=VALUE

=item -o NAME=VALUE

These are options that you wish to pass to L<cpanm>.  Do not prefix
the option name with a '-'.  You can pass any option you like, but the
C<--mirror> and C<--mirror-only> options will always be set to point
to the Pinto repository.

=item --stack=NAME

Use the stack with the given NAME as the repository index.  Defaults
to the name of whichever stack is currently marked as the default
stack.  Use the L<stacks|App::Pinto::Command::stacks> command to see
the stacks in the repository.

=back

=cut
