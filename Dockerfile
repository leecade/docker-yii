FROM      centos:6.6
MAINTAINER leecade <yuji@lianjia.com>

LABEL Description="This image is used to provide a online-like devlopment environment" Version="0.1.0"

# ENV
ENV DEFAULT_PASSWROD 123

# Import the RPM GPG keys for Repositories & Install missing pkg
RUN yum install -y epel-release && yum install -y \
        curl \
        tar \
        git \
        nginx \
        openssh-server \
        openssh-clients \
        vim \
        mysql \
        php-fpm \
        php-curl \
        php-cli \
        php-gd \
        php-intl \
        php-mcrypt \
        php-mysql \
        php-xsl \
  && rm -rf /var/cache/yum/* \
  && yum clean all

RUN echo root:$DEFAULT_PASSWROD | chpasswd

# Set up SSH environment.
RUN ssh-keygen -q -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key

# Set up SSHD config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
# RUN sed -ri 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
# RUN sed -ri 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
# RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN mkdir -p /root/.ssh && chown root:root /root && chmod 700 /root/.ssh

# Initialize application
WORKDIR /app

# RUN git clone https://github.com/yiisoft/yii.git

RUN curl -L https://github.com/yiisoft/yii/archive/1.1.13.tar.gz | tar -xz && \
    mv yii-1.1.13 yii

ADD webapp /app/yii/webapp

# shortcut
ADD views /views
ADD views /views.example
RUN ln -sf /views /app/yii/webapp/protected/views

# RUN curl -L https://github.com/smarty-php/smarty/archive/v3.1.19.tar.gz | tar xz

# Add Smarty
# RUN mkdir -p yii/protected/vendor/Smarty && cp -r smarty-3.1.19/libs/* yii/protected/vendor/Smarty && rm -rf smarty-3.1.19 && mkdir -p yii/protected/extensions && mkdir -p yii/protected/config
# ADD extensions/CSmarty.php /app/yii/protected/extensions/CSmarty.php
# ADD config/main.php /app/yii/protected/config/main.php

# Configure nginx
ADD nginx/default.conf /etc/nginx/conf.d/default.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    echo "date.timezone = 'PRC'" >> /etc/php.ini && \
    echo "cgi.fix_pathinfo = 0;" >> /etc/php.ini && \
    sed -i.bak 's/user *nginx;/user root;/' /etc/nginx/nginx.conf && \
    sed -i.bak 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/php.ini && \
    sed -i.bak '/;catch_workers_output = yes/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf && \
    sed -i.bak 's/log_errors_max_len = 1024/log_errors_max_len = 65536/' /etc/php.ini && \

    # Fixing Yii failed to open stream: No such file or directory
    sed -i.bak '/\/\/ use include so that the error PHP file may appear/c if(preg_match("\/smarty\/i", $className)){ return; }' /app/yii/framework/YiiBase.php

# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stderr /var/log/php-fpm/www-error.log

# /!\ DEVELOPMENT ONLY SETTINGS /!\
# Running PHP-FPM as root, required for volumes mounted from host
RUN sed -i.bak 's/user = apache/user = root/' /etc/php-fpm.d/www.conf && \
    sed -i.bak 's/group = apache/group = root/' /etc/php-fpm.d/www.conf && \
    sed -i.bak 's/--daemonize/--daemonize -R/' /etc/init.d/php-fpm
# /!\ DEVELOPMENT ONLY SETTINGS /!\

ADD run.sh /root/run.sh
RUN chmod 700 /root/run.sh

CMD [ "/root/run.sh" ]

VOLUME [ "/views" ]
EXPOSE 22 80 8080 443
