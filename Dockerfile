# docker rm -f marqo; DOCKER_BUILDKIT=1 docker build . -t marqo_docker_0 && docker run --name marqo -p 8000:8000 marqo_docker_0
# docker run --name marqo -p 8000:8000 marqo_docker_0
# docker run --name opensearch -id -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" opensearchproject/opensearch:2.1.0
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app
RUN apt-get update
RUN apt-get install software-properties-common -y # used to install  add-apt-repository
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install ca-certificates curl  gnupg lsof lsb-release jq -y
RUN apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common wget -y
RUN apt-get install python3.8-distutils -y # python3-distutils
RUN apt-get  install python3.8 python3-pip -y # pip is 276 MB!
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg
RUN apt-get -y install runc
RUN ( \
  set -e ;\
  ARCH=$(uname -m) ;\
  URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH} ;\
  wget ${URL}/runsc ${URL}/runsc.sha512 \
    ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512 ;\
  sha512sum -c runsc.sha512 \
    -c containerd-shim-runsc-v1.sha512 ;\
  rm -f *.sha512 ;\
  chmod a+rx runsc containerd-shim-runsc-v1 ;\
  mv runsc containerd-shim-runsc-v1 /usr/local/bin ;\
)
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt install docker-ce docker-ce-cli containerd.io -y
RUN curl -fsSL https://gvisor.dev/archive.key | gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] https://storage.googleapis.com/gvisor/releases release main" | tee /etc/apt/sources.list.d/gvisor.list > /dev/null
RUN apt-get update && apt-get install -y runsc
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . /app
RUN apt-get install build-essential
RUN gcc -static -c /app/processes/trivial_process.c -o /app/processes/trivial_process
RUN chmod +x /app/processes/trivial_process
RUN chmod +x ./run_marqo.sh
CMD ./run_marqo.sh