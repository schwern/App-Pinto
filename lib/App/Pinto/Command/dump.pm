# ABSTRACT: dump repository contents and history to file

package App::Pinto::Command::dump;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw( dump ) }

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'outfile|o=s'  => 'name of the output file' ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Arguments are not allowed')
        if @{ $args };

    my $global_opts = $self->app->global_options;

    $global_opts->{root} ||= $ENV{PINTO_REPOSITORY_ROOT}
        || die "Must specify a repository root directory\n";

    $global_opts->{root} =~ m{^https?://}x
        && die "Cannot make dumps of remote repositories\n";

    return;
}

#------------------------------------------------------------------------------
1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT dump [OPTIONS]

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

This command dumps all the archives in the repository and the complete
revision history to a single file.  This file can then be loaded into
another (empty) repository using the L<load|App::Pinto::Command::load>
command.

=head1 COMMAND ARGUMENTS

NONE

=head1 COMMAND OPTIONS

=over 4

=item --outfile=FILE

=item -o FILE

Write the output to FILE.  If not specified, defaults to
F<pinto-dump-CCYYMMD-HHMMDSS.tar.gz> in the current directory.

=back

=head1 UPGRADING

The C<dump> and C<load> commands are typically used to upgrade your
repository when you want to use a new version of L<Pinto> that is
not compatible with older versions of the repository.  For example...

  # Using your current version of Pinto...
  $ pinto -r old_repository dump --output=my-repository.tar.gz

  # Then upgrade Pinto...
  $ cpanm Pinto

  # Using the new version of Pinto...
  $ pinto -r new_repository init --bare
  $ pinto -r new_repository load my-repository.tar.gz

=cut
