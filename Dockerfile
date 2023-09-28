FROM bestwu/deepin:15.5

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libncurses-dev \
    libreadline-dev \
    git \
    wget \
    curl \
    jq

RUN git clone --depth=1 https://github.com/viruscamp/luadec && \
    cd luadec && \
    git submodule update --init lua-5.1 && \
    ref=master && \
    patch_dir=patches.$ref && \
    mkdir -p $patch_dir && \
    cd $patch_dir && \
    rows=$(curl -sSL -H 'Accept: application/vnd.github.v3+json' 'https://api.github.com/repos/openwrt/openwrt/contents/package/utils/lua/patches?ref='"$ref" | jq -c -r '.[] | .download_url') && \
    while read -r row; do wget $row ; done <<< "$rows" && \
    cd ../lua-5.1 && \
    for i in ../${patch_dir}/*.patch; do patch -p1 <$i ; done && \
    sed -i 's/-O2/-O2 -fPIC/g' src/Makefile && \
    sed -i 's/USE_READLINE=1/USE_READLINE=1\nPKG_VERSION=5.1.5/g' src/Makefile && \
    make linux && \
    ln -s lua5.1 src/lua && \
    ln -s luac5.1 src/luac && \
    export LD_LIBRARY_PATH=`pwd`/src && \
    cd ../luadec && \
    make LUAVER=5.1 && \
    cp luadec /usr/local/bin/luadec && \
    ln -s /luadec/lua-5.1/src/luac /usr/local/bin/luac && \
    ln -s /luadec/lua-5.1/src/lua /usr/local/bin/lua

ENV LD_LIBRARY_PATH=/luadec/lua-5.1/src/

RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

WORKDIR /work

ENTRYPOINT [ "luadec" ]