# ABSTRACT: show available stacks

package App::Pinto::Command::stacks;

use strict;
use warnings;

use Pinto::Util qw(interpolate);

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'format=s' => 'Format of the listing' ],
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('No arguments are allowed')
        if @{ $args };

    $opts->{format} = interpolate( $opts->{format} )
        if exists $opts->{format};

    return 1;
}

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT stacks [OPTIONS]

=head1 DESCRIPTION

This command lists the names (and some other details) of all the
stacks available in the repository.

=head1 COMMAND ARGUMENTS

None.

=head1 COMMAND OPTIONS

=over 4

=item --format=FORMAT_SPECIFICATION

Format each record in the listing with C<printf>-style placeholders.
Valid placeholders are:

  Placeholder    Meaning
  -----------------------------------------------------------------------------
  %k             Stack name
  %e             Stack description
  %M             Stack default status                             (*) = default
  %U             Stack last-modified-on
  %j             Stack last-modified-by
  %%             A literal '%'

=back

=cut
