## Python Development

### Setup

```bash
python3 -m venv venv

# Install requirements, if any:

./venv/bin/pip install -r requirements.txt

# This allows you to build a pip
./venv/bin/pip install build
```

It might ask you to upgrade.
Upgrading as described worked at the time of this writing.

### Running

```
./venv/bin/python3 ./src/bin/ccore-python-test.py
```

### Building a pip

```bash
./venv/bin/python3 -m build
```

### Installing it for your user

```bash
python3 -m pip install --user .
```

