# TODO

GitHub funding.yml

## Documentation

### Command Line Options

### Project Control

Variable targets for package installation, instead of hard-coded
targets.

```
include blah.gmk
targets ?= a b c
all: $(targets)

a:
	echo 'a!'
b:
	echo 'b!'
c:
	echo 'c!'
```

```
# blah.gmk
targets ?= a c
```

## Tests

* Test templates
** More rigorous regular expression template exclusion testing
* Post installation script with different project-path-output (change dir to project-path-output(?))

## Code

### Refactoring

* Better structured access to control data and project data from within
* Decrease non-local-scope variable usage 

## Project Reorganization

* use ?= more often

* Separate Java tests / template

## Templates

* release , tests, included in artifact_variables.gmk.
* PHP syntax checking
