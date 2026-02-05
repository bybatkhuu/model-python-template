# {{cookiecutter.project_name}}

{% if cookiecutter.license == "MIT License" -%}
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit)
{% elif cookiecutter.license == "Apache License 2.0" -%}
[![Apache License](https://img.shields.io/badge/License-Apache%202.0-red.svg)](https://choosealicense.com/licenses/apache-2.0)
{% elif cookiecutter.license == "GNU GPLv3" -%}
[![GPLv3 License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://choosealicense.com/licenses/gpl-3.0)
{% elif cookiecutter.license == "BSD License" -%}
[![BSD License](https://img.shields.io/badge/License-BSD-blue.svg)](https://choosealicense.com/licenses/bsd-3-clause-clear)
{% elif cookiecutter.license == "ISC License" -%}
[![ISC License](https://img.shields.io/badge/License-ISC-blue.svg)](https://choosealicense.com/licenses/isc)
{% endif -%}
{% if cookiecutter.license != "Proprietary License" -%}
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}/2.build-publish.yml?logo=GitHub)](https://github.com/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}/actions/workflows/2.build-publish.yml)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}?logo=GitHub&color=blue)](https://github.com/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}/releases)

{% endif -%}
{{cookiecutter.project_description}}

## ✨ Features

- AI/ML model
- Jupyter notebook
- Research
- Python module/package
- Configuration
- Test
- Build
- Documentation
- Scripts
- Examples
- CI/CD

---

## 🛠 Installation

### 1. 🚧 Prerequisites

- Install **Python (>= v{{cookiecutter.python_version}})** and **pip (>= 23)**:
    - **[RECOMMENDED] [Miniconda (v3)](https://www.anaconda.com/docs/getting-started/miniconda/install)**
    - *[arm64/aarch64] [Miniforge (v3)](https://github.com/conda-forge/miniforge)*
    - *[Python virutal environment] [venv](https://docs.python.org/3/library/venv.html)*
- *[OPTIONAL]* For **GPU (NVIDIA)**:
    - **NVIDIA GPU driver (>= v452.39)**
    - **NVIDIA CUDA (>= v11)** and **cuDNN (>= v8)**

[OPTIONAL] For **DEVELOPMENT** environment:

- Install [**git**](https://git-scm.com/downloads)
- Setup an [**SSH key**](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)

### 2. 📥 Download or clone the repository

[TIP] Skip this step, if you're going to install the package directly from **GitHub** repository.

**2.1.** Prepare projects directory (if not exists):

```sh
# Create projects directory:
mkdir -pv ~/workspaces/projects

# Enter into projects directory:
cd ~/workspaces/projects
```

**2.2.** Follow one of the below options **[A]**, **[B]** or **[C]**:

**OPTION A.** Clone the repository:

```sh
git clone https://github.com/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}.git && \
    cd {{cookiecutter.repo_name}}
```

**OPTION B.** Clone the repository (for **DEVELOPMENT**: git + ssh key):

```sh
git clone git@github.com:{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}.git && \
    cd {{cookiecutter.repo_name}}
```

**OPTION C.** Download source code:

1. Download archived **zip** file from [**releases**](https://github.com/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}/releases).
2. Extract it into the projects directory.

### 3. 📦 Install the package

[NOTE] Choose one of the following methods to install the package **[A ~ E]**:

**OPTION A.** Install directly from **GitHub** repository:

```sh
pip install git+https://github.com/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}.git
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

1. Download **`.whl`** or **`.tar.gz`** file from [**releases**](https://github.com/{{cookiecutter.repo_owner}}/{{cookiecutter.repo_name}}/releases).
2. Install with pip:

```sh
# Install from .whl file:
pip install ./{{cookiecutter.module_name}}-[VERSION]-py3-none-any.whl
# Or install from .tar.gz file:
pip install ./{{cookiecutter.module_name}}-[VERSION].tar.gz
```

**OPTION E.** Copy the **module** into the project directory (for **testing**):

```sh
# Install python dependencies:
pip install -r ./requirements.txt

# Copy the module source code into the project:
cp -r ./src/{{cookiecutter.module_name}} [PROJECT_DIR]
# For example:
cp -r ./src/{{cookiecutter.module_name}} /some/path/project/
```

## 🚸 Usage/Examples

### Simple

[**`examples/simple/main.py`**](./examples/simple/main.py):

```python
# Standard libraries
import os
import sys
import logging
import pathlib
from typing import Any

# Third-party libraries
import numpy as np
from numpy.typing import NDArray

# Internal modules
from {{cookiecutter.module_name}} import SimpleModel


logger = logging.getLogger(__name__)


def main() -> None:
    logging.basicConfig(
        stream=sys.stdout,
        level=logging.INFO,
        datefmt="%Y-%m-%d %H:%M:%S %z",
        format="[%(asctime)s | %(levelname)s | %(filename)s:%(lineno)d]: %(message)s",
    )

    # Pre-defined variables (for customizing and testing)
    _parent_dir = pathlib.Path(__file__).parent.resolve()
    _models_dir = str(_parent_dir.parent.parent / "models")

    if not os.path.isdir(_models_dir):
        os.makedirs(_models_dir, exist_ok=True)

    _model_name = "linear_regression.v0.0.1-24"

    _X_train = np.array([[1], [2], [3], [4], [5]])
    _y_train = np.array([2, 4, 6, 8, 10])

    _X_test = np.array([[6], [7], [8]])
    _y_test = np.array([10, 14, 16])

    # Main example
    logger.info("Creating and training a simple model...")

    # Create the model instance
    _config = {"models_dir": _models_dir, "model_name": _model_name}
    _model = SimpleModel(config=_config)

    # Train or load the model
    if not SimpleModel.is_model_files_exist(**_config):
        _model.train(X=_X_train, y=_y_train)
    else:
        _model.load()

    # Predict the target values
    _y_pred: NDArray[Any] = _model.predict(X=_X_test)
    logger.info(f"Predicted values for {_X_test.flatten()}: {_y_pred.flatten()}")

    # Evaluate the model
    _r2_score: float = _model.score(y_true=_y_test, y_pred=_y_pred)
    logger.info(f"R^2 score: {_r2_score}")

    _is_similar: bool = _model.is_similar(X=_X_test, y=_y_test)
    logger.info(f"Is similar: {_is_similar}")

    # Save the model
    if _model.is_trained() and (not SimpleModel.is_model_files_exist(**_config)):
        _model.save()

    logger.info("Done!\n")
    return


if __name__ == "__main__":
    main()
```

👍

---

## ⚙️ Configuration

[**`templates/configs/config.yml`**](./templates/configs/config.yml):

```yaml
{{cookiecutter.module_name}}:                                       # Just an example to group the configs (Not necessary)
  models_dir: "./models"                            # Directory where the models are saved
  model_name: "linear_regression.v0.0.1-250101"     # Name of the model as sub-directory
  threshold: 0.5                                    # Threshold for similarity check
```

### 🌎 Environment Variables

[**`.env.example`**](./.env.example):

```sh
# ENV=LOCAL
# DEBUG=false
# TZ=UTC
# PYTHONDONTWRITEBYTECODE=0
```

---

## 🧪 Running Tests

To run tests, run the following command:

```sh
# Install python test dependencies:
pip install .[test]

# Run tests:
python -m pytest -sv -o log_cli=true
# Or use the test script:
./scripts/test.sh -l -v -c
```

## 🏗️ Build Package

To build the python package, run the following command:

```sh
# Install python build dependencies:
pip install -r ./requirements/requirements.build.txt

# Build python package:
python -m build
# Or use the build script:
./scripts/build.sh
```

## 📝 Generate Docs

To build the documentation, run the following command:

```sh
# Install python documentation dependencies:
pip install -r ./requirements/requirements.docs.txt

# Serve documentation locally (for development):
mkdocs serve -a 0.0.0.0:8000 --livereload
# Or use the docs script:
./scripts/docs.sh

# Or build documentation:
mkdocs build
# Or use the docs script:
./scripts/docs.sh -b
```

## 📚 Documentation

- [Docs](./docs)

---

## 📑 References

- <https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html>
- <https://packaging.python.org/en/latest/tutorials/packaging-projects>
- <https://python-packaging.readthedocs.io/en/latest>
