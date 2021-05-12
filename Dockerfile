FROM ubuntu:20.04

# Create and use omero user
RUN useradd -d /opt/omero -m -c "OMERO" -r omero

ENV DEBIAN_FRONTEND noninteractive
ENV TZ "America/New_York"
RUN apt update
RUN apt -y upgrade
RUN apt install -y make gcc build-essential software-properties-common libgtk-3-dev
RUN apt install -y python3.8-dev python3.8-venv python3-pip openjdk-11-jdk-headless default-libmysqlclient-dev libnotify-dev libsdl2-dev libwebkit2gtk-4.0-dev
RUn python3.8 -m pip install -U pip

# zeroc ice-py
RUN pip3.8 install https://github.com/ome/zeroc-ice-ubuntu2004/releases/download/0.2.0/zeroc_ice-3.6.5-cp38-cp38-linux_x86_64.whl

# install source for CellProfiler
ENV CP_VERSION 4.0.7
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
ADD https://github.com/CellProfiler/CellProfiler/archive/refs/tags/v$CP_VERSION.tar.gz /tmp/
WORKDIR /tmp/
RUN tar xvfz v$CP_VERSION.tar.gz
WORKDIR /tmp/CellProfiler-$CP_VERSION
RUN pip3.8 install numpy
RUN sed -i -e 's/numpy==1.19.3/numpy==1.20.3/' setup.py
# build cp
RUN pip3.8 install -U -e .


# install omero-py
#COPY omero_user_token-0.1.1-py2.py3-none-any.whl /tmp/
#RUN pip install -U /tmp/omero_user_token-0.1.1-py2.py3-none-any.whl

# install segmentation utils
#COPY segmentation_utils-0.1.1-py2.py3-none-any.whl /tmp/
#RUN pip install -U /tmp/segmentation_utils-0.1.1-py2.py3-none-any.whl

#WORKDIR /opt/omero
#User omero
#ADD ometiff-conversion-import.sh /usr/local/bin/
#ENTRYPOINT ["/usr/local/bin/ometiff-conversion-import.sh"]
