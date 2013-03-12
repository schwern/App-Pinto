package App::Pinto::Module::Build;

use strict;
use warnings;

use base 'Module::Build';

#------------------------------------------------------------------------------

my $MIN_PINTO_VERSION = 0.070;
my $MIN_PINTO_REMOTE_VERSION = 0.046;

#------------------------------------------------------------------------------

sub new {
  my ($class, %args) = @_;

  my $has_pinto        = eval { require Pinto };
  my $has_pinto_remote = eval { require Pinto::Remote };

  if (!$has_pinto && !$has_pinto_remote) {

    # If they have neither Pinto nor Pinto::Remote then ask if they
    # want to install each of them.

    _display_message();

    $args{requires}->{'Pinto'} = $MIN_PINTO_VERSION
        if $class->y_n('Install Pinto?', 'n');

    $args{requires}->{'Pinto::Remote'} = $MIN_PINTO_REMOTE_VERSION
        if $class->y_n('Install Pinto::Remote?', 'n');

  }
  else {

    # If they already have either Pinto or Pinto::Remote then add the
    # minumum version to the requirements.

    $args{requires}->{'Pinto'} = $MIN_PINTO_VERSION
      if $has_pinto;

    $args{requires}->{'Pinto::Remote'} = $MIN_PINTO_REMOTE_VERSION
      if $has_pinto_remote;
  }

  return $class->SUPER::new(%args);

}

#------------------------------------------------------------------------------

sub _display_message {

  print  <<END_MESSAGE;

#######################################################################
App::Pinto only provides a command-line interface.  To do anything
useful, you also need to install a backend, which ships separately
from App::Pinto.

If you want to create new repositories and work directly with
repositories on the local file system, then you need to install Pinto.
If you already have a repository on a remote host running behind a
pintod server, then you need to install Pinto::Remote.  Or you can
install both, if you like.
#######################################################################

END_MESSAGE

}

#------------------------------------------------------------------------------

1;

__END__
