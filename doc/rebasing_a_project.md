# Rebasing

The general idea here is that it's easier to create a new project and merge
your files into the project, than it is to merge the new project into your
files.

This will document the process.

# Create a Tag for When You Start the Rebase

```
marty@marty ias_password_ldap_checker_master$ git tag -a rebase-2019-02-27
marty@marty ias_password_ldap_checker_master$ git push origin rebase-2019-02-27
```

# Branch, copy, and clear:

```
marty@marty ias_password_ldap_checker$ git checkout -b rebase
marty@marty ias_password_ldap_checker$ cp -r ../ias_password_ldap_checker /var/tmp
##### PLEASE BE CAREFUL WITH THIS
# Ensure you are in the project directory you want to rebase,
# and that you have taken appropriate action (as documented above)
# to make sure you won't lose any important changes. 
marty@marty ias_password_ldap_checker$ rm -rf *
```

# Regenerate project

```
marty@marty ias_password_ldap_checker$ cd ..
marty@marty rebase$ ias_package_shell.pl 
Project names must not begin with numbers.
Project names must not contain whitespace or dashes.
Example: some_project_name
Required:
Project name: ias_password_ldap_checker
Required:
Short summary: Take a CSV of username and passwords and see if any are in LDAP
Wiki page: https://www.net.ias.edu/content/password-ldap-checker
Ticket URL: 
```

## cd in, and Put Stuff Back:



```
marty@marty rebase$ cd ias_password_ldap_checker/
```

### Source

These can mostly just be copied in.

```
marty@marty ias_password_ldap_checker$ cp -r /var/tmp/ias_password_ldap_checker/src .
```

### Documentation

These can mostly be copied in.  Keep in mind that the new README.md might contain
more updated information that could be merged.

```
marty@marty ias_password_ldap_checker$ cp -r /var/tmp/ias_password_ldap_checker/README.md .
marty@marty ias_password_ldap_checker$ cp -r /var/tmp/ias_password_ldap_checker/doc .
```

### Dependencies

Part of being better organized meant that dependencies needed to be specified in
different files.

These currently are:

* artifact-name/DEBIAN/control
* artifact-name/RPM/specfile.spec

You will need to examine and merge the necessary changes into those files.

# Add the Files and Examine the status

```
marty@marty ias_password_ldap_checker$ git add .
```

The majority of the files in a git status should show up as "modified" or renamed.

```
marty@marty ias_password_ldap_checker$ git status
On branch rebase
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   .gitignore
	modified:   Makefile
	modified:   README.md
	new file:   base.gmk
	modified:   doc/examples/cron/ias-password-ldap-checker
	new file:   ias-password-ldap-checker/DEBIAN/control
	renamed:    ias-password-ldap-checker/install_scripts/clean -> ias-password-ldap-checker/RPM/install_scripts/clean
	renamed:    ias-password-ldap-checker/install_scripts/post -> ias-password-ldap-checker/RPM/install_scripts/post
	renamed:    ias-password-ldap-checker/install_scripts/postun -> ias-password-ldap-checker/RPM/install_scripts/postun
	renamed:    ias-password-ldap-checker/install_scripts/pre -> ias-password-ldap-checker/RPM/install_scripts/pre
	renamed:    ias-password-ldap-checker/install_scripts/preun -> ias-password-ldap-checker/RPM/install_scripts/preun
	new file:   ias-password-ldap-checker/RPM/specfile.spec
	modified:   ias-password-ldap-checker/artifact_variables.gmk
	new file:   ias-password-ldap-checker/case.sh
	modified:   ias-password-ldap-checker/changelog
	renamed:    ias-password-ldap-checker/description -> ias-password-ldap-checker/common/description
	new file:   ias-password-ldap-checker/common/synopsis
	deleted:    ias-password-ldap-checker/deb_control
	deleted:    ias-password-ldap-checker/rpm_specific
	new file:   package_shell/make/artifact_module-java.gmk
	modified:   package_shell/make/make-standard_phonies.gmk
	modified:   package_shell/make/package_build-deb.gmk
	modified:   package_shell/make/package_build-rpm.gmk
	modified:   package_shell/make/package_install-base_directories.gmk
	new file:   package_shell/make/package_install-code_repository_info.gmk
	modified:   package_shell/make/package_install-conditional_additions.gmk
	new file:   package_shell/make/package_install-mapped_symbolic_links.gmk
	modified:   package_shell/make/package_shell-additional.gmk
	modified:   package_shell/make/project-base_variables.gmk
	modified:   package_shell/make/project_directories-full_project.gmk
	modified:   spell_check.sh
	new file:   src/bin/ias-password-ldap-checker_hello.sh
```

### Including, but not limited to...

Pay special attention to the output from **git status** , as it might indicate
more stuff that you should copy back into the project.  This might include
(but isn't limited to)

* tests
* README.md
* changelog

## Commit, and merge back

```
marty@marty ias_password_ldap_checker$ git commit -m 'rebased'
marty@marty ias_password_ldap_checker$ git checkout master
Switched to branch 'master'
marty@marty ias_password_ldap_checker$ git merge rebase
```

# Notes

## Troubleshooting

If you have problems with what you might have left behind then check out
the tag that you made before.

## Future Proofing

Newer versions of Package Shell make an attempt to be "future proof", so
that rebasing complex projects gets more simple.

## Byproducts

Rebasing the package will potentially create unneccessary files, which will be listed
when you do a **git status** .
