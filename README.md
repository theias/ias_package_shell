# ias_package_shell

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

# Installation

## Check Out the Source

The script should run just fine if you check it out, install the dependencies in
rpm_specific (rpm systems), or deb_control (deb systems) and run it.

## Building a Package

You can build a package and install it, which will take care of the dependencies and install into:

* /opt/IAS/bin/ias-package-shell/ias_package_shell.pl


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
  fakeroot make package-deb
```

### Building an RPM

```
fakeroot make package-rpm
```

# TODO


