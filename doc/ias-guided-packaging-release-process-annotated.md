# Guided Packaging - Release Process

Make sure all of your changes have been committed.  Then follow these steps.

# The changelog file

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

## Package Version Number

The first line of the changelog must contain the current version of the package.

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

## Your Name
Self explanatory.  If you want credit (or responsibility) for this package, then by all means put your name in here.


## Your Email Address

Self Explanatory.

## Date of Release

This is the date after which no changes to the tag / package will be made. There are few exceptions; mainly the automatically generated RPM spec file can be checked in after this date.

This date format can be obtained (on a GNU system) with:
```
date -R
```

## Updated changelog Example
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

# Build the Package (test)
Go to your project directory (the one with the Makefile)

```
fakeroot make package-rpm
```

# Tagging for Release
In our example, the newly released version is 1.1.0-0 , so that's what we use in our tagging command:

## git

```
# Get the most recent version of the tree.
# be careful though that this is, in fact, what you want to tag
git pull
# Branch for a release
git branch release-2017-12-05-a_mvanwinkle
git checkout release-2017-12-05-a_mvanwinkle 
# After editing the changelog as above, add it, commit it
git add ias-perl-script-infra/changelog
git commit -m 'bumped changelog'
# Tag and (optionally) sign the tag
git tag -s -a 'v1.1.0-0' -m 'tagging for release'
# Merge back with master
get checkout master
git merge release-2017-12-05-a_mvanwinkle 
# Show the tag
git tag
# Push the release version
push origin master
# Push the tag
git push origin v1.1.0-0
```

## svn

```
svn cp https://svn.ias.edu/repos/network/applications/my_first_ias_package \
https://svn.ias.edu/repos/network/tags/applications/my_first_ias_package/my_first_package-1.1.0-0
```

# Post Process

Once tagged, you can proceed with the rest of the deployment process, including (but not limited to):

* Checking out / exporting the source tree at the tag.
* Building the package
  * RPM ```fakeroot make package-rpm```
  * deb ```fakeroot make package-deb```
* Testing the package installs correctly
* Importing the package into a package repository
