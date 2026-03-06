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

```sh
# Create projects directory:
mkdir -pv ~/workspaces/projects

# Enter into projects directory:
cd ~/workspaces/projects

# Clone the repository:
git clone [REPOSITORY_URL]
# Or download and extract the repository from GitHub:
# 1. Go to the repository on GitHub.
# 2. Click on the "Code" button.
# 3. Select "Download ZIP" and save the file to your computer.
# 4. Extract the ZIP file in current directory.

# Enter into the repository:
cd model-python-template

# Change to cookiecutter branch:
git checkout cookiecutter
```

### 3. 📦 Install cookiecutter

```bash
# Install cookiecutter:
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
cd [PROJECT_SLUG]
```

👍

---

## 📑 References

- Cookiecutter (GitHub) - <https://github.com/cookiecutter/cookiecutter>
- Cookiecutter (Docs) - <https://cookiecutter.readthedocs.io/en/stable>
