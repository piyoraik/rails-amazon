FROM amazonlinux:with-sources

RUN yum -y update

# Rubyのアンイストール、必要パッケージインストール
RUN yum remove -y ruby* && \
yum -y remove git && \
yum -y install patch \
libyaml-devel \
zlib \
zlib-devel \
libffi-devel \
bzip2 \
make \
tar \
autoconf \
automake \
libcurl-devel \
sqlite-devel \
mysql-devel \
gcc-c++ \
git \
openssl-devel \
readline-devel \
curl-devel \
expat-devel \
gettext-devel \
openssl-devel \
zlib-devel \
perl-ExtUtils-MakeMaker \
wget \
libpng-devel \
libjpeg-devel \
libtiff-devel \
gcc

# Gitの更新
WORKDIR /usr/local/src
RUN wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.26.2.tar.gz && \
tar zxvf git-2.26.2.tar.gz && \
cd git-2.26.2 && \
./configure --prefix=/usr/local && \
make prefix=/usr/local all && \
make prefix=/usr/local install

# ImageMagickのインストール
RUN wget http://www.imagemagick.org/download/ImageMagick.tar.gz && \
tar -vxf ImageMagick.tar.gz && \
cd ImageMagick-7.0.10-13 && \
./configure && \
make && \
make install

# Nodeのインストール
RUN curl --silent --location https://rpm.nodesource.com/setup_12.x | bash - && \
yum install -y nodejs

# rbenvのダウンロード、設定
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
ENV PATH /root/.rbenv/shims:/root/.rbenv/bin:$PATH

# rbenv,Rubyのインストール
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
rbenv install 2.5.7 && \
rbenv global 2.5.7 && \
rbenv rehash && \
rbenv exec gem install bundler

# Railsのインストール
RUN gem install rails -v 5.2.3

RUN mkdir /app

WORKDIR /app