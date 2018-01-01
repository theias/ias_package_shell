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

## Package Name

You will require a name for your package. In this example we use **my-first-ias-package** as the name.

I suggest using a different package name. The format I've chosen for "more official" packages at IAS 
is: **ias-(package-name)**.

Examples:

* ias-package-shell
* ias-snmp-titan
* ias-perl-script-infra

In the following steps you will be asked to give a package name to the package template generator.

Valid names:

* Don't use spaces, underscores, or any other special charactor
* Separate words with dashes

## Packaging Host

You will also need to log into a host that has the package template software on it.

Please follow the instructions in README.md to get that set up.

# Procedure

## Create the Package Template

Run this:

<pre>
/opt/IAS/bin/ias-package-shell/package_shell.pl
</pre>

You will be asked questions:

<pre>Required:
Package name: my-first-ias-package
Required:
Short summary: This is the first package I've built at IAS.
Wiki page: https://www.net.ias.edu
Ticket URL: https://rt.ias.edu/Display.html?290290
</pre>

Your package template has been created.


## Check it into Revison Control

<pre>cd my_first_package</pre>

Note how the hyphens have been replaced with underscores. The package template maker creates "project directories" under which packages can be built.

### SVN example
<pre>
svn mkdir https://example.com/repos/applications/my_first_ias_package
svn co https://example.com/repos/applications/my_first_ias_package .
svn add *
svn commit -m 'Checking in the package template.'
</pre>

You're ready to start adding files.


## Develop
Let's put a script in.

<pre>
touch src/bin/a-script-file.sh
vi src/bin/a-script-file.sh
</pre>

Put these contents in that file:

<pre>
#!/bin/bash
echo 'Hello, world!'
</pre>

Add the file: (svn / git)

<pre>
svn add src/bin/a-script-file.sh
svn commit -m 'Checking it in.'
</pre>

## Package

### RPM

<pre>
fakeroot make clean install rpmspec rpmbuild
</pre>

The final messages will be from rpm-build spitting out your new RPM.

<pre>Wrote: stuff/build/noarch/my-first-ias-package-1.0.0-0.noarch.rpm</pre>

You can examine the contents of the RPM with:

<pre>less ./build/noarch/my-first-ias-package-1.0.0-0.noarch.rpm</pre>

### DEB

<pre>
fakeroot make clean debsetup debbuild
</pre>

The final message(s) will contain the name of the deb that was built.

## Deploy to Test

Your package is ready to be installed.

<pre>
sudo rpm -ivh ./build/noarch/my-first-ias-package-1.0.0-0.noarch.rpm
</pre>
You can also run your shiny new script:

<pre>
/opt/IAS/bin/my-first-ias-package/a-script-file.sh
</pre>

## Tagging

### SVN
This is when we create a named copy of our software that corresponds to the release version specified (in our case, 1.0.0-0, on the first line of the my-first-ias-package/changelog).

#### Only Once

If this is a new project, and a tag directory for it hasn't been created:

svn mkdir https://svn.example.com//tags/applications/my_first_ias_package

#### Making Tags

<pre>
svn cp https://svn.example.com/trunk/applications/my_first_ias_package \
https://svn.example.com/tags/applications/my_first_ias_package/my_first_package-1.0.0-0
</pre>

### git

<pre>
git
# Get the most recent version of the tree.
# be careful though that this is, in fact, what you want to tag
git pull
# Branch for a release
git branch release-2017-12-05-a_mvanwinkle
git checkout release-2017-12-05-a_mvanwinkle 
# After editing the changlog add it, commit it
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
</pre>

## Package the Tagged Version

This process checks out the tagged version of your software and builds a package out of it.

<pre>
mkdir ~/build
cd ~/build
# SVN:
svn co https://svn.example.com/tags/applications/my_first_ias_package/my_first_package-1.0.0-0
# GIT:
git clone ...
cd my_first_package-1.0.0-0
fakeroot make clean install rpmspec rpmbuild
</pre>

Copy the spec file under ./build/ to ./my-first-package/ , add it, and commit.

<pre>
cp ./build/my-first-ias-package-1.0.0-0--pkginfo.spec ./my-first-package/
# SVN , GIT
svn add ./my-first-package/my-first-ias-package-1.0.0-0--pkginfo.spec
svn commit
</pre>

## Deploy to Production

Copy the resulting package into the package repository.

Profit.

# Rules

These are hard-and-fast rules to the system.  The "Why?" can be answered, but will be answered later.

* Tags are never modified (unless you're adding the resultant spec file to them)
* Tags are never deleted (unless they've never been deployed to production)
* ./build/ directories are never checked in .  Don't check those in.

# Next Steps

What you have learned to do is good for initial releases.

Subsequent releases have different steps, and the process is described here:

[Subsequent releases](./ias-guided-packaging-introduction-release-process.md)

# Troubleshooting
Emphasis was placed on being as compatable with a "standard" .rpmmacros  file.  Having NO rpmmacros file should always work.
If you're having problems then please let me know.
