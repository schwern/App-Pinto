# ABSTRACT: Command-line driver for Pinto

package App::Pinto;

use strict;
use warnings;

use Encode;
use Class::Load;
use Term::Prompt;
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
        [ 'root|r=s'     => 'Path to your repository root directory'  ],
        [ 'no-color'     => 'Do not colorize any output'              ],
        [ 'password|p=s' => 'Password for server authentication'      ],
        [ 'quiet|q'      => 'Only report fatal errors'                ],
        [ 'username|u=s' => 'Username for server authentication'      ],
        [ 'verbose|v+'   => 'More diagnostic output (repeatable)'     ],
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
        my $global_options = $self->global_options;

        $global_options->{root} ||= $ENV{PINTO_REPOSITORY_ROOT}
            || $self->usage_error('Must specify a repository root');

        $global_options->{password} = $self->_prompt_for_password
            if defined $global_options->{password} and $global_options->{password} eq '-';

        # Translating (progressive) verbose values into (regressive) log_level values.
        # Note that we must not pass log_level into the constructor for Pinto, or it
        # will set the logging level for its own internal logs.

        my $logger_options = {};
        $logger_options->{log_level} = 3 - min(delete $global_options->{verbose} || 0, 3);
        $logger_options->{log_level} = 4 if delete $global_options->{quiet};
        $logger_options->{no_color}  = 1 if delete $global_options->{no_color};

        # TODO: Give helpful error message if the right backend
        # is not installed.

        my $pinto_class = $self->pinto_class_for($global_options->{root});
        Class::Load::load_class($pinto_class);

        my $pinto = $pinto_class->new( %{ $global_options } );
        $pinto->add_logger($self->make_logger( %{ $logger_options } ));

        $pinto;
    };
}

#------------------------------------------------------------------------------

sub pinto_class_for {
    my ($self, $root) = @_;
    return $root =~ m{^http://}x ? 'Pinto::Remote' : 'Pinto';
}

#------------------------------------------------------------------------------

sub make_logger {
    my ($self, %options) = @_;

    my $no_color  = $options{no_color};
    my $colors    = $no_color ? {} : ($self->log_colors);
    my $log_class = 'Log::Dispatch::Screen';
    $log_class   .= '::Color' unless $no_color;

    my $log_level = $options{log_level};

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

sub _prompt_for_password {
   my ($self) = @_;

   my $input    = Term::Prompt::prompt('p', 'Password:', '', '');
   my $password = Encode::decode_utf8($input);
   print "\n"; # Get on a new line

   return $password;
}

#-------------------------------------------------------------------------------


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
