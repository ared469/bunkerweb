#!/bin/bash

function do_and_check_cmd() {
	if [ "$CHANGE_DIR" != "" ] ; then
		cd "$CHANGE_DIR"
	fi
	output=$("$@" 2>&1)
	ret="$?"
	if [ $ret -ne 0 ] ; then
		echo "❌ Error from command : $*"
		echo "$output"
		exit $ret
	fi
	#echo $output
	return 0
}

NTASK=$(nproc)

# Compile and install lua
echo "ℹ️ Compile and install lua-5.1.5"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-5.1.5" do_and_check_cmd make -j $NTASK linux
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-5.1.5" do_and_check_cmd make INSTALL_TOP=/usr/share/bunkerweb/deps install

# Compile and install libmaxminddb
echo "ℹ️ Compile and install libmaxminddb"
# TODO : temp fix run it twice...
cd /tmp/bunkerweb/deps/src/libmaxminddb && ./bootstrap > /dev/null 2>&1
CHANGE_DIR="/tmp/bunkerweb/deps/src/libmaxminddb" do_and_check_cmd ./bootstrap
CHANGE_DIR="/tmp/bunkerweb/deps/src/libmaxminddb" do_and_check_cmd ./configure --prefix=/usr/share/bunkerweb/deps --disable-tests
CHANGE_DIR="/tmp/bunkerweb/deps/src/libmaxminddb" do_and_check_cmd make -j $NTASK
CHANGE_DIR="/tmp/bunkerweb/deps/src/libmaxminddb" do_and_check_cmd make install

# Compile and install ModSecurity
echo "ℹ️ Compile and install ModSecurity"
# temp fix : Debian run it twice
# TODO : patch it in clone.sh
cd /tmp/bunkerweb/deps/src/ModSecurity && ./build.sh > /dev/null 2>&1
CHANGE_DIR="/tmp/bunkerweb/deps/src/ModSecurity" do_and_check_cmd sh build.sh
CHANGE_DIR="/tmp/bunkerweb/deps/src/ModSecurity" do_and_check_cmd ./configure --disable-dependency-tracking --disable-static --disable-examples --disable-doxygen-doc --disable-doxygen-html --disable-valgrind-memcheck --disable-valgrind-helgrind --prefix=/usr/share/bunkerweb/deps --with-maxmind=/usr/share/bunkerweb/deps
CHANGE_DIR="/tmp/bunkerweb/deps/src/ModSecurity" do_and_check_cmd make -j $NTASK
CHANGE_DIR="/tmp/bunkerweb/deps/src/ModSecurity" do_and_check_cmd make install-strip

# Compile and install luajit2
echo "ℹ️ Compile and install luajit2"
CHANGE_DIR="/tmp/bunkerweb/deps/src/luajit2" do_and_check_cmd make -j $NTASK
CHANGE_DIR="/tmp/bunkerweb/deps/src/luajit2" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps install

# Install lua-resty-core
echo "ℹ️ Install openresty/lua-resty-core"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-core" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps install

# Install lua-resty-lrucache
echo "ℹ️ Install lua-resty-lrucache"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-lrucache" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps install

# Install lua-resty-dns
echo "ℹ️ Install lua-resty-dns"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-dns" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps install

