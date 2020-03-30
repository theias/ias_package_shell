```
# Just once
cd /tmp
sudo apt-get install gdebi build-essential fakeroot;
git clone https://github.com/theias/ias_package_shell ; cd ias_package_shell ; fakeroot make package-deb
sudo gdebi build/ias-package-shell/ias-package-shell_*.deb;

# Then, over and over again:
ias_package_shell.pl

# Answer questions:
Project Name: why_is_stuff_hard
Summary: stuff is hard
Wiki: <blank>
Ticket: <blank>

cd why_is_stuff_hard ; fakeroot make package-deb
sudo gdebi build/why-is-stuff-hard/why-is-stuff-hard*.deb

# Run it:

/opt/IAS/bin/why-is-stuff-hard/why-is-stuff-hard_hello.sh

# Don't like where stuff is installed?  Add this to base.gmk
BASE_DIR := /opt/WhereverYouWant
```
