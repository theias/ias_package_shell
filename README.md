# ias_package_shell

# Supplemental Documentation

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

# Synopsis (a _very_ short example)

<pre>
package_shell.pl
</pre>

And answer questions.  It will create a project tree for you.

Put a simple shell file in it into src/bin .

Then, provided the first line of the changelog contains the package name,
and the version of the package you want to release:

## RPM

<pre>
fakeroot make clean install rpmspec rpmbuild
</pre>

## DEB

<pre>
fakeroot make clean install debsetup debbuild
</pre>

## Install the Generated Package

<pre>yum localinstall -y ...</pre>
or
<pre>dpkg -i ...</pre>

Your script you put into bin will be installed to

* /opt/IAS/bin/package-name/script_name.sh

## Side Note

If you don't care about tags, or releases, this might be good enough for you.

Just remember to commit the changelog, and increase the version numbers correctly
so your package management system knows how to handle upgrades.

I, personally, recommend following a release process (which is documented in the
[Supplemental Documentation](./doc/index.md)).

# Installation

## Check Out the Source

The script should run just fine if you check it out and run it.

You can build a package and install it, which will install into:

* /opt/IAS/bin/ias-package-shell/package_shell.pl

## Building a Package

### Requirements

All of the requisite things can be installed via packages.

#### All Systems

* fakeroot

#### Debian

* build-essential

#### RPM Based Systems

* rpm-build

### Building a Debian package

<pre>
  fakeroot make clean install debsetup debbuild
</pre>

### Building an RPM

If you're building from a tag, and the spec file has been put
into the tag, then you can build this on any system that has
rpm building utilities installed, without fakeroot:

<pre>
make clean install cp-rpmspec rpmbuild
</pre>

Sometimes the spec file might not be checked in with the tag.

This will generate a new spec file every time:

<pre>
fakeroot make clean install rpmspec rpmbuild
</pre>
