## Processes

* https://github.com/theias/ias_package_shell

### Debian System Setup

```
sudo apt-get install gdebi build-essential git
```

### src Dir Setup

```
mkdir ~/src
```

### repo Dir Setup

```
mkdir ~/repos
```

### Project Repository Creation

```
cd ~/repos
mkdir your_name_project_1
cd your_name_project_1
git init --bare .
```

### Clone Project

```
cd ~/src
git clone ...
```
#### Example

```
cd ~/src
git clone ~/repos/your_name_project_1
```

### Build Project

```
cd (project you've cloned)
fakeroot make package-deb # Debian
fakeroot make package-rpm # rpm
```

#### Example

```
cd ~/src/your_name_project_1
fakeroot make package-deb
```

### Install

```
sudo gdebi (package file from Build Project command)
```

### Initialize Project

```
cd ~src
git clone ~/repos/your_name_project_1
ias_package_shell.pl
# Answer the questions
Project Name: your_name_project_1
Summary: Some project
# Rest is optional
```

Then cd into the directory:

```
cd your_name_project_1
```

### Simple Git Process

```
git add .
git commit -m 'committing'
git push
```

## Tagging

* Update Changelog with version

```
git status # Make sure nothing to commit
git tag -a v1.0.0-0
git push origin v1.0.0-0
```


