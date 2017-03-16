FROM jenkins

USER root

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
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
        zlib1g 

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
    && cd ~

#°²×°Docker
# Jessie or Stretch:
RUN apt-get update \
  && apt-get -y install \
  apt-transport-https \
  ca-certificates \
  software-properties-common

RUN  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN  add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/debian \
         $(lsb_release -cs) \
         stable"


RUN apt-get -y install docker-ce

#Çå³ýapt»º´æ
RUN rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/NuGetScratch

RUN systemctl start docker

#USER ${user}

ENTRYPOINT ["/bin/bash"]
