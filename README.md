# NAME

App::Pinto - Command-line driver for Pinto

# VERSION

version 0.046

# DESCRIPTION

App::Pinto is the command-line driver for Pinto.  It is just a
front-end.  To do anything useful, you'll also need to install one of
the back-ends, which ship separately.  If you need to create
repositories and/or work directly with repositories on the local disk,
then install [Pinto](http://search.cpan.org/perldoc?Pinto).  If you already have a repository on a remote
host that is running [pintod](http://search.cpan.org/perldoc?pintod), then install [Pinto::Remote](http://search.cpan.org/perldoc?Pinto::Remote).  If
you're not sure what you need, then install [Task::Pinto](http://search.cpan.org/perldoc?Task::Pinto) to get the
whole kit.

# METHODS

## pinto

Returns a reference to a [Pinto](http://search.cpan.org/perldoc?Pinto) or [Pinto::Remote](http://search.cpan.org/perldoc?Pinto::Remote) object that has
been constructed for this application.

# SEE ALSO

[Pinto::Manual](http://search.cpan.org/perldoc?Pinto::Manual) for general information on using Pinto.

[pinto](http://search.cpan.org/perldoc?pinto) to create and manage a Pinto repository.

[pintod](http://search.cpan.org/perldoc?pintod) to allow remote access to your Pinto repository.

# AUTHOR

Jeffrey Thalhammer <jeff@imaginative-software.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
