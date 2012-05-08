package App::Pinto::Module::Build;

use strict;
use warnings;

use base 'Module::Build';

#------------------------------------------------------------------------------

sub new {
  my ($class, %args) = @_;

  my $has_pinto        = eval { require Pinto };
  my $has_pinto_remote = eval { require Pinto::Remote };

  if ( !($has_pinto || $has_pinto_remote) ) {

    print <<END_MESSAGE;
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


    $args{requires}->{'Pinto'} = 0
        if $class->y_n('Install Pinto?', 'n');

    $args{requires}->{'Pinto::Remote'} = 0
        if $class->y_n('Install Pinto::Remote?', 'n');

  }

    return $class->SUPER::new(%args);

}

#------------------------------------------------------------------------------

1;

__END__
