
# Package Shell Software

The software can be obtained from here:

* https://github.com/theias/ias_package_shell/

The README has "generic" building instructions that ship with all packages and needs to be modified, but all you should have to do is:

```
sudo yum install rpmbuild make
git clone (URL from above)
cd ias_package_shell*
fakeroot make package-rpm
# Then install the package.
sudo yum localinstall -y (rpm)
```

For Debian based systems:
```
sudo apt-get install gdebi build-essential
git clone (URL from above)
cd ias_package_shell*
fakeroot make package-deb
# Then install the package.
sudo gdebi install (deb package)
```

It's probably overkill to install all of build-essential; I need to figure out the minimum
dependency set for this.
