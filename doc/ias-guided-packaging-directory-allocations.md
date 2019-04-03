# Guided Packaging - Project Layout

This document will describe the location and purposes of directories and files

There are major components that must be in agreement for things to work:

* Project Layout
* Package Layout
* Code Function

## Please Keep In Mind

* You don't need to know everything.
* You don't need to use everything, but chances are that if you need something,
it has already been created.
* If you need something, check to see that it already exists (or ask how to do it, etc).
* Examples exist that don't require expertise in the system to use it.
* Things are defined, but don't need to be used.

These locations were developed to aid with usage patterns.  If the pattern doesn't apply
then you don't need to use the pattern.

# Non-transient src Locations

## Code

<table>
<tr>
	<th>Project Location</th>
	<th>Alias</th>
	<th>Purpose</th>
</tr>
<tr>
	<th valign=top align=right>src/bin/</th>
	<td>**BIN_DIR**</td>
	<td>Scripts to be installed.</td>
</tr>

<tr>
	<th valign=top align=right>src/templates/</th>
	<td>**TEMPLATE_DIR**</td>
	<td>Templates to be installed.</td>
</tr>

<tr>
	<th valign=top align=right>src/lib/</th>
	<td>**LIB_DIR**</td>
	<td>Libraries to be installed.</td>
</tr>

</table>

## Configuration

<table>
<tr>
	<th>Project Location</th>
	<th>Alias</th>
	<th>Purpose</th>
</tr>
<tr>
	<th valign=top align=right>src/etc/</th>
	<td>**CONF_DIR**</td>
	<td>Project configuration files to be installed.</td>
</tr>

<tr>
	<th valign=top align=right>src/root_etc/</th>
	<td>** ROOT_ETC_DIR** *</td>
	<td>Configuration files to be installed into /etc/.</td>
</tr>


</table>

You might not find many references to **ROOT_ETC_DIR** in the Makefile .  The contents
of this directory are always installed to /etc/ , and do not (at this time) require abstraction.

There might be a time when abstraction is required, such as when working out the differences
between /etc/httpd/conf.d (RPM) and /etc/apache2/sites-enabled (Debian).  But, a simple deb package
that drops a configuration file could easily take care of that.

* **ROOT_ETC_DIR** is not to be confused with **ROOT_CONF_DIR** :
  * **ROOT_ETC_DIR** always corresponds to the relationship between src/root_etc and /etc
  * **ROOT_CONF_DIR** corresponds to the directory /etc/IAS/project-name that contains configuration for a project.

When you ask your code to search for configuration files for your project that have been installed under /etc
you tell it to search **ROOT_CONF_DIR**.

Hopefully this clarifies things:

* src/root_etc/httpd/conf.d/project-name.conf - **ROOT_ETC_DIR**/httpd/conf.d/project.name.conf
* src/root_etc/IAS/project-name/project-name.json - **ROOT_CONF_DIR**/project-name.json 


### Configuration and RPM

On RPM based systems:

* "%config noreplace" is specified for configuration files installed to /etc.
* "%config " is specified for configuration files installed to project configuration directories

The reasoning is as follows:

* If you do not want a configuration directive to be updated when you update the package, then
you should use **ROOT_ETC_DIR**
* If you want a configuration directive to be updated when the package is updated, then use **CONF_DIR**

The semantics of **CONF_DIR** with regard to updates on RPM have yet to be tested.

I believe that **ROOT_ETC_DIR** directives function as intended.  This allows for systems (like Puppet)
to manage configuration files.

### Configuration and Deb

The contents of both **ROOT_ETC_DIR** and **CONF_DIR** are marked as configuration files in Deb.

The semantics of updating only **CONF_DIR** with a package update have not been fully fledged out. 

# Transient Locations

The following are used inside of project directory and have rules about being checked in.
They are there for convenience: you check out a project, and it should know where
transient files go.

Not all projects will have all of these transient locations.  If the directories get
checked in, then the contents of the directories never get checked in.

If you want to save transient data for testing / running purposes, please
consider saving them somewhere else, like **test/** or **run_scripts/** .

<table>
<tr>
	<th>Project Location</th>
	<th>Alias</th>
	<th>Purpose</th>
	<th>Checked in?</th>
</tr>
<tr>
	<th valign=top align=right>build/</th>
	<td>**BUILD_DIR**</th>
	<td>Files that result from building parts of (or all) of your project; some of which
	are destined to be installed.</td>
	<td>NEVER</td>
</tr>
<tr>
	<th valign=top align=right>src/input/</th>
	<td>**INPUT_DIR**</td>
	<td>Files that are to be processed by your project.</td>
	<td>Yes, but never the contents.</td>
</tr>
<tr>
	<th valign=top align=right>src/output/</th>
	<td>**OUTPUT_DIR**</th>
	<td>Files that were created by your project that aren't destined to be installed as part of a package.
	I.E. You put a file in input, and run your program.  It puts a file in the output directory.
	</td>
	<td>
		Yes, but never the contents.
	</td>
</tr>
<tr>
	<th valign=top align=right>drop/</th>
	<td>**DROP_DIR**</td>
	<td>"Drop" (i.e. place) things like source distribution bundles (tar.gz files, etc)
	into this directory, and write a Makefile that (could):
	<ul>
		<li>Extract portions of that file onto your source tree</li>
		<li>or extract the source tree somewhere, and install it into build/ , and build a package
	</ul>
	</td>
	<td>
		Yes, but never the contents.
	</td>
</tr>
<tr>
	<th valign=top align=right>src/log/</th>
	<td>**LOG_DIR**</td>
	<td>Log output.</td>
	<td>Yes, but never the contents.</td>
</tr>

</table>

## BUILD_DIR

**BUILD_DIR** is NEVER checked in, as __make clean__ completely removes it.

## INPUT_DIR and OUTPUT_DIR

The easiest way to understand this is to think of a pipeline of things.

* (Maybe) something gets put into **INPUT_DIR** .
* (Maybe) your program(s) process it.
* (Maybe) something gets put into **OUTPUT_DIR** .

## Examples

A usage of **INPUT_DIR**
* An SFTP server is configured to allow specific users to put files into **INPUT_DIR** .
* **INPUT_DIR** is periodically checked for files to be processed; such as importing a
CSV file into a database

A usage of **OUTPUT_DIR**
* A report runs and creates an output file.
* It emails a list of recipients a URL to that output file
* Apache has been configured to export **OUTPUT_DIR** with password protected access.

