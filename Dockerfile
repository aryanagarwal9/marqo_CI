# docker rm -f marqo; DOCKER_BUILDKIT=1 docker build . -t marqo_docker_0 && docker run --name marqo -p 8000:8000 marqo_docker_0
# docker run --name marqo -v /var/run/docker.sock:/var/run/docker.sock -p 8000:8000 marqo_docker_0
# docker run --name marqo -p 8000:8000 marqo_docker_0
# docker run --name opensearch -id -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" opensearchproject/opensearch:2.1.0

#FROM nestybox/ubuntu-jammy-docker
FROM opensearchproject/opensearch:2.1.0
WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive
RUN su yum update
RUN yum install -y python38 python38-devel
COPY requirements.txt requirements.txt
RUN python3.8 -m pip install -r requirements.txt
COPY . /app
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
RUN chmod +x ./run_marqo.sh
CMD ./run_marqo.sh