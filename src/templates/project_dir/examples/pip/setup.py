# Put this in the root of your project directory if you
# want to make pips out of it.
#
# prepare for the pip
# python3 -m pip install --user --upgrade setuptools wheel testresources
#
#
# make a pip
# python3 setup.py sdist bdist_wheel
#
# install the pip
# python3 -m pip install .
#
# examine the pip:
# tar -tzf dist/*.tar.gz
#
# clean up afterward
# rm -r build dist src/lib/python3/*.egg-info

import setuptools
import os
import glob


SRC_DIR="src"
LIB_DIR=os.path.join(
    SRC_DIR,
    "lib",
    "python3"
)
BIN_DIR=os.path.join(
    SRC_DIR,
    "bin"
)

BIN_FILES = glob.glob(os.path.join(
    BIN_DIR,
    "*.py",
))

with open("README.md", "r") as fh:
    long_description = fh.read()

setup_args = {
    'name' : "[% project.package_name %]-YOUR-USERNAME-HERE", # Replace with your own username
    'version' : "0.0.1",
    'author' : "Example Author",
    'author_email' : "author@example.com",
    'description' : "A small example package",
    'long_description' : long_description,
    'long_description_content_type' : "text/markdown",
    'url' : "https://repo-url.example.com/pypa/sampleproject",

    'classifiers' : [
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    'python_requires' : '>=3.6',
    # 'install_requires' : [ ],
}

if BIN_FILES:
    setup_args['scripts'] = BIN_FILES

if os.path.exists(LIB_DIR):
    setup_args['packages'] = setuptools.find_namespace_packages(LIB_DIR)
    setup_args['package_dir'] = {'': LIB_DIR}

setuptools.setup( **setup_args)

# Other things:
# For entry points, see: https://packaging.python.org/specifications/entry-points/
