---
title: Installation
---

# 🛠 Installation

## 1. 📥 Download or clone the repository

[TIP] Skip this step, if you're going to install the module directly from **GitHub** repository.

```sh
mkdir -pv ~/workspaces/projects
cd ~/workspaces/projects

# HTTPS:
git clone https://github.com/bybatkhuu/model-python-template.git
# Or SSH (development):
git clone git@github.com:bybatkhuu/model-python-template.git

cd model-python-template
```

Alternatively, download the source from the [**releases**](https://github.com/bybatkhuu/model-python-template/releases) page and extract it into your projects directory.

## 2. 📦 Install the module

[NOTE] Choose one of the following methods to install the module **[A ~ E]**:

**OPTION A.** Install directly from **git** repository:

```sh
pip install git+https://github.com/bybatkhuu/model-python-template.git
```

**OPTION B.** Install from the downloaded **source code**:

```sh
# Install directly from the source code:
pip install .

# Or install with editable mode:
pip install -e .
```

**OPTION C.** Install for **DEVELOPMENT** environment:

```sh
pip install -e .[dev]

# Install pre-commit hooks:
pre-commit install
```

**OPTION D.** Install from **pre-built package** files (for **PRODUCTION**):

1. Download **`.whl`** or **`.tar.gz`** file from [**releases**](https://github.com/bybatkhuu/model-python-template/releases).
2. Install with pip:

```sh
# Install from .whl file:
pip install ./simple_model-[VERSION]-py3-none-any.whl

# Or install from .tar.gz file:
pip install ./simple_model-[VERSION].tar.gz
```

**OPTION E.** Copy the **module** into the project directory (for **testing**):

```sh
# Install python dependencies:
pip install -r ./requirements.txt

# Copy the module source code into the project:
cp -r ./src/simple_model [PROJECT_DIR]
# For example:
cp -r ./src/simple_model /some/path/project/
```
