#! /usr/bin/env bash
set -x
(return 0 2>/dev/null) || (echo "This script is made for sourcing" >&2 && exit 1)

_options=$($(brew --prefix gnu-getopt)/bin/getopt --longoptions environment: --options e: -- "$@")

if [ $? -eq 0 ] || [ $_options -eq "--" ]; then
  echo "Argument required: -e, --environment <environment>" 2>&1
  exit 1
fi

unset _env
unset _shortenv

eval set -- "$_options"
while true; do
  case "$1" in
    --environment)
      shift;
      _env=$1
      ;;
    -e)
      shift;
      _env=$1
      ;;
    --)
      shift
      break
      ;;
  esac
  shift
done

case "$_env" in
  development) _shortenv="dev" ;;
  staging) _shortenv="stage" ;;
  production) _shortenv="prod" ;;
  dev) _env="development" ;;
  stage) _env="staging" ;;
  prod) _env="production" ;;
esac

if [[ $_env =~ "development|staging|production" ]]; then
  export KAJABICTL_ENV=$_env
  export KAJABICTL_SHORTENV=$_shortenv
else
  echo "Incorrect options provided"
  exit 1
fi
