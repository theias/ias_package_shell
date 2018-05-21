# ias_package_shell

# Supplemental Documentation

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

# Synopsis (a _very_ short example)

```
package_shell.pl
```

And answer questions.  It will create a project tree for you.

Put a simple shell file in it into src/bin .

Then, provided the first line of the changelog contains the package name,
and the version of the package you want to release:

## RPM

```
fakeroot make clean install rpmspec rpmbuild
```

## DEB

```
fakeroot make clean install debsetup debbuild
```

## Install the Generated Package

```
yum localinstall -y ...
```

or

```
dpkg -i ...
```

Your script you put into bin will be installed to

* /opt/IAS/bin/package-name/script_name.sh

## Side Note

If you don't care about tags, or releases, this _simplified_ might be good enough for you.

Just remember to commit the changelog, and increase the version numbers correctly
so your package management system knows how to handle upgrades.

I, personally, recommend following a release process (which is documented in the
[Supplemental Documentation](./doc/index.md)).

# Installation

## Check Out the Source

The script should run just fine if you check it out, install the dependencies in
rpm_specific (rpm systems), or deb_control (deb systems) and run it.

## Building a Package

You can build a package and install it, which will take care of the dependencies and install into:

* /opt/IAS/bin/ias-package-shell/package_shell.pl


### Requirements

All of the requisite things can be installed via packages.

#### All Systems

* fakeroot

#### Debian

* build-essential

#### RPM Based Systems

* rpm-build

### Building a Debian package

```
  fakeroot make clean install debsetup debbuild
```

### Building an RPM

If you're building from a tag, and the spec file has been put
into the tag, then you can build this on any system that has
rpm building utilities installed, without fakeroot:

```
make clean install cp-rpmspec rpmbuild
```

Sometimes the spec file might not be checked in with the tag.

This will generate a new spec file every time:

```
fakeroot make clean install rpmspec rpmbuild
```

# TODO

1.  Make the RPM building portion "behave" with fakeroot.  Currently
everything is owned by root and will have to manually be changed in the make file.
dir_traverse.pl can easily be modified to add the appropriate
```
echo "%defattr(644, root, root,755) " >> $(SPEC_FILE)
```
entries, and this is on my list
of things to do.

1.  Better abstraction so as to include more packaging systems.

