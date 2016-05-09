FROM      centos:6.6
MAINTAINER leecade <yuji@lianjia.com>

LABEL Description="This image is used to provide a online-like devlopment environment" Version="0.1.0"

# Import the RPM GPG keys for Repositories & Install missing pkg
RUN yum install -y epel-release && yum install -y \
        curl \
        git \
        nginx \
        openssh-server \
        openssh-clients \
        vim \
        mysql-client \
        php5-fpm \
        php5-curl \
        php5-cli \
        php5-gd \
        php5-intl \
        php5-mcrypt \
        php5-mysql \
        php5-xsl \
  && rm -rf /var/cache/yum/* \
  && yum clean all

# Initialize application
WORKDIR /app

RUN git clone https://github.com/yiisoft/yii.git

# Configure nginx
ADD default /etc/nginx/sites-available/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    echo "date.timezone = 'PRC'" >> /etc/php5/fpm/php.ini && \
    echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini && \
    sed -i.bak 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/php5/fpm/php.ini && \
    sed -i.bak '/;catch_workers_output = yes/ccatch_workers_output = yes' /etc/php5/fpm/pool.d/www.conf && \
    sed -i.bak 's/log_errors_max_len = 1024/log_errors_max_len = 65536/' /etc/php5/fpm/php.ini

# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# /!\ DEVELOPMENT ONLY SETTINGS /!\
# Running PHP-FPM as root, required for volumes mounted from host
RUN sed -i.bak 's/user = www-data/user = root/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i.bak 's/group = www-data/group = root/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i.bak 's/--fpm-config /-R --fpm-config /' /etc/init.d/php5-fpm
# /!\ DEVELOPMENT ONLY SETTINGS /!\

ADD run.sh /root/run.sh
RUN chmod 700 /root/run.sh

CMD ["/root/run.sh"]
EXPOSE 80
