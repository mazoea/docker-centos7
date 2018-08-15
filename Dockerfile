FROM centos:7

MAINTAINER jm

WORKDIR /opt

RUN yum update -q -y && \
    yum install -y epel-release && \
    yum install -y centos-release-scl-rh && \
    yum install -y sudo git curl unzip iotop htop wget tar openssh-clients file && \
    yum install -y gcc-c++ make autoconf automake mlocate links libtool dos2unix && \
    yum install -y cloc xpdf autoconf && \
    yum install -y bzip2-devel openssl-devel freetype-devel sqlite-devel readline-devel && \
    yum install -y python-openssl  || true && \
    yum install -y 'libffi-devel*' || true && \
    yum install -y devtoolset-7-gcc devtoolset-7-gcc-c++

ENV CC=/opt/rh/devtoolset-7/root/usr/bin/gcc  
ENV CPP=/opt/rh/devtoolset-7/root/usr/bin/cpp
ENV CXX=/opt/rh/devtoolset-7/root/usr/bin/g++

RUN echo "source scl_source enable devtoolset-7" >> /etc/bashrc
RUN /usr/bin/scl enable devtoolset-7 true

RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum install -y nodejs

RUN VER=3.12.0 PACKAGE=cmake ; git clone https://gitlab.kitware.com/cmake/$PACKAGE.git && \
    cd $PACKAGE && git checkout v$VER && \
    ./bootstrap --prefix=/usr && \
    make  && \
    ./bin/cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_USE_OPENSSL:BOOL=ON . && \
    make install

RUN VER=2.7.8 PACKAGE=Python-$VER URL=http://www.python.org/ftp/python/$VER/$PACKAGE.tgz ; cd /opt && wget -q --no-check-certificate $URL && \
    tar xzvf $PACKAGE.tgz && \
    cd $PACKAGE && \
    ./configure --prefix=/usr/ && \
    make && \
    sudo make altinstall ; \
\
    echo '=================================================' && \
    echo `$CC -v` && \
    echo `$CPP -v` && \
    echo `$CXX -v` && \
    echo `python -V` && \
    echo `python2.7 -V` && \
    echo `node -v` && \
    echo `npm -v` && \
    echo `cmake --version`
