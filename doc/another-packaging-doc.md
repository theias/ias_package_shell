# Purpose

I really need to reorganize the documentation for this project.

This is a collection of thoughts that need to be organized.  It's hard to find
a starting point to explain the philosophy of everything without having written
some stuff first.

# First Off

A source code repository layout doesn't need to match the layout of the
repository when it's "installed".  The current focus of this project has been
files that need to be installed verbatim (i.e. files that just need
to be copied for installation).  Programs written in scripting languages where
the primary "audience" for this system: they don't need to be compiled and
linked (well; mostly).

If you need to package up and deploy Java programs, or C programs; this project
isn't for you (yet).

# Building Up to Things

At first, when you learn a repository control system, you might want to lay
out things like this (where all of your scripts are in the base directory of the repo):
```
proto_repo_1/
├── another_thing.sh
├── something.sh
└── third_thing.sh
```
Then, you decide to add a and an output directory to hold output
but the contents might not get checked in:
```
proto_repo_2/
├── another_thing.sh
├── output/
├── README.md
├── something.sh
└── third_thing.sh
```

Let's say you make your scripts "smart"; and have them output to the output
directory by default.  Less cleanup, and a standardized cleanup (yay).

This would allow another person to check out your repository, and run
your scripts, and not have to worry about where output goes.

Let's say you want to include a Python script.  And, maybe it includes
something in a library directory.  But now you want to differentiate
between "stuff you run" between "stuff that's included".  So:

```
proto_repo_3/
├── bin/
│   ├── another_thing.sh
│   ├── some_parser.py
│   ├── something.sh
│   └── third_thing.sh
├── lib/
│   └── a_parser.py
├── output/
└── README.md
```

Let's say you want to include an install script in the form of a Makefile;
and you want a changelog file:

```
proto_repo_4/
├── bin/
│   ├── another_thing.sh
│   ├── some_parser.py
│   ├── something.sh
│   └── third_thing.sh
├── changelog
├── lib/
│   └── a_parser.py
├── Makefile
├── output/
└── README.md
```

If you use Semantic Versioning, https://semver.org/ , you might want to organize
 your repo further, into parts that affect how the code behaves (src), and
 things like
* documentation
* project deployment code
such as:

```
proto_repo_5/
├── changelog
├── Makefile
├── README.md
└── src/
    ├── bin/
    │   ├── another_thing.sh
    │   ├── some_parser.py
    │   ├── something.sh
    │   └── third_thing.sh
    ├── lib/
    │   └── a_parser.py
    └── output/
```

Now it's abundantly clear; stuff "you run" goes in bin.  Library code goes
under lib.  Anything outside of the src dir is not related to the behavior
of the code.

You might be wondering about why I moved the output directory in the last step.
*output* is transient in nature; in this method of doing things it doesn't
really ever get checked in.  If it does, then things under it never should
get checked in.

# The Repo is Laid Out... Now what?

The first thing I would like to address is: now that you have a couple
of different Bash scripts and Python script, how do you define a standard
behavior for them?  By that I mean things like:

* Where do they output by default?
* Where do they get their configuration from by default?
* Where do they get input to process by default?

You could come up with a layout like this:

```
proto_repo_6/
├── changelog
├── Makefile
├── README.md
└── src/
    ├── bin/
    │   ├── another_thing.sh
    │   ├── some_parser.py
    │   ├── something.sh
    │   └── third_thing.sh
    ├── etc/
    ├── input/
    ├── lib/
    │   └── a_parser.py
    └── output/
```
(note __etc/__ and __input/__)
And then tell the scripts that their:
* "output" directory corresponds to "../output"
* "input" directory corresponds to "../input"
* "configuration" directory corresponds to "../etc"
all relative to the script location itself.

This is precisely what the infrastructure libraries I have written do.
They provide definitions or how and where to find things, in an abstracted form,
 so a program calls a standardized subroutine to get answers to these questions.

# Almost There!

Some things still need to be worked out.  Here's a good representation of the
final layout:

```
proto_repo_7/
├── Makefile
├── proto-repo-7
│   ├── changelog
│   ├── DEBIAN
│   └── RPM
├── README.md
└── src
    ├── bin
    │   ├── another_thing.sh
    │   ├── some_parser.py
    │   ├── something.pl
    │   ├── something.rb
    │   ├── something.sh
    │   └── third_thing.sh
    ├── etc
    ├── input
    ├── lib
    │   ├── bash4
    │   │   └── IAS
    │   │       └── BashLibrary.sh
    │   ├── perl5
    │   │   └── IAS
    │   │       └── SomeModule.pm
    │   ├── python3
    │   │   └── IAS
    │   │       └── a_parser.py
    │   └── ruby2
    │       └── IAS
    │           └── SomeGem.rb
    └── output

```

## Libraries

Some people like Python.  Some people like Ruby.  Some like Perl, some like Bash.
I say, "That's great.  Organize it."

Under lib, put the name of the programming language, along with the major version
of the programming language that's in use.

Under that, put the name of your Institution.

Under that, organize your libraries.

You might not need to use 4 different programming languages in your project,
but if you organize things this way, you can create and use libraries for
your project in different languages without interfering with things.

## The artifact directory: proto-repo-7

This controls how artifacts for your project should be created.  An artifact
(in this case) is a deployable unit, such as a package.
