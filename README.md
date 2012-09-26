# NAME

App::Pinto - Command-line driver for Pinto

# VERSION

version 0.051

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

# SUPPORT

## Perldoc

You can find documentation for this module with the perldoc command.

    perldoc App::Pinto

## Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

- Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

[http://search.cpan.org/dist/App-Pinto](http://search.cpan.org/dist/App-Pinto)

- CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

[http://cpanratings.perl.org/d/App-Pinto](http://cpanratings.perl.org/d/App-Pinto)

- CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

[http://www.cpantesters.org/distro/A/App-Pinto](http://www.cpantesters.org/distro/A/App-Pinto)

- CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

[http://matrix.cpantesters.org/?dist=App-Pinto](http://matrix.cpantesters.org/?dist=App-Pinto)

- CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

[http://deps.cpantesters.org/?module=App::Pinto](http://deps.cpantesters.org/?module=App::Pinto)

## Bugs / Feature Requests

[https://github.com/thaljef/App-Pinto/issues](https://github.com/thaljef/App-Pinto/issues)

## Source Code



[https://github.com/thaljef/App-Pinto](https://github.com/thaljef/App-Pinto)

    git clone git://github.com/thaljef/App-Pinto.git

# AUTHOR

Jeffrey Thalhammer <jeff@imaginative-software.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
