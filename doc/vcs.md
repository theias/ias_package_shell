# Introduction

Version Control Systems (VCSs) track changes to files.
 
## Preface
If you're new to Version Control Systems, I'd recommend reading this as a
"primer".

If you're experienced, maybe you could use this as a reference for when somebody
asks you about a VCS concept.

## Conventions

This document will assume that text files (such as code)
are what is being tracked.  If anything looks "innacurate", then you can assume that
"typically", or "conceptually" should be used to qualify the statements.  I will omit
such verbiage.  All of what I write about should be true for both git and svn.

# Software Revision / Verson Control Systems (VCSs)

## Revisions, In General

A Revision refers to an automatically named snapshot in time.

VCSs keep track of the order in which revisions were made.  They allow you to
go back to specific revisions.  They allow you to examine the differences
between revisions.

Revisions can look like this:
```
1 -> 2 -> 4 -> 6 -> 8 -> 9 ...
      \            /
       3 -> 5 -> 7 
```

The diagram above includes something called a "Branch."  Branching is out
of the scope of this document, but is an important enough concept to mention
as existing.

## Versions, In General

A Version refers to a name a human gives to a Revision.

Versions are useful for designating a Revision as "important".

Versions can (conceptually) look like this:

```
1.0.0-0 -> 1
1.2.2-0 -> 3
2.0.0-0 -> 5
```

"Tagging" is the act of associating a Version with a Revision.

A widely used naming format for versions is [Semantic Versioning](https://semver.org/).

# Git

## Git Revisions
Revisions are called "Commits" in git.

Commits in git aren't given a sequential name.  They're given a
computer generated name that's (statistically going to be) unique.

I've shortened the names here because the length (for the purposes
of this document) is unimportant.

```
dd6f -> 175a -> 70aa -> b371 -> c7cb0 -> ...
```

## Git Tags

Tags are named pointers to specific revisions.  Git has a *tag* command.

For the current commit, this creates a tag named "v1.0.0-0"
```
git tag -a v1.0.0-0
```

This lists the tags
```
git tag
v1.0.0-0
```

This tells git to add the tag back to origin:
```
git push origin v1.0.0-0
```

# Subversion

## Subversion Revisions

Revisions in subversion are given sequential numbers.

```
1 -> 2 -> 3 -> 4 -> 5 ...
```

## Subversion Tags

Tags are (typically) copies of directories with a naming standard.

```
svn cp https://repo.example.com/trunk/project_a \
    https://repo.example.com/tags/project_a/project_a-1.0.0-0
```

Copies are just named entries that point to revisions.

# Standards Within Organization's or Group's Repository

If you are working on "somebody else's thing", and they have standards for things like:
* Branching
* Commit messages
* Code formatting

Read the docs (they should have docs.  If they don't, you could write them.),
and adhere to them.

# My Standards

This is the fun part.  I only have one standard:

* Don't be a jerk.

Everything else focuses on using (what I think) VCSs are good for:

* Allowing you to move forward without fear that you'll lose work.
* Allowing you to interact with and get help from people.

To that end, here's what the majority of my workflow looks like when I'm using
a small and personal repository:

For git:
```
git add . ; git commit -m 'progress' ; git push
```

For my own SVN repo:
```
svn commit -m 'progress'
```

That's it.

# If You're New

* Get your code in a repository.
* Don't commit sensitive information.
	* If you did commit sensitive information, it's the Internet's now.  Change your passwords, keys, etc.
* Ask your friends to review your work.

This is all you really need to "worry" about.

## Getting Started With Git

Most git tutorials should follow this format:

* Create a Gitlab or Github Account (Remember, they're doing a favor for YOU by hosting your stuff)
* Follow the instructions for setting up SSH keys.
* Create a repository.
* Clone it using the command they give you.
* Start learning.  (Learning is fun!)

### Github's Quickstart Document

The majority of the document is OK, but it is Github centric.

* https://docs.github.com/en/get-started/quickstart


