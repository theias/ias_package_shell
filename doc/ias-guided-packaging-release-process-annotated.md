# Subsequent Releases

## Package Version Number

The first line of the changelog contains the current version of the package.

This versioning scheme is "generally" compatible with Semantic Versioning ( https://semver.org/ ) , with the exception that the "Release" number below is slightly different in spirit.

The format of the version is:

* Major.Minor.Patch-Release

The fields are described here:

* **Major** - A major redesign has occurred.  Changes in this number typically denote a backwards compatibility issue.
* **Minor** - Significant improvements were made.
* **Patch** - Bug fixes.
* **Release** - Changes in packaging code / how the code was deployed.

### Basic Rules for "Bumping" the Version Number

"Bumping" just refers to "incrementing the appropriate field in a version number".

* For changes that occur under src/ , you bump **Major-Minor-Patch** .
* For all other changes, you bump **Release**

* If you bump any number then ALL numbers to the right become "0".
* If you modify things under /src/ , you increment the Major, Minor, or Patch numbers as follows
  * If your previous version was 1.0.0-0 , and you have a Major update, your current version is 2.0.0-0
  * If your previous version was 1.0.0-1 , and you have a Major update, your current version is 2.0.0-0
  * If your previous version was 1.2.3-4 , and you have a Major update, your current version is 2.0.0-0
  * If your previous version was 1.0.1-0 , and you have a Minor update, your current version is 1.1.0-0
* If you modify things outside of /src/ and need to do a new release, then you update the Release number.
  * If your previous version was 1.0.0-0 , your current version is 1.0.0-1 .

## The changelog file

Edit the changelog file:

```
vi my-first-ias-package/changelog
```
As of now, its contents should look like this:

```
  1 my-first-ias-package 1.0.0-0 noarch; urgency=low
  2 
  3     * initial packaging stuff
  4 
  5  -- YOUR NAME HERE YOUR@EMAIL.HERE  Wed, 24 May 2017 13:59:41 -0400
  6 
```

You will copy, paste, and change the following things to the top of the file.  An example of an updated changelog is at the end of this document.

* **1.0.0-0** - Package Version Number
* **YOUR NAME HERE** - Your Name
* **YOUR@EMAIL.HERE** - Your Email Address
* **Wed, 24 May 2017 13:59:41 -0400** - The "date" of the release.

### Your Name
Self explanatory.  If you want credit (or responsibility) for this package, then by all means put your name in here.


### Your Email Address

Self Explanatory.

### Date of Release

This is the date after which no changes to the tag / package will be made. There are few exceptions; mainly the automatically generated RPM spec file can be checked in after this date.

This date format can be obtained (on a GNU system) with:
```
date -R
```

### Updated changelog Example
```
  1 my-first-ias-package 1.1.0-0 noarch; urgency=low
  2 
  3     * Better verification of user input.
  4     * Fixed documentation.
  5 
  6  -- Martin VanWinkle mvanwinkle@ias.edu  Thu, 25 May 2017 08:42:36 -0400
  7 
  8 my-first-ias-package 1.0.0-0 noarch; urgency=low
  9 
 10     * initial packaging stuff
 11 
 12  -- Martin VanWinkle mvanwinkle@ias.edu  Wed, 24 May 2017 13:59:41 -0400
 13 
```

# Tagging - Release Process

This is currently a hodgepodge of information about doing tagging
and releasing with Git and SVN.  We were transitioning from SVN
to Git when this documentation originally written, and documentation
about specific revision control systems found their way into
the package shell documentation.

Make sure all of your changes have been committed.  Then follow these steps.

## Tag Rules

These are hard-and-fast rules to the system.  The "Why?" can be answered, but will be answered later.

* Tags are never modified (unless you're adding the resultant spec file to them)
* Tags are never deleted (unless they've never been deployed to production)
* ./build/ directories are never checked in (at least, in this system).  Don't check those in.

## SVN
This is when we create a named copy of our software that corresponds to the release version specified (in our case, 1.0.0-0, on the first line of the my-first-ias-package/changelog).

If you're tagging things in SVN then chances are your tagging process should be fine, so figure out how to follow that.

### If you're not tagging...


If you aren't doing tags in Subversion... you really should be.  This is just one way of making a place to tag things for this project.  You only (generally) have to do this once per project:

```
svn mkdir https://svn.example.com/tags/applications/my_first_ias_package
```

Then you create the tag by using an *svn cp*:

```
svn cp https://svn.example.com/trunk/applications/my_first_ias_package \
https://svn.example.com/tags/applications/my_first_ias_package/my_first_package-1.0.0-0
```

## git

Tagging in git is easy.  I use the *-s* flag to sign my tags (sometimes...)

For small projects, I just:
```
git status # make sure it's clean
git tag -a -s v1.1.0-0 -m 'Tagging for release'
git push origin v1.0.0-0
```

For large, and busy projects, or just for practice, here's how you'd branch to make a release in git, and merge it back:

```
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

# Package the Tagged Version

This process checks out the tagged version of your software and builds a package out of it.

I, personally, like to build things in ~/export/
```
mkdir ~/export
cd ~/export
```

You will need to clone / export a clean copy of the repository
at the tag you created.
```
# SVN:
svn co https://svn.example.com/tags/applications/my_first_ias_package/my_first_package-1.0.0-0
# GIT:
git clone ...
```

Ideally, if you have your build environment set up, this is all you
should have to run:

```
fakeroot make package-rpm
# or
fakeroot make package-deb
```
