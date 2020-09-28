pip:
	python3 setup.py sdist bdist_wheel	

examine_pip:
	tar -tzf dist/*.tar.gz

prep:
	python3 -m pip install --user --upgrade setuptools wheel testresources

clean:
	-rm -r build dist *.egg-info
