# ias_package_shell

Usage:
<pre>
ias_package_shell.pl
</pre>

Then answer questions.

It will produce a directory for your project.

# Supplemental Documentation

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

# Installation

The script should run just fine if you check it out and run it:

<pre>
./src/bin/package_shell.pl
</pre>

You can build a package and install it, which will install into:

* /opt/IAS/bin/ias-package-shell/package_shell.pl

# Building a Package

## Requirements

### All Systems

* fakeroot

### Debian

* build-essential

### RHEL based systems

* rpm-build

## Export a specific tag (or just the source directory)

## Supported Systems

### Debian packages

<pre>
  fakeroot make clean install debsetup debbuild
</pre>

### RHEL Based Systems

If you're building from a tag, and the spec file has been put
into the tag, then you can build this on any system that has
rpm building utilities installed, without fakeroot:

<pre>
make clean install cp-rpmspec rpmbuild
</pre>

This will generate a new spec file every time:

<pre>
fakeroot make clean install rpmspec rpmbuild
</pre>
