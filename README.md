# Model Template (AI/ML) module (Cookiecutter)

This is a cookiecutter template for AI/ML model module projects.

## ✨ Features

- Cookiecutter
- AI/ML model
- Python module/package
- Jupyter notebook
- Research
- Project Structure
- Template
- CI/CD

---

## 🐤 Getting started

### 1. 🚧 Prerequisites

- Install **Python (>= v3.10)** and **pip (>= 23)**:
    - **[RECOMMENDED] [Miniconda (v3)](https://www.anaconda.com/docs/getting-started/miniconda/install)**
    - *[arm64/aarch64] [Miniforge (v3)](https://github.com/conda-forge/miniforge)*
    - *[Python virutal environment] [venv](https://docs.python.org/3/library/venv.html)*

For **DEVELOPMENT** environment:

- Install [**git**](https://git-scm.com/downloads)
- Setup an [**SSH key**](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)

### 2. 📥 Download or clone the repository

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
git clone https://github.com/[OWNER]/model-python-template.git && \
    cd model-python-template && \
    git checkout cookiecutter
```

**OPTION B.** Clone the repository (for **DEVELOPMENT**: git + ssh key):

```sh
git clone git@github.com:[OWNER]/model-python-template.git && \
    cd model-python-template && \
    git checkout cookiecutter
```

**OPTION C.** Download source code from cookiecutter branch.

### 3. 📦 Install cookiecutter

```bash
# Install cookiecutter:
pip install -U cookiecutter
# Or:
pip install -r ./requirements.txt
```

### 4. 🏗️ Generate project with cookiecutter

```bash
# Generate project:
cookiecutter -f .
# Or:
./scripts/build.sh
```

### 5. 🏁 Start the project

```bash
cd [PROJECT_NAME]
# For example:
cd model-python-template
```

👍

---

## 📑 References

- Cookiecutter (GitHub) - <https://github.com/cookiecutter/cookiecutter>
- Cookiecutter (Docs) - <https://cookiecutter.readthedocs.io/en/stable>
