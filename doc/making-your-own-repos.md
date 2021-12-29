# Quick and (Not complete...) Repository Creation

You will want to (potentially) bolt on whatever processes
(such as signing) to these.

All of our production RPMs are signed.

## RPM

Here's how you create a repo where you're inside of the
directory with the RPMs:
```
createrepo .
```

Here's an example yum repo file

* /etc/yum.repos.d/example.repo

```
[example-noarch-rpms]
baseurl=https://example.com/my-group/rpm/noarch/
enabled=1
gpgcheck=1
failovermethod=priority
# gpgkey=https://example.com/my-group/rpm/noarch/pkgsign.asc
```

If you want to have a (more) secure process, you should look into
signing with:

```
rpm --addsign something.rpm
```

## Debian

```
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
```

Here's an example apt configu file
* /etc/apt/sources.list.d/example.list

```
deb [trusted=yes] https://example.com/my-group/deb/all/ /
```

