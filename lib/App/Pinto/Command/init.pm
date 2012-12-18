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
        [ 'description=s' => 'Description of the initial stack'             ],
        [ 'nodefault'     => 'Do not mark the initial stack as the default' ],
        [ 'log-level=s'   => 'Minimum logging level for the log file'       ],
        [ 'source=s@'     => 'URL of upstream repository (repeatable)'      ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Only one stack argument is allowed')
      if @{ $args } > 1;

    $self->usage_error('Cannot use --description without specifying a stack')
      if $opts->{description} and not @{ $args };

    $self->usage_error('Cannot use --nodefault without specifying a stack')
      if $opts->{nodefault} and not @{ $args };

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my $global_opts = $self->app->global_options;

    $global_opts->{root} ||= $ENV{PINTO_REPOSITORY_ROOT}
        || die "Must specify a repository root directory\n";

    $global_opts->{root} =~ m{^https?://}x
        && die "Cannot create remote repositories\n";

    # Combine repeatable "source" options into one space-delimited "sources" option.
    # TODO: Use a config file format that allows multiple values per key (MVP perhaps?).
    $opts->{sources} = join ' ', @{ delete $opts->{source} } if defined $opts->{source};

    # Stuff the stack argument into the options hash (if it exists)
    $opts->{stack} = $args->[0] if $args->[0];

    Class::Load::try_load_class('Pinto::Initializer')
        or die "Must install Pinto to create new repositories\n";

    my $initializer = Pinto::Initializer->new( %{ $global_opts } );
    $initializer->init( %{$opts} );
    return 0;
}

#------------------------------------------------------------------------------

1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT init [OPTIONS] [STACK]

=head1 DESCRIPTION

This command creates a new, empty repository.  If the target directory
does not exist, it will be created for you.  If it does already exist,
then it must be empty.  You can set the configuration properties of
the new repository using the command line options listed below.

=head1 COMMAND ARGUMENTS

The argument is the name of the initial stack.  If given, the stack
will be created and marked as the default stack (unless the
C<--nodefault> option is specified).  Stack names must be alphanumeric
plus hyphens and undercores, and are not case-sensitive.

If the argument is not given, then no stack will be created.  But to
do anything useful, you'll need to use the
L<new|App::Pinto::Command::new> command to create a stack once the
repository has been created.

You should also consider marking a default stack by using the
L<default|App::Pinto::Command::default> command.  Otherwise, you'll
have to specify the C<--stack> option for most other commands.

=head1 COMMAND OPTIONS

=over 4

=item --description=TEXT

A brief description of the initial stack.  Defaults to "the initial
stack".  This option is only allowed if the C<STACK> argument is
given.


=item --log-level=LEVEL

Sets the minimum level for the repository log file.  Valid C<LEVEL>s
are C<debug>, C<info>, C<notice>, C<warning>, or C<error>.  The
default is C<notice>.

Beware that lowering the log level may seriously degrade performance.
You can change this property at any time by editing the repository
configuration file at F<REPOSITORY_ROOT/.pinto/config/pinto.ini>.


=item --nodefault

Do not mark the initial stack as the default stack.  This option
is only allowed if the C<STACK> argument is given.

If you choose not to mark the default stack, then you'll be required
to specify the C<--stack> option for most commands.  You can always
mark (or ummark) the default stack by at any time by using the
L<default|App::Pinto::Command::default> command.


=item --source=URL

The URL of the upstream repository where distributions will be pulled
from.  This is usually the URL of a CPAN mirror, and it defaults to
L<http://cpan.perl.org>.  But it could also be a L<CPAN::Mini> mirror,
or another L<Pinto> repository.

You can specify multiple repository URLs by repeating the C<--source>
option.  Repositories that appear earlier in the list have priority
over those that appear later.  See L<Pinto::Manual> for more
information about using multiple upstream repositories.

=back

=cut
