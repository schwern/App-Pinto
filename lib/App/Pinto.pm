package App::Pinto;

# ABSTRACT: Command-line driver for Pinto

use strict;
use warnings;

use Class::Load;

use List::Util qw(min);
use Log::Dispatch::Screen;
use Log::Dispatch::Screen::Color;

use Pinto::Constants qw(:all);

use App::Cmd::Setup -app;

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub global_opt_spec {

    return (
        [ 'root|r=s'    => 'Path to your repository root directory'  ],
        [ 'nocolor'     => 'Do not colorize diagnostic messages'     ],
        [ 'quiet|q'     => 'Only report fatal errors'                ],
        [ 'verbose|v+'  => 'More diagnostic output (repeatable)'     ],
    );

    # TODO: Add options for color contols!
}

#------------------------------------------------------------------------------

=method pinto

Returns a reference to a L<Pinto> or L<Pinto::Remote> object that has
been constructed for this application.

=cut

sub pinto {
    my ($self) = @_;

    return $self->{pinto} ||= do {
        my %global_options = %{ $self->global_options() };

        $global_options{root} ||= $ENV{PINTO_REPOSITORY_ROOT}
            || $self->usage_error('Must specify a repository root');

        # TODO: Give helpful error message if the right backend
        # is not installed.

        my $pinto_class = $self->pinto_class($global_options{root});
        Class::Load::load_class($pinto_class);

        my $pinto = $pinto_class->new(%global_options);
        $pinto->add_logger($self->logger(%global_options));

        $pinto;
    };
}

#------------------------------------------------------------------------------

sub pinto_class {
    my ($self, $root) = @_;
    return $root =~ m{^http://}x ? 'Pinto::Remote' : 'Pinto';
}

#------------------------------------------------------------------------------

sub logger {
    my ($self, %options) = @_;

    my $nocolor   = $options{nocolor};
    my $colors    = $nocolor ? {} : ($self->log_colors);
    my $log_class = 'Log::Dispatch::Screen';
    $log_class .= '::Color' unless $nocolor;

    my $verbose = min($options{verbose} || 0, 2);

    my $log_level = 2 - $verbose;      # Defaults to 'notice'
    $log_level = 4 if $options{quiet}; # Only 'error' or higher

    return $log_class->new( min_level => $log_level,
                            color     => $colors,
                            stderr    => 1,
                            newline   => 1 );
}

#------------------------------------------------------------------------------

sub log_colors {
    my ($self) = @_;

    # TODO: Create command line options for controlling colors and
    # process them here.

    return $self->default_log_colors;
}

#------------------------------------------------------------------------------

sub default_log_colors { return $PINTO_DEFAULT_LOG_COLORS }

#------------------------------------------------------------------------------

1;

__END__

=head1 DESCRIPTION

App::Pinto is the command-line driver for Pinto.  It is just a
front-end.  To do anything useful, you'll also need to install one of
the back-ends, which ship separately.  If you need to create
repositories and/or work directly with repositories on the local disk,
then install L<Pinto>.  If you already have a repository on a remote
host that is running L<pintod>, then install L<Pinto::Remote>.  If
you're not sure what you need, then install L<Task::Pinto> to get the
whole kit.

=head1 SEE ALSO

L<Pinto::Manual> for general information on using Pinto.

L<pinto> to create and manage a Pinto repository.

L<pintod> to allow remote access to your Pinto repository.

=cut
