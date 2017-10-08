FROM debian:9.1
ENV DEBIAN_FRONTEND noninteractive

ENV ASTERISK_VERSION 15.0.0

RUN \

	#upgrade

	apt-get update &&\
	apt-get dist-upgrade -y &&\

	# common

	apt-get install -y \
		build-essential \
		wget \
	&&\

	# asterisk

	apt -y install \
		libncursesw5-dev \
		uuid-dev \
		libjansson4 libjansson-dev \
		libxml2 libxml2-dev \
		libsqlite3-dev \
		libssl-dev \
#		zlib1g-dev \
	&&\
	cd /usr/src &&\
	wget -O - http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-$ASTERISK_VERSION.tar.gz | tar zxf - &&\
	cd asterisk-$ASTERISK_VERSION &&\

	# ast_mongo

#	apt-get install -y \
#		libbson-dev \
#		libmongoc-dev \
#		autoconf \
#		automake \
#		pkg-config \
#	&&\
#	wget -O - https://github.com/minoruta/ast_mongo/raw/master/patches/ast_mongo-15.0.0.patch | sed 's~/local/~/~' | patch -p1 &&\
#	./bootstrap.sh &&\
#	apt-get purge --auto-remove -y \
#		autoconf \
#		automake \
#		pkg-config \
#	&&\

	# configure

	./configure &&\
	make menuselect.makeopts &&\
	menuselect/menuselect menuselect.makeopts \
		--disable BUILD_NATIVE \
		--disable CORE-SOUNDS-EN-GSM \
		--enable CORE-SOUNDS-RU-ULAW \
	&&\

	# mp3

#	apt-get install -y subversion &&\
#	contrib/scripts/get_mp3_source.sh &&\
#	menuselect/menuselect menuselect.makeopts --enable format_mp3 &&\
#	apt-get purge --auto-remove -y subversion &&\

	# make & install

	make &&\
	make install &&\

	# cleanup

	rm -rf /usr/src/asterisk-$ASTERISK_VERSION &&\
	rm /tmp/* &&\
	apt-get purge --auto-remove -y \
		build-essential \
		wget \
		libncurses5-dev \
		uuid-dev \
		libjansson-dev \
		libxml2-dev \
		libsqlite3-dev \
		libssl-dev \
	&&\
	apt-get clean &&\
	rm -rf /var/lib/apt/lists/*