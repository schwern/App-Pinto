# ABSTRACT: migrate repository to a new version

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

    my $class = $self->load_migrator;
    my $migrator = $class->new( %{ $global_opts } );
    $migrator->migrate;

    return 0;
}

#------------------------------------------------------------------------------

sub load_migrator {

    my $class = 'Pinto::Migrator';

    my ($ok, $error) = Class::Load::try_load_class($class);
    return $class if $ok;

    my $msg = $error =~ m/Can't locate .* in \@INC/
                     ? "Must install Pinto to migrate repositories\n"
                     : $error;
    die $msg;
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
