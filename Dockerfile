# docker rm -f marqo; DOCKER_BUILDKIT=1 docker build . -t marqo_docker_0 && docker run --name marqo -v /var/run/docker.sock:/var/run/docker.sock -p 8000:8000 marqo_docker_0
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
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt install docker-ce docker-ce-cli containerd.io -y
#get nestybox:
RUN wget https://downloads.nestybox.com/sysbox/releases/v0.5.2/sysbox-ce_0.5.2-0.linux_amd64.deb
# TODO sha check on nestybox here...
RUN apt-get install ./sysbox-ce_0.5.2-0.linux_amd64.deb -y

# RUN apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
# do we even need to copy across requirements?
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
#COPY ./src /app/src
COPY . /app
#COPY run_marqo.sh /app/run_marqo.sh
#COPY tox.ini /app/run_marqo.sh
#COPY tests /app/tests
#COPY setup.py /app/setup.py
#COPY setup.py /app/setup.py
RUN chmod +x ./run_marqo.sh
CMD ./run_marqo.sh