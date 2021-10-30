#!/bin/bash

echo "Container is running!!!"

# this will run the api/service.py file with the instantiated app FastAPI
# NOTE: This runs the DEV versions with Hotreload: --reload --reload-dir api/ "$@"
uvicorn_server() {
    uvicorn api.service:app --host 0.0.0.0 --port 9000 --log-level debug --reload --reload-dir api/ "$@"
}

# NOTE: This runs the actual production version of your server
# This does not have hot reload since your live server you need a restart to load code changes
# And this will only be updated when the dev is good enough and tested
uvicorn_server_production() {
    pipenv run uvicorn api.service:app --host 0.0.0.0 --port 9000 --lifespan on
}

export -f uvicorn_server
export -f uvicorn_server_production

echo -en "\033[92m
The following commands are available:
    uvicorn_server
        Run the Uvicorn Server
\033[0m
"

# Determine what to call on startup, shell for dev because we want interactive
# And production we don't want anything interactive, just the production running
if [ "${DEV}" = 1 ]; then
  pipenv shell
else
  uvicorn_server_production
fi