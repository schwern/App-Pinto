package App::Pinto::Command::init;

# ABSTRACT: create a new repository

use strict;
use warnings;

use Class::Load;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'bare'          => 'Do not create any initial stack'         ],
        [ 'description=s' => 'Description of the initial stack'        ],
        [ 'log_level=s'   => 'Minimum logging level for the log file'  ],
        [ 'source=s@'     => 'URL of upstream repository (repeatable)' ],
        [ 'stack|s=s'     => 'Name of the initial stack'               ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Arguments are not allowed')
      if @{ $args };

    $self->usage_error('Cannot use --bare with --stack or --description')
      if $opts->{bare} and ($opts->{stack} or $opts->{description});

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    Class::Load::try_load_class('Pinto::Initializer')
        or die "Must install Pinto to create new repositories\n";

    my $global_opts = $self->app->global_options;

    $global_opts->{root} ||= $ENV{PINTO_REPOSITORY_ROOT}
        || die "Must specify a repository root directory\n";

    $global_opts->{root} =~ m{^https?://}x
        && die "Cannot create remote repositories\n";

    # Combine repeatable "source" options into one space-delimited "sources" option.
    # TODO: Use a config file format that allows multiple values per key (MVP perhaps?).
    $opts->{sources} = join ' ', @{ delete $opts->{source} } if defined $opts->{source};

    my $initializer = Pinto::Initializer->new( %{ $global_opts } );
    $initializer->init( %{$opts} );
    return 0;
}

#------------------------------------------------------------------------------

1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT init [OPTIONS]

=head1 DESCRIPTION

This command creates a new, empty repository.  If the target directory
does not exist, it will be created for you.  If it does already exist,
then it must be empty.  The new repository will contain an empty (but
valid) index file.  You can set the configuration parameters of the
new repository using the command line options listed below.

=head1 COMMAND ARGUMENTS

None.

=head1 COMMAND OPTIONS

=over 4

=item --bare

Do not create an initial stack in the repository.  Use this option
if you plan to load the repository from a dump file.

=item --description=TEXT

A brief description of the initial stack.  Defaults to "the initial
stack".

=item --source=URL

The URL of a repository where foreign distributions will be pulled
from.  This is usually the URL of a CPAN mirror, and it defaults to
L<http://cpan.perl.org>.  But it could also be a L<CPAN::Mini> mirror,
or another L<Pinto> repository.

You can specify multiple repository URLs by repeating the C<--source>
option.  Repositories that appear earlier in the list have priority
over those that appear later.  See L<Pinto::Manual> for more
information about using multiple source repositories.

=item --stack=NAME

=item -s NAME

The name of the inital stack.  Stack names must be alphanumeric
plus hyphens and undercores, and are not case sensitive.  Defalts
to 'init'.

=back

=cut
