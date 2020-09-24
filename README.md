# ias_package_shell

A template processing system with emphasis on creating project directories.

IAS Package Shell was developed from the standpoint of:

* Only requiring packages that are available in either base repositories
or repositories that have large community support (e.g. EPEL)
* Functioning on both Debian and RPM based systems after only having
installed those dependencies

It is known to work on the following Linux Distributions:

* EL 5,6,7,8
* Debian based systems, such as Ubuntu 16.04, 18.04, 20.04 .

It probably works on more, but those are the main distributions I use.

## The _Full Project_ Template

The _Full Project_ template is a project template that ships with IAS Package Shell.
It is the default project directory template that is used.

It generates noarch / all arch packages.  It can be used to generate other
artifacts, such as Ruby Gems.

### Agnosticism

For scripting languages _Full Project_ is:

* version control system agnostic
* packaging system agnostic
* programming language agnostic
* Linux distribution agnostic
* deployment system agnostic

The only dependencies to build a package are:

* Gnu Make
* Fakeroot
* The package build utilities for what's being built

This layout is known to be compatible with programs that use:

* PHP: Composer
* Python: pipenv
* Perl
* Ruby: Gems (see artifact-name/gem)
* Bash

### "Supported" "Packaging" Systems

Both "supported" and "packaging" are in quotes for a couple of reasons.
Some people would debate what exactly a "package system" is.
Also, "supported" here means that it generally melds well with it.

Out-of-the box, these systems work:

* RPM
* Debian

#### Builds for Programming Language Package Systems

Many programming languages assume that if you're building a module (or a package
or whatever) that the repo is completely dedicated to it.

There are ways around this assumption, and the following are known
to work / mostly work:

* Gem - is simple.  It's possible to build a gem and install it.
* Perl / CPAN - Symbolically link ```src/lib/perl5``` to the ```lib``` directory
after you run something like ```module-starter```
* PHP Composer - Composer is different... Examples are provided.  I currently haven't
deployed code as a Composer package; I've just depended on them.

Basically: If you need something MORE complicated or dedicated, migrate your code to
another repo, and make that a "pure" repo.  This system was designed to be
easily transitioned out of.


### "Progressive Framework"

A "Progressive Framework" accomodates for future groth without encumbering
newcomers.  Certain aspects of packaging have been abstracted away simply
by specifying directories into which to put files.

#### Layout

The _Full Project_ template is designed for you to put a file in
```src/bin/``` and have that file deployed inside of a package (DEB, RPM)
which is built with one command.

If you wish to write a library, you simply create ```src/lib/language``` 
and put your library there.  Files under ```src/lib``` are automatically
added by the packaging code.

Thus, you can go from a simple single script to having a library without
issue.  You can also mix and match scripting languages inside of the
same repository.

Examples for multiple scripting languages can be found here:

* https://github.com/mvanwinkleias/repo_layout_demo1

When you decide you want to make a PIP, Gem, CPAN Module, Composer Module,
etc, you can also easily progress to those systems as well.  As your
project becomes better defined, you can either migrate your libraries
out to different repositories, or you can use those packaging systems
from within the current repository.

#### Libraries

As this is a progressive framework, you do not need to know how to use
libraries this in order to use the framework.  However, things have been
written which allow you to organize your programs better, standardize, and
reduce code.

All of the scripting languages listed above have corresponding libraries which
(for example):

* know where to store and retrieve transient files
	* Input and output directories
	* some also have standardized output file name generation
* know where to load configuration files from (src/etc, for example)
* have logging facilities built in

These libraries know how to find those locations when run from:

* the source directory
* the installed location as an RPM/Deb package
* a symbolic link

In the case of Object Oriented programming languages, the "Application Object"
inherits that functionality from a class, which inherits functionality from multiple
classes.  This means you can mix and match functionality.

* [Bash 4](https://github.com/theias/ias_bash_script_infra)
* [Perl](https://github.com/theias/ias_perl_script_infra) (Tested with 5, probably works with 7)
* [Ruby 2](https://github.com/theias/ias_ruby2_script_infra)
* PHP (to be released)
* [Python 3](https://github.com/theias/ias_python3_script_infra) (Tested with 3.\*, might work with 2)

You can see the general idea of how libraries work here:

* [Infra Overview](./doc/base_infra_diagram/infrastructure_overview.png)

### Naming Conventions

* projects_are_named_like_this
* artificats-are-named-like-this

While this isn't a "hard" requirement of the system, the initial template generation
configuration insists on using names formatted as stated.  This can be changed, of course.

The rationale behind this is:

* multiple artifacts can be generated from the same project directory, and their names
need not be the same as the project directory
* when working with building artificats, you deal with a LOT of erasure over many
short and quick iterations.  RPM and Debian based repositories mostly use "-"
to separate words in a package.  Using underscores for project names provides a visual
and tactile safeguard.  Think twice before you delete a directory ```named_like_this```.

## Other Project Layouts

### Gnu Autotools + C

Project directory templates have been created for the following:

* Autotools + Simple C program: https://github.com/mvanwinkleias/mv_c_package_template_test/tree/master/src/templates/c_project_template
* Autotools + C program with libraries: https://github.com/mvanwinkleias/mv_c_package_template_test/tree/master/src/templates/c_library_template
* Autotools + [mpicc](https://www.mpich.org/):  https://github.com/mvanwinkleias/mv_c_package_template_test/tree/master/src/templates/c_mpi_project

all of which install manual pages, info pages, and can have Debian packages generated by
issuing a single command.

### Java

In order to help prevent design choices that cause the layout to be incompatible with some languages
a (small) Java project was created under [./tests/ias_java_test_a](./tests/ias_java_test_a)

It contains examples for how to layout a project that requires class files.  It is
not to be considered anything serious yet.  It *might* be good; I just don't use Java
enough to recommend it.

# Usage

You can run it by cloning the repo and installing the dependencies as per the "Running".
You can build and install as per "Building a Package".

## Running

For RedHat family systems, install the dependencies listed in ```ias-package-shell/RPM/specfile.spec```.

For Debian faimly systems, install the dependencies listed in ```ias-package-shell/DEBIAN/control```.

## Building a Package

For RedHat family systems, you'll need rpm-build, fakeroot and make.
* ```fakeroot make package-rpm```

For Debian family systems, you'll need build-essential, and fakeroot.
* ```fakeroot make package-deb```

The last lines of output will contain the package that was generated.

# Supplemental Documentation

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

# Synopsis (a _very_ short example)

```
ias_package_shell.pl
```

And answer questions.  It will create a project tree for you.

Put a simple shell file in it into src/bin .

Then, provided the first line of the changelog contains the package name,
and the version of the package you want to release:

## RPM

```
fakeroot make package-rpm
```

## DEB

```
fakeroot make package-deb
```

## Install the Generated Package

RHEL based:

```
yum localinstall -y ...
```

Debian based:

```
gdebi ...
```

Your script you put into bin will be installed to

* /opt/IAS/bin/package-name/script_name.sh

## Side Note

If you don't care about tags, or releases, this _simplified_ might be good enough for you.

Just remember to commit the changelog, and increase the version numbers correctly
so your package management system knows how to handle upgrades.

I, personally, recommend following a release process (which is documented in the
[Supplemental Documentation](./doc/index.md)).




