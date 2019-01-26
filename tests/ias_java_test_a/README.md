# ias_java_test_a

An attempt to make Package Shell work with Java.  (It does).

# License

copyright (C) 2017 Martin VanWinkle III, Institute for Advanced Study

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

See 

* http://www.gnu.org/licenses/

## Description

Tough Package Shell's goals haven't been fully listed, I was interested in
packaging and deploying Java code along those goals.  These goals for Java
haven't been fully realized yet, but the following things are expected to work:

* This should compile all Java code and make a package out of it:
	* fakeroot make pacakge-rpm
	* fakeroot make package-deb
* A script, **java_env.sh** containing environment variables to cause the CLASS_PATH
environment to contain:
	* /opt/IAS/lib/java
	* src/lib/java
	* src/java
* A script that sources **java_env.sh** to run your application

## Guidelines

* All Java code should be inside of Java "package" declarations.
* src/lib/java is for class files that were provided to you, for which you do
not have the source code.
* src/java is for Java code where you have the source, and you need / want to
compile it

## Compilation

__artifact-name__/artifact_variables.gmk contains a variable, **JAVA_SRC_JAVA_FILES**
which is a recursive globbing of all of the java files under src/java .

The **java-compile** target calls **javac** on each one of those files.

It is assumed that the files in src/lib/java do not need to be compiled.

## Package Building

The following things happen:

* The default package build code copies src/lib/java to **BUILD_ROOT**/opt/IAS/lib/java
* The **java-install** target in **artifact-dir/artifact_variables.gmk** copies
src/java to **BUILD_ROOT**/opt/IAS/lib/java

Basically, both directories, src/lib/java and src/java get copied to the same destination.

## Implementation Details

* The makefile which compiles and (optionally) runs the Java program sources
the same **java_env.sh** file as above. 

# Supplemental Documentation

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

# Installation

Ideally stuff should run if you clone the git repo, and install the deps specified
in either "deb_control" or "rpm_specific"

Optionally, you can build a package which will install the binaries in

* /opt/IAS/bin/ias-java-test-a/.

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

```
  fakeroot make package-deb
```

### RHEL Based Systems

```
fakeroot make package-rpm
```

