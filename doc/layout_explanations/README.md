# Layout Growth

The purpose of this "article" is to show how when you start with
a simple repository layout it can get complex.

You can choose a simple layout and then re-organize it, or you
can decide to just create files in their "more correct" locations
even though the complexity might not yet be warranted.

Sometimes you might be tempted to put all of your scripts
inside of the root directory of the project, like this:
```
proto_repo_1
├── another_thing.sh
├── something.sh
└── third_thing.sh
```
In this example, all of the files in the root of the project are
inteded to be run by the user.

But now you decide to add a README.md , which then changes
the idea that everything in the root of the project directory
is supposed to be run.

Now Documentation and "bin" files are in the same directory:

```
proto_repo_2
├── another_thing.sh
├── README.md
├── something.sh
└── third_thing.sh
```

Why not do something about it, and separate that stuff out.

Let's also say that you discovered that Bash isn't cutting it
any more, and you decide to add a Python script with a library.

Here's how you could organize it:

```
proto_repo_3
├── bin
│   ├── another_thing.sh
│   ├── some_parser.py
│   ├── something.sh
│   └── third_thing.sh
├── lib
│   └── a_parser.py
└── README.md
```

Now you have a Makefile...  Where does that go?

```
proto_repo_4
├── bin
│   ├── another_thing.sh
│   ├── some_parser.py
│   ├── something.sh
│   └── third_thing.sh
├── changelog
├── lib
│   └── a_parser.py
├── Makefile
└── README.md
```

Makefiles aren't necessarily "code" or something a user would run...
So why not put the "source code" of the project, and put that under
*src* , and leave the "project meta" files outside of src?

```
proto_repo_5
├── changelog
├── Makefile
├── README.md
└── src
    ├── bin
    │   ├── another_thing.sh
    │   ├── some_parser.py
    │   ├── something.sh
    │   └── third_thing.sh
    └── lib
        └── a_parser.py
```

Another step could be to associate the changelog with some artifact,
*proto-repo-7* that could be deployed, but for the purposes of this
explanation it might be overkill:

```
proto_repo_7
├── Makefile
├── proto-repo-7
│   └── changelog
├── README.md
└── src
    ├── bin
    │   ├── another_thing.sh
    │   ├── some_parser.py
    │   ├── something.pl
    │   ├── something.rb
    │   ├── something.sh
    │   └── third_thing.sh
    └── lib
        ├── bash4
        │   └── IAS
        │       └── BashLibrary.sh
        ├── perl5
        │   └── IAS
        │       └── SomeModule.pm
        ├── python3
        │   └── IAS
        │       └── a_parser.py
        └── ruby2
            └── IAS
                └── SomeGem.rb
```

Now that we're here, what was the point?

You could have just started with something as simple as:

```
organized_repo1/
├── README.md
└── src
    └── bin
        └── script.sh
```

And then you wouldn't have needed to re-organize things when stuff
got complicated.  That and it's clear that things under *src/bin*
are the things that are supposed to be run.
