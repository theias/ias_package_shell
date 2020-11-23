# Guided Packaging

## Introduction / Purpose

This document is meant to be a straight-forward presentation of creating a project and building a package from it.

If you don't work at IAS, you will want to change your package names, as well as the variable
that corresponds to BASE_DIR in your Makefile .

This document describes the "How" of the guided packaging process.

The Guided Packaging Process has been developed so that a series of well-defined steps can be used in order to create, package, and deploy software.

The question "Why" can always be answered, but it is outside of the scope of this document.

The process documented here "should always work" given that you have chosen a unique package name.

# Requirements

## Project Name

You will require a name for your project. In this example we use **my_first_ias_package** as the name.

I suggest using a different project name. The format I've chosen for "more official" packages at IAS 
is: **ias_(project_name)**.

Examples:

* ias_package_shell
* ias_snmp_titan
* ias_perl_script_infra

In the following steps you will be asked to give a package name to the package template generator.

Valid names:

* Don't use spaces, dashes, or any other special character
* Separate words with underscores

## Packaging Host

You will also need to log into a host that has the package template software on it.

Please follow the instructions in README.md to get that set up.

# Procedure

## Create the Package Template

Run this:

```
/opt/IAS/bin/ias-package-shell/ias_package_shell.pl
```

You will be asked questions:

```
/opt/IAS/bin/ias-package-shell/ias_package_shell.pl
Project names must not begin with numbers.
Project names must not contain white space or dashes.
Example: some_project_name
Required:
Project name: my_first_ias_package
Required:
Short summary: This is the first package I've built at IAS.
Wiki page: https://www.net.ias.edu
Ticket URL: https://rt.ias.edu/Display.html?290290

```

Your package template has been created.


## Check it into Revision Control

```cd my_first_package```

### SVN example
```
svn mkdir https://example.com/repos/applications/my_first_ias_package
svn co https://example.com/repos/applications/my_first_ias_package .
svn add *
svn commit -m 'Checking in the package template.'
```

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

Add the file: (svn / git)

```
svn add src/bin/a-script-file.sh
svn commit -m 'Checking it in.'
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

## Tagging

### SVN
This is when we create a named copy of our software that corresponds to the release version specified (in our case, 1.0.0-0, on the first line of the my-first-ias-package/changelog).

#### Only Once

If this is a new project, and a tag directory for it hasn't been created:

svn mkdir https://svn.example.com//tags/applications/my_first_ias_package

#### Making Tags

```
svn cp https://svn.example.com/trunk/applications/my_first_ias_package \
https://svn.example.com/tags/applications/my_first_ias_package/my_first_package-1.0.0-0
```

### git

For large, and busy projects, or just for practice, here's how you'd branch to make a release in git, and merge it back:

```
git
# Get the most recent version of the tree.
# be careful though that this is, in fact, what you want to tag
git pull
# Branch for a release
git branch release-2017-12-05-a_mvanwinkle
git checkout release-2017-12-05-a_mvanwinkle 
# After editing the changelog add it, commit it
git add ias-perl-script-infra/changelog
git commit -m 'bumped changelog'
# Tag and (optionally) sign the tag
git tag -s -a 'v1.0.0-0' -m 'tagging for release'
# Merge back with master
git checkout master
git merge release-2017-12-05-a_mvanwinkle 
# Show the tag
git tag
# Push the release version
push origin master
# Push the tag
git push origin v1.0.0-0
```

## Package the Tagged Version

This process checks out the tagged version of your software and builds a package out of it.

```
mkdir ~/build
cd ~/build
# SVN:
svn co https://svn.example.com/tags/applications/my_first_ias_package/my_first_package-1.0.0-0
# GIT:
git clone ...
cd my_first_package-1.0.0-0
fakeroot make package-rpm
```

Copy the spec file under ./build/ to ./my-first-package/ , add it, and commit.

```
cp ./build/my-first-ias-package-1.0.0-0--pkginfo.spec ./my-first-package/
# SVN , GIT
svn add ./my-first-package/my-first-ias-package-1.0.0-0--pkginfo.spec
svn commit
```

## Deploy to Production

Copy the resulting package into the package repository.

Profit.

# Rules

These are hard-and-fast rules to the system.  The "Why?" can be answered, but will be answered later.

* Tags are never modified (unless you're adding the resultant spec file to them)
* Tags are never deleted (unless they've never been deployed to production)
* ./build/ directories are never checked in.  Don't check those in.

# Next Steps

What you have learned to do is good for initial releases.

Subsequent releases have different steps, and the process is described here:

[Subsequent releases](./ias-guided-packaging-release-process-annotated.md)

# Troubleshooting
Emphasis was placed on being as compatible with a "standard" .rpmmacros  file.  Having NO rpmmacros file should always work.
If you're having problems then please let me know.
