# Answers You Must Have

All of these conditions should be met:

* Reliability and Repeatability
	* Consistent, deterministic results every time
	* Without losing progress (revision control, backups)
* Durability (i.e. Without breaking things)
	* A program inside of a project shouldn't break the project.
* Isolation: (i.e. Without interfering with others)
	* Example: Running things as your own user

## How Do I get Started?

* Run a program that generates a directory consisting of a project.

### How Do I set up the Environment?

* Follow instructions in the README
* Install the dependencies listed for the system you're using.
* Put configuration files in
	* User-specific configuration files go in your home directory ( ~/.config/...)
	* Project-specific configuration files go in src/etc

## How Do I Work?

* Check in / check out files as your user.
* Commit to branches, and merge

## How Do I Organize Code?

* src/bin - Stuff the consumer will run
* src/lib - Libraries

## How Do I Test?

* (If necessary) You have an automated build / compile process
* If necessary, automatically set up sample files, etc
* Run your program
* Automate this
	* run_scripts/ (scripts containing example commands)
	* tests/ (stuff that's used for testing)

## How Do I Create a Release?

* Update the changelog to contain the current version number.
* Document the significant changes in the changelog.
* Commit the changelog.
* Tag a release

## How Do I Deploy?

* Retrieve a copy of the code from the tag
* Run a command to build the package
* Import the package into a package repository

## How Do I Install?

* Configuration files
* Install the package from the repo

# What Should I Avoid?

## Breaking the Build

<pre>
fakeroot make package-deb
</pre>

should ALWAYS work.

## Breaking the master branch

## Defining data in multiple formats, in multiple places

## Back-porting


