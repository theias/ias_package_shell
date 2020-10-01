import setuptools
import os
import glob
with open("README.md", "r") as fh:
    long_description = fh.read()

# This works around the issue of having the "bin"
# dir being a symbolic link.
bin_files = list(
    map(
        os.path.abspath,
        glob.glob(
            os.path.join(
                os.path.dirname(os.path.realpath(__file__)),
                'src/bin',
                '*.py'
            )
        )
    )
)


setuptools.setup(
    name="[% project.package_name %]-YOUR-USERNAME-HERE", # Replace with your own username
    version="0.0.1",
    author="Example Author",
    author_email="author@example.com",
    description="A small example package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://repo-url.example.com/pypa/sampleproject",

	# This is where you specify scripts
	scripts=bin_files,

	# This finds your packages
    packages=setuptools.find_namespace_packages('src/lib/python3'),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GPL-3.0-only",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)

# Other things:
# For entry points, see: https://packaging.python.org/specifications/entry-points/
