# .rpmmacros

This is what's in my ~/.rpmmacros file. It's not required, but the packaging environment should work with something similar.

```
%_topdir               /home/marty/code/build
%_tmppath              %{_topdir}
%_rpmtopdir            %{_topdir}/%{name}
%_builddir             %{_tmppath}/BUILD
%_rpmdir               %{_rpmtopdir}
%_sourcedir            %{_rpmtopdir}
%_specdir              %{_rpmtopdir}
%_srcrpmdir            %{_rpmtopdir}
 
%_signature            gpg
%_gpg_path             ~/.gnupg
%_gpg_name             Martin VanWinkle 
%_gpgbin                /usr/bin/gpg
 
%packager              Martin VanWinkle
%_unpackaged_files_terminate_build 0
%_missing_doc_files_terminate_build 0
%define debug_package %{nil}
%debug_package %{nil}
```

# Package Shell Software

The software can be obtained from here:

* https://github.com/theias/ias_package_shell/

The README has "generic" building instructions that ship with all packages and needs to be modified, but all you should have to do is:

```
sudo yum install rpmbuild make
git clone (URL from above)
cd ias_package_shell*
fakeroot make package-rpm
# Then install the RPM.
sudo yum localinstall -y (rpm)
```

For Debian based systems:
```
sudo apt-get install gdebi build-essential
git clone (URL from above)
cd ias_package_shell*
fakeroot make package-deb
# Then install the RPM.
sudo gdebi install (deb package)
```

It's probably overkill to install all of build-essential; I need to figure out the minimum
dependency set for this.
