FROM jenkins:2.32.3
MAINTAINER Harry Wang "harry_w@foxmail.com"
ENV REFRESHED_AT 2017-03-24
USER root

#install docker
#RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
	#echo "deb http://mirrors.aliyun.com/debian jessie main non-free contrib " >>/etc/apt/sources.list && \
	#echo "deb http://mirrors.aliyun.com/debian jessie-updates main non-free contrib " >>/etc/apt/sources.list && \
	#echo "deb http://mirrors.aliyun.com/debian jessie-backports main non-free contrib " >>/etc/apt/sources.list && \
	#apt-get update

RUN  apt-get update && \
     apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl 
     #software-properties-common 如果不用add-apt-repository,可不安装?

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -  && \
	apt-key fingerprint 0EBFCD88

RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian jessie stable" >>/etc/apt/sources.list && \
	apt-get update

RUN apt-get install -y docker-ce

# Install .NET CLI dependencies
RUN apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 1.0.1
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

ENV DOCKER_MIRROR_URL http://hub-mirror.c.163.com

#以下可以写个sh文件,然后copy进来的,因为我的是windows系统,会有问题,就直接用echo了
RUN echo "#! /bin/bash" >> /usr/local/bin/h-jenkins.sh && \
	echo "mkdir -p /etc/docker" >> /usr/local/bin/h-jenkins.sh && \
	echo "echo \"{\" >> /etc/docker/daemon.json" >> /usr/local/bin/h-jenkins.sh && \
	echo "echo \"\\\"registry-mirrors\\\": [\\\"\$DOCKER_MIRROR_URL\\\"]\" >> /etc/docker/daemon.json" >> /usr/local/bin/h-jenkins.sh && \
	echo "echo \"}\" >> /etc/docker/daemon.json" >> /usr/local/bin/h-jenkins.sh && \
	echo "cat /etc/docker/daemon.json" >> /usr/local/bin/h-jenkins.sh && \
	echo "service docker start" >> /usr/local/bin/h-jenkins.sh  && \

	echo "/usr/local/bin/jenkins.sh" >> /usr/local/bin/h-jenkins.sh 
	#echo "" >>  /usr/local/bin/h-jenkins.sh

#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/bin/bash","/usr/local/bin/h-jenkins.sh"] 


