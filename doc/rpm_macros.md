
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
