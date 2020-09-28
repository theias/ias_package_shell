import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

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
	# scripts=['bin/some_script.py'],

	# This finds your packages
    packages=setuptools.find_namespace_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GPL-3.0-only",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)

# Other things:
# For entry points, see: https://packaging.python.org/specifications/entry-points/
