package App::Pinto::Command::statistics;

# ABSTRACT: report statistics about the repository

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub command_names { return qw( statistics stats ) }

#------------------------------------------------------------------------------
1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT statistics

=head1 DESCRIPTION

This command reports some statistics about the repository.  It is
currently only reports information about the default stack.

=head1 COMMAND ARGUMENTS

None.

=head1 COMMAND OPTIONS

None.

=cut
