FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev zsh curl git
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

COPY requirements.txt /root/requirements.txt
RUN python3 -m pip install -r /root/requirements.txt

RUN airflow users create --role admin --username admin --email admin --firstname admin --lastname admin --password admin
RUN airflow db init
COPY airflow.cfg /root/airflow/airflow.cfg


CMD (airflow scheduler &) && airflow webserver