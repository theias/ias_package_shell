PIP_MAKEFILE_PATH = $(strip $(dir $(firstword $(MAKEFILE_LIST))))
TRANSIENT_SRC_DIR=transient_src

package-pip: clean prep copy-src pip

copy-src:
	cp -r "$(PIP_MAKEFILE_PATH)/../../src" "$(TRANSIENT_SRC_DIR)"

pip:
	python3 setup.py sdist bdist_wheel	

install-pip: clean prep copy-src
	cd $(PIP_MAKEFILE_PATH) && python3 -m pip install .

examine-pip:
	tar -tzf dist/*.tar.gz

prep:
	python3 -m pip install --user --upgrade setuptools wheel testresources

clean:
	-cd $(PIP_MAKEFILE_PATH) && rm -r build dist *.egg-info "$(TRANSIENT_SRC_DIR)"
