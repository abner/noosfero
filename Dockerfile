FROM debian:wheezy

WORKDIR /usr/share/noosfero

RUN apt-get update
RUN apt-get install -y sudo

ADD script/install-dependencies/debian-wheezy.sh /usr/share/noosfero/script/install-dependencies/
ADD script/quick-start /usr/share/noosfero/script/
ADD debian /usr/share/noosfero/debian
ADD Gemfile /usr/share/noosfero/
ADD vendor /usr/share/noosfero/vendor
ADD config/database.yml.pgsql /usr/share/noosfero/config/database.yml
RUN sh script/quick-start --skip-translations

ADD . /usr/share/noosfero

EXPOSE 3000
