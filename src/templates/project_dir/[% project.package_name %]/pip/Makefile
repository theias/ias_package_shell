PIP_MAKEFILE_PATH = $(strip $(dir $(firstword $(MAKEFILE_LIST))))

pip:
	python3 setup.py sdist bdist_wheel	

install_pip:
	cd $(PIP_MAKEFILE_PATH); python3 -m pip install .

examine_pip:
	tar -tzf dist/*.tar.gz

prep:
	python3 -m pip install --user --upgrade setuptools wheel testresources

clean:
	-rm -r build dist *.egg-info