# Install lua-resty-session
echo "ℹ️ Install lua-resty-session"
do_and_check_cmd cp -r /tmp/bunkerweb/deps/src/lua-resty-session/lib/resty/* /usr/share/bunkerweb/deps/lib/lua/resty

# Install lua-resty-random
echo "ℹ️ Install lua-resty-random"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-random" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps install

# Install lua-resty-string
echo "ℹ️ Install lua-resty-string"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-string" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps install

# Compile and install lua-cjson
echo "ℹ️ Compile and install lua-cjson"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-cjson" do_and_check_cmd make LUA_INCLUDE_DIR=/usr/share/bunkerweb/deps/include -j $NTASK
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-cjson" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps LUA_CMODULE_DIR=/usr/share/bunkerweb/deps/lib/lua LUA_MODULE_DIR=/usr/share/bunkerweb/deps/lib/lua install
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-cjson" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps LUA_CMODULE_DIR=/usr/share/bunkerweb/deps/lib/lua LUA_MODULE_DIR=/usr/share/bunkerweb/deps/lib/lua install-extra

# Compile and install lua-gd
echo "ℹ️ Compile and install lua-gd"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-gd" do_and_check_cmd make "CFLAGS=-O3 -Wall -fPIC -fomit-frame-pointer -I/usr/share/bunkerweb/deps/include -DVERSION=\\\"2.0.33r3\\\"" "LFLAGS=-shared -L/usr/share/bunkerweb/deps/lib -llua -lgd -Wl,-rpath=/usr/share/bunkerweb/deps/lib" LUABIN=/usr/share/bunkerweb/deps/bin/lua -j $NTASK
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-gd" do_and_check_cmd make INSTALL_PATH=/usr/share/bunkerweb/deps/lib/lua install

# Download and install lua-resty-http
echo "ℹ️ Install lua-resty-http"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-http" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps install

# Download and install lualogging
echo "ℹ️ Install lualogging"
do_and_check_cmd cp -r /tmp/bunkerweb/deps/src/lualogging/src/* /usr/share/bunkerweb/deps/lib/lua

# Compile and install luasocket
echo "ℹ️ Compile and install luasocket"
CHANGE_DIR="/tmp/bunkerweb/deps/src/luasocket" do_and_check_cmd make LUAINC_linux=/usr/share/bunkerweb/deps/include -j $NTASK
CHANGE_DIR="/tmp/bunkerweb/deps/src/luasocket" do_and_check_cmd make prefix=/usr/share/bunkerweb/deps CDIR_linux=lib/lua LDIR_linux=lib/lua install

# Compile and install luasec
echo "ℹ️ Compile and install luasec"
CHANGE_DIR="/tmp/bunkerweb/deps/src/luasec" do_and_check_cmd make INC_PATH=-I/usr/share/bunkerweb/deps/include linux -j $NTASK
CHANGE_DIR="/tmp/bunkerweb/deps/src/luasec" do_and_check_cmd make LUACPATH=/usr/share/bunkerweb/deps/lib/lua LUAPATH=/usr/share/bunkerweb/deps/lib/lua install

# Install lua-resty-ipmatcher
echo "ℹ️ Install lua-resty-ipmatcher"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-ipmatcher" do_and_check_cmd make INST_PREFIX=/usr/share/bunkerweb/deps INST_LIBDIR=/usr/share/bunkerweb/deps/lib/lua INST_LUADIR=/usr/share/bunkerweb/deps/lib/lua install

# Install lua-resty-redis
echo "ℹ️ Install lua-resty-redis"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-redis" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps LUA_LIB_DIR=/usr/share/bunkerweb/deps/lib/lua install

# Install lua-resty-upload
echo "ℹ️ Install lua-resty-upload"
CHANGE_DIR="/tmp/bunkerweb/deps/src/lua-resty-upload" do_and_check_cmd make PREFIX=/usr/share/bunkerweb/deps LUA_LIB_DIR=/usr/share/bunkerweb/deps/lib/lua install

# Install lujit-geoip
echo "ℹ️ Install luajit-geoip"
do_and_check_cmd cp -r /tmp/bunkerweb/deps/src/luajit-geoip/geoip /usr/share/bunkerweb/deps/lib/lua

# Install lbase64
echo "ℹ️ Install lbase64"
do_and_check_cmd cp -r /tmp/bunkerweb/deps/src/lbase64/base64.lua /usr/share/bunkerweb/deps/lib/lua

# Compile dynamic modules
echo "ℹ️ Compile and install dynamic modules"
CONFARGS="$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p')"
CONFARGS="${CONFARGS/-Os -fomit-frame-pointer -g/-Os}"
if [ "$OS" = "fedora" ] ; then
	CONFARGS="$(echo -n "$CONFARGS" | sed "s/--with-ld-opt='.*'//" | sed "s/--with-cc-opt='.*'//")"
fi
echo '#!/bin/bash' > "/tmp/bunkerweb/deps/src/nginx-${NGINX_VERSION}/configure-fix.sh"
echo "./configure $CONFARGS --add-dynamic-module=/tmp/bunkerweb/deps/src/ModSecurity-nginx --add-dynamic-module=/tmp/bunkerweb/deps/src/headers-more-nginx-module --add-dynamic-module=/tmp/bunkerweb/deps/src/nginx_cookie_flag_module --add-dynamic-module=/tmp/bunkerweb/deps/src/lua-nginx-module --add-dynamic-module=/tmp/bunkerweb/deps/src/ngx_brotli" >> "/tmp/bunkerweb/deps/src/nginx-${NGINX_VERSION}/configure-fix.sh"
do_and_check_cmd chmod +x "/tmp/bunkerweb/deps/src/nginx-${NGINX_VERSION}/configure-fix.sh"
CHANGE_DIR="/tmp/bunkerweb/deps/src/nginx-${NGINX_VERSION}" LUAJIT_LIB="/usr/share/bunkerweb/deps/lib -Wl,-rpath,/usr/share/bunkerweb/deps/lib" LUAJIT_INC="/usr/share/bunkerweb/deps/include/luajit-2.1" MODSECURITY_LIB="/usr/share/bunkerweb/deps/lib" MODSECURITY_INC="/usr/share/bunkerweb/deps/include" do_and_check_cmd ./configure-fix.sh
CHANGE_DIR="/tmp/bunkerweb/deps/src/nginx-${NGINX_VERSION}" do_and_check_cmd make -j $NTASK modules
do_and_check_cmd mkdir /usr/share/bunkerweb/modules
CHANGE_DIR="/tmp/bunkerweb/deps/src/nginx-${NGINX_VERSION}" do_and_check_cmd cp ./objs/*.so /usr/share/bunkerweb/modules

# Dependencies are installed
echo "ℹ️ Dependencies for BunkerWeb successfully compiled and installed !"