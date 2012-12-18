# ABSTRACT: migrate existing repository to a new version

package App::Pinto::Command::migrate;

use strict;
use warnings;

use Class::Load;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Arguments are not allowed')
      if @{ $args };

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my $global_opts = $self->app->global_options;

    $global_opts->{root} ||= $ENV{PINTO_REPOSITORY_ROOT}
        || die "Must specify a repository root directory\n";

    $global_opts->{root} =~ m{^https?://}x
        && die "Cannot migrate remote repositories\n";

    Class::Load::try_load_class('Pinto::Migrator')
        or die "Must install Pinto to migrate repositories\n";

    my $migrator = Pinto::Migrator->new( %{ $global_opts } );
    $migrator->migrate;

    return 0;
}

#------------------------------------------------------------------------------

1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT migrate [OPTIONS]

=head1 DESCRIPTION

=head1 COMMAND ARGUMENTS

=head1 COMMAND OPTIONS

=cut
