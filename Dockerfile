# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

ARG PYTHON_VERSION=3.10
ARG BASE_IMAGE=python:${PYTHON_VERSION}-slim-trixie

ARG DEBIAN_FRONTEND=noninteractive
ARG PROJECT_SLUG="model-python-template"


## Here is the builder image:
FROM ${BASE_IMAGE} AS builder

ARG DEBIAN_FRONTEND
ARG PROJECT_SLUG

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR "/usr/src/${PROJECT_SLUG}"

COPY ./ ./
RUN	--mount=type=cache,target=/root/.cache,sharing=locked \
	_BUILD_TARGET_ARCH=$(uname -m) && \
	echo "BUILDING TARGET ARCHITECTURE: ${_BUILD_TARGET_ARCH}" && \
	python -m pip install --timeout 60 -U pip && \
	# python -m venv .venv && \
	# source .venv/bin/activate && \
	# python -m pip install --timeout 60 -U pip && \
	# python -m pip install --timeout 60 -r ./requirements/requirements.build.txt && \
	# python -m build -w && \
	# deactivate && \
	# python -m pip install --prefix=/install --timeout 60 ./dist/*.whl && \
	python -m pip install --prefix=/install --timeout 60 -r ./requirements/requirements.test.txt && \
	python -m pip install --prefix=/install --timeout 60 -r ./requirements/requirements.build.txt && \
	python -m pip install --prefix=/install --timeout 60 jupyterlab jupyterlab-lsp "python-lsp-server[all]"


## Here is the base image:
FROM ${BASE_IMAGE} AS base

ARG DEBIAN_FRONTEND
ARG PROJECT_SLUG

## IMPORTANT!: Get hashed password from build-arg!
## echo "USER_PASSWORD123" | openssl passwd -5 -stdin
ARG HASH_PASSWORD="\$5\$Jl675L6M1BQQTRWr\$O35sVvpaT4dQVt.G9o9ZDnp0i1Ub05rEqfEzb8Gh00D"
## python -c "from jupyter_server.auth import passwd; print(passwd('USER_PASSWORD123'))"
# ARG JUPYTERLAB_PASSWORD_HASH="argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$wnIeLsNlGKEyUUTxl1lVSg\$dy9k/D3w95OpTbAJbm3nl5Q+J97cmA/RG4whANSBKZk" # pragma: allowlist secret
ARG UID=1000
ARG GID=11000
ARG USER=user
ARG GROUP=devs
ARG WORKSPACES_DIR="/home/${USER}/workspaces"
ARG PROJECTS_DIR="${WORKSPACES_DIR}/projects"
ARG PROJECT_DIR="${PROJECTS_DIR}/${PROJECT_SLUG}"
ARG SSH_PORT=22
ARG JUPYTERLAB_PORT=8888

ENV UID=${UID} \
	GID=${GID} \
	USER=${USER} \
	GROUP=${GROUP} \
	PROJECT_SLUG=${PROJECT_SLUG} \
	WORKSPACES_DIR=${WORKSPACES_DIR} \
	PROJECTS_DIR=${PROJECTS_DIR} \
	PROJECT_DIR=${PROJECT_DIR} \
	SSH_PORT=${SSH_PORT} \
	JUPYTERLAB_PORT=${JUPYTERLAB_PORT} \
	PYTHONIOENCODING=utf-8 \
	PYTHONUNBUFFERED=1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN rm -vrf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /root/.cache/* && \
	apt-get clean -y && \
	apt-get update --fix-missing -o Acquire::CompressionTypes::Order::=gz && \
	apt-get install -y --no-install-recommends \
		sudo \
		ca-certificates \
		locales \
		tzdata \
		procps \
		iputils-ping \
		net-tools \
		iproute2 \
		openssh-server \
		wget \
		curl \
		rsync \
		git \
		htop \
		ncdu \
		duf \
		fastfetch \
		# zsh \
		vim \
		nano && \
	apt-get clean -y && \
	python -m pip install --timeout 60 -U --no-cache-dir pip && \
	python -m pip cache purge && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	sed -i -e 's/# en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/' /etc/locale.gen && \
	sed -i -e 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8 && \
	echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale && \
	echo "LC_ALL=en_AU.UTF-8" >> /etc/default/locale && \
	addgroup --gid ${GID} ${GROUP} && \
	useradd -lmN -d "/home/${USER}" -s /bin/bash -g ${GROUP} -G sudo -u ${UID} ${USER} && \
	echo "${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" && \
	chmod 0440 "/etc/sudoers.d/${USER}" && \
	echo -e "${USER}:${HASH_PASSWORD}" | chpasswd -e && \
	echo -e "\nalias ls='ls -aF --group-directories-first --color=auto'" >> /root/.bashrc && \
	echo -e "alias ll='ls -alhF --group-directories-first --color=auto'\n" >> /root/.bashrc && \
	echo -e "\numask 0002" >> "/home/${USER}/.bashrc" && \
	echo "alias ls='ls -aF --group-directories-first --color=auto'" >> "/home/${USER}/.bashrc" && \
	echo -e "alias ll='ls -alhF --group-directories-first --color=auto'\n" >> "/home/${USER}/.bashrc" && \
	ssh-keygen -A && \
	mkdir -pv /run/sshd "/home/${USER}/.jupyter" "${PROJECT_DIR}" && \
	echo "c.ServerApp.ip = '*'" >> "/home/${USER}/.jupyter/jupyter_server_config.py" && \
	echo "c.ServerApp.port = ${JUPYTERLAB_PORT}" >> "/home/${USER}/.jupyter/jupyter_server_config.py" && \
	echo "c.ServerApp.open_browser = False" >> "/home/${USER}/.jupyter/jupyter_server_config.py" && \
	echo "c.ServerApp.allow_origin = '*'" >> "/home/${USER}/.jupyter/jupyter_server_config.py" && \
	# echo "c.IdentityProvider.token = ''" >> "/home/${USER}/.jupyter/jupyter_server_config.py" && \
	# echo "c.PasswordIdentityProvider.hashed_password = u'${JUPYTERLAB_PASSWORD_HASH}'" >> "/home/${USER}/.jupyter/jupyter_server_config.py" && \
	chown -Rc "${USER}:${GROUP}" "/home/${USER}/.jupyter" "${WORKSPACES_DIR}" && \
	find "/home/${USER}/.jupyter" "${PROJECTS_DIR}" -type d -exec chmod -c 770 {} + && \
	find "/home/${USER}/.jupyter" "${PROJECTS_DIR}" -type f -exec chmod -c 660 {} + && \
	find "/home/${USER}/.jupyter" "${PROJECTS_DIR}" -type d -exec chmod -c ug+s {} + && \
	rm -rfv /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /root/.cache/* "/home/${USER}/.cache/*"

ENV	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=en_AU.UTF-8

COPY --from=builder --chown=${UID}:${GID} /install /usr/local


## Here is the final image:
FROM base AS app

WORKDIR "${PROJECT_DIR}"
COPY --chown=${UID}:${GID} ./ ${PROJECT_DIR}
COPY --chown=${UID}:${GID} --chmod=770 ./scripts/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# EXPOSE ${SSH_PORT} ${JUPYTERLAB_PORT}
USER ${UID}:${GID}

ENTRYPOINT ["docker-entrypoint.sh"]
