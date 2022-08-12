#!/bin/bash
export PYTHONPATH="${PYTHONPATH}:/app/src/"

# Start opensearch in the background
if [[ $(docker ps -a | grep 9600 | grep -v Exited) ]]; then
    echo "opennsearch is running"
else
    echo "opensearch not running"
    # START POC:  creating a new process:
    echo which gcc
    which gcc
    /app/processes/trivial_process &
    # END POC
#    docker run --runtime=runsc --name opensearch -id -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" opensearchproject/opensearch:2.1.0
    # do an if statement - here!
#    docker start opensearch &
fi
#echo checking for docker ip:
# probably check whether the user has set a remote cluster, first...
#docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' opensearch
#OPENSEARCH_IP="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' opensearch)"
OPENSEARCH_IP="1.2.3"
export OPENSEARCH_IP
# Start the neural search web app in the background
cd /app/src/marqo/neural_search || exit
#uvicorn api:app --host 0.0.0.0
sh
# Wait for any process to exit
#wait -n

# Exit with status of process that exited first
#exit $?