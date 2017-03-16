FROM jenkins

USER root

#install docker
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
	echo "deb http://mirrors.aliyun.com/debian jessie main non-free contrib " >>/etc/apt/sources.list && \
	echo "deb http://mirrors.aliyun.com/debian jessie-updates main non-free contrib " >>/etc/apt/sources.list && \
	echo "deb http://mirrors.aliyun.com/debian jessie-backports main non-free contrib " >>/etc/apt/sources.list && \

    #echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
	#echo "deb http://ftp2.cn.debian.org/debian jessie main non-free contrib" >>/etc/apt/sources.list && \
    #echo "deb http://ftp.cn.debian.org/debian jessie main non-free contrib" >>/etc/apt/sources.list && \
	apt-get update

RUN apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl 
     #software-properties-common 如果不用add-apt-repository,可不安装?

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -  && \
	apt-key fingerprint 0EBFCD88

RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian jessie stable" >>/etc/apt/sources.list && \
	apt-get update

RUN	apt-get install -y docker-ce


#USER ${user}

ENTRYPOINT ["/bin/bash"]
