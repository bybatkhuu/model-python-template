#!/usr/bin/env bash
set -euo pipefail


## --- Base --- ##
_PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-"$0"}")" >/dev/null 2>&1 && pwd -P)"
cd "${_PROJECT_DIR}" || exit 2


# shellcheck disable=SC1091
[ -f .env ] && . .env


# Checking docker and docker-compose installed:
if ! command -v docker >/dev/null 2>&1; then
	echo "[ERROR]: Not found 'docker' command, please install it first!" >&2
	exit 1
fi

if ! docker info > /dev/null 2>&1; then
	echo "[ERROR]: Unable to communicate with the docker daemon. Check docker is running or check your account added to docker group!" >&2
	exit 1
fi

if ! docker compose > /dev/null 2>&1; then
	echo "[ERROR]: 'docker compose' not found or not installed!" >&2
	exit 1
fi
## --- Base --- ##


## --- Variables --- ##
_DEFAULT_SERVICE="model"
## --- Variables --- ##


## --- Functions --- ##
_build()
{
	# shellcheck disable=SC2068
	docker compose --progress=plain build $@ || exit 2
}

_validate()
{
	docker compose config || exit 2
}

_start()
{
	if [ "${1:-}" == "-l" ]; then
		shift
		# shellcheck disable=SC2068
		docker compose up -d --remove-orphans --force-recreate $@ || exit 2
		_logs "$@"
	else
		# shellcheck disable=SC2068
		docker compose up -d --remove-orphans --force-recreate $@ || exit 2
	fi
}

_stop()
{
	if [ -z "${1:-}" ]; then
		docker compose down --remove-orphans || exit 2
	else
		# shellcheck disable=SC2068
		docker compose rm -sfv $@ || exit 2
	fi
}

_restart()
{
	if [ "${1:-}" == "-l" ]; then
		shift
		_stop "$@" || exit 2
		_start -l "$@" || exit 2
	else
		_stop "$@" || exit 2
		_start "$@" || exit 2
	fi
	# docker compose restart $@ || exit 2
}

_logs()
{
	# shellcheck disable=SC2068
	docker compose logs -f -n 100 $@ || exit 2
}

_list()
{
	docker compose ps || exit 2
}

_ps()
{
	# shellcheck disable=SC2068
	docker compose top $@ || exit 2
}

_stats()
{
	# shellcheck disable=SC2068
	docker compose stats $@ || exit 2
}

_exec()
{
	if [ -z "${1:-}" ]; then
		echo "[ERROR]: Not found any arguments for exec command!" >&2
		exit 1
	fi

	echo "[INFO]: Executing command inside '${_DEFAULT_SERVICE}' container..."
	# shellcheck disable=SC2068
	docker compose exec "${_DEFAULT_SERVICE}" $@ || exit 2
}

_enter()
{
	local _service="${_DEFAULT_SERVICE}"
	if [ -n "${1:-}" ]; then
		_service=${1}
	fi

	echo "[INFO]: Entering inside '${_service}' container..."
	docker compose exec "${_service}" /bin/bash || exit 2
}

_images()
{
	# shellcheck disable=SC2068
	docker compose images $@ || exit 2
}

_clean()
{
	# shellcheck disable=SC2068
	docker compose down -v --remove-orphans $@ || exit 2
}

_update()
{
	if docker compose ps | grep 'Up' > /dev/null 2>&1; then
		_stop "$@" || exit 2
	fi

	# shellcheck disable=SC2068
	docker compose pull --policy always $@ || exit 2
	# shellcheck disable=SC2046
	docker rmi -f $(docker images --filter "dangling=true" -q --no-trunc) > /dev/null 2>&1 || true

	# _start "$@" || exit 2
}
## --- Functions --- ##


## --- Menu arguments --- ##
_usage_help() {
	cat <<EOF
USAGE: ${0} <command> [args...]

COMMANDS:
    build
    validate | valid | config
    start | run | up
    stop | down | remove | rm | delete | del
    restart
    logs | log
    list
    ps
    stats | resource | limit
    exec
    enter
    images
    clean | clear
    update | pull | download

OPTIONS:
    -h, --help    Show this help message.
EOF
}

if [ $# -eq 0 ]; then
	echo "[ERROR]: Not found any input!" >&2
	_usage_help
	exit 1
fi

while [ $# -gt 0 ]; do
	case "${1}" in
		build)
			shift
			_build "$@"
			exit 0;;
		validate | valid | config)
			shift
			_validate
			exit 0;;
		start | run | up)
			shift
			_start "$@"
			exit 0;;
		stop | down | remove | rm | delete | del)
			shift
			_stop "$@"
			exit 0;;
		restart)
			shift
			_restart "$@"
			exit 0;;
		logs | log)
			shift
			_logs "$@"
			exit 0;;
		list)
			shift
			_list
			exit 0;;
		ps)
			shift
			_ps "$@"
			exit 0;;
		stats | resource | limit)
			shift
			_stats "$@"
			exit 0;;
		exec)
			shift
			_exec "$@"
			exit 0;;
		enter)
			shift
			_enter "$@"
			exit 0;;
		images)
			shift
			_images "$@"
			exit 0;;
		clean | clear)
			shift
			_clean "$@"
			exit 0;;
		update | pull | download)
			shift
			_update "$@"
			exit 0;;
		-h | --help)
			_usage_help
			exit 0;;
		*)
			echo "[ERROR]: Failed to parse argument -> ${1}!" >&2
			_usage_help
			exit 1;;
	esac
done
## --- Menu arguments --- ##
