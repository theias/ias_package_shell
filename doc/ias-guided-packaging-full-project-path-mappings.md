# Guided Packaging - "Full Project" Path Mappings

In order to disambiguate directories in the project's repository vs. the installation
directory, I will use the following notation:

* **LIB_SRC_DIR** - project_name/src/lib
* **LIB_INST_DIR** - /opt/IAS/lib

I.e. **_SRC_** means we are referring to the project directory, and **_INST_** means
we are referring to the installation directory.

Also, **project-name** will refer to the package.  **project_name** will refer to the source tree.

It is up to the code to determine whether or not it should use paths with **\_SRC\_** or **\_INST\_** .
More on this later.

The current implementation only "supports" one mapping of project directories
to installation directories.

I have dubbed it, "Full Project", because it segregates the installation material
under the assumption that no project directory will ever install files into shared
directories, with the exception of files under *LIB_SRC_DIR* .


## Mappings

A "good" library will detect whether or not the code is being run from within a source
tree or if it's installed.  (Typically by checking if BIN_DIR/../ = 'src').

Then when the programmer refers to INPUT_DIR , the code should know whether or not
it needs 'src/input' , or '/opt/IAS/input/project-name' .

The example above uses a full path to specify the installation directory for input.
In practice, a "good" library should do this when it's running with "installed" code:

* What is my BIN_DIR?  /opt/IAS/bin/package-name/
  * /opt/IAS/bin/package-name/
* If I use the "Full Project" layout, where is my input directory?
  * /opt/IAS/bin/package-name/../../input/package-name

### Mapping Table

Here's what an example layout installation would look like.  It's formatted like this:

<pre>
ALIAS
	source location
	installation destination
</pre>

The "Full Project" layout installs things thus:

<pre>
INPUT_DIR
	src/input - INPUT_SRC_DIR
	/opt/IAS/input/project-name - INPUT_INST_DIR

OUTPUT_DIR
	src/output - OUTPUT_SRC_DIR
	/opt/IAS/output/project-name - OUTPUT_INST_DIR
	
ROOT_CONF_DIR
	src/root_etc - ROOT_CONF_SRC_DIR
	/etc - ROOT_CONF_INST_DIR
	
CONF_DIR
	src/etc - CONF_SRC_DIR
	/opt/IAS/etc/project-name - CONF_INST_DIR

LIB_DIR
	src/lib - LIB_SRC_DIR
	/opt/IAS/lib - LIB_INST_DIR
	
BIN_DIR
	src/bin - BIN_SRC_DIR
	/opt/IAS/bin/project-name - BIN_INST_DIR
	
</pre>

Again, determining which directory to use, **\_SRC\_** or **\_INST\_** is up to the library.

You will frequently see references to things like **$BIN_DIR** in bash, or **$self->bin_dir()**
in Perl.  The underlying libraries know whether or not to use **BIN_SRC_DIR** or **BIN_INST_DIR**.
