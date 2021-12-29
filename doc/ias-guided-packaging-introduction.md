# Guided Packaging

## Introduction / Purpose


This document describes the "How" of the guided packaging process.

The Guided Packaging Process has been developed so that a series of well-defined steps can be used in order to create, package, and deploy software.

The question "Why" can always be answered, but it is outside of the scope of this document.

The process documented here "should always work" given that you have chosen a unique package name.

# Requirements

## Project Name

You will require a name for your project. In this example we use **my_first_ias_package** as the name.

# Procedure

## Create the Package Template

Run this:

```
ias_package_shell.pl
```

You will be asked questions:

```
ias_package_shell.pl
####################
#   Project Name: 
Contains only letters, numbers and underscores.  Required.
Enter Response: my_first_ias_package
####################
#   Summary: 
Short description of project.  Required.
Enter Response: This is an example package.
####################
#   Wiki page: 
External documentation.
Enter Response: https://www.example.com/example_package/index.html
####################
#   Ticket: 
Link to ticket, or ticket ID
Enter Response: 182822

```

Your package template has been created.

You're ready to start adding files.

## Develop
Let's put a script in.

```
touch src/bin/a-script-file.sh
vi src/bin/a-script-file.sh
```

Put these contents in that file:

```
#!/bin/bash
echo 'Hello, world!'
```

## Package

### RPM

```
fakeroot make package-rpm
```

The final messages will be from rpm-build spitting out your new RPM.

```Wrote: stuff/build/noarch/my-first-ias-package-1.0.0-0.noarch.rpm```

You can examine the contents of the RPM with:

```less ./build/noarch/my-first-ias-package-1.0.0-0.noarch.rpm```

### DEB

```
fakeroot make package-deb
```

The final message(s) will contain the name of the deb that was built.

## Deploy to Test

Your package is ready to be installed.

```
sudo yum install ./build/noarch/my-first-ias-package-1.0.0-0.noarch.rpm
```

For Debian based systems, I recommend using "gdebi" to install the package.

You can also run your shiny new script:

```
/opt/IAS/bin/my-first-ias-package/a-script-file.sh
```

# Bolting on a Revision Control Process

A .gitiginore file has already been created for you.  You can translate that to whatever other repository system you might want to use.

ias_package_shell.pl overlays the resulting project without interfering with the revision control system files.  You can 

* create a repository with the same name and copy the files into it
* check out a repository and have ias_package_shell.pl overlay the template.

See this:

* [Subsequent Releases](./ias-guided-packaging-release-process-annotated.md)

## Deploy to Production

(You imported this into a version control system, and tagged it, right?)
Copy the resulting package into the package repository.

Profit.


# Next Steps

What you have learned to do is good for initial releases.

Subsequent releases have different steps, and the process is described here:

[Subsequent releases](./ias-guided-packaging-release-process-annotated.md)

# Changing the Installation Base Directory

If you don't work at IAS, you can modify the BASE_DIR variable by doing this when you build your packages:
```
BASE_DIR=/opt/example-org fakeroot make package-deb
```

Or, you can set BASE_DIR=/opt/example-org in base.gmk
# Troubleshooting
This system should work with a "standard" .rpmmacros  file.  Having NO rpmmacros file should always work.
If you're having problems then please let me know.
