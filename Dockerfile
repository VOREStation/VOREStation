FROM i386/ubuntu:xenial as base

ARG BYOND_MAJOR=514
ARG BYOND_MINOR=1589

RUN apt-get update \
    && apt-get install -y \
    curl \
    unzip \
    make \
    libstdc++6 \
    && curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip \
    && unzip byond.zip \
    && cd byond \
    && sed -i 's|install:|&\n\tmkdir -p $(MAN_DIR)/man6|' Makefile \
    && make install \
    && chmod 644 /usr/local/byond/man/man6/* \
    && apt-get purge -y --auto-remove curl unzip make \
    && cd .. \
    && rm -rf byond byond.zip /var/lib/apt/lists/*

FROM base as rust_g

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    ca-certificates

WORKDIR /rust_g

RUN apt-get install -y --no-install-recommends \
    libssl-dev \
    pkg-config \
    curl \
    gcc-multilib \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-host i686-unknown-linux-gnu \
    && git init \
    && git remote add origin https://github.com/VOREStation/rust-g

COPY _build_dependencies.sh .

RUN /bin/bash -c "source _build_dependencies.sh \
    && git fetch --depth 1 origin \$RUST_G_VERSION" \
    && git checkout FETCH_HEAD \
    && ~/.cargo/bin/cargo build --release

FROM base as dm_base

WORKDIR /vorestation

FROM dm_base as build

COPY . .

RUN DreamMaker -max_errors 0 vorestation.dme

FROM dm_base

EXPOSE 2303

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    libmariadb2 \
    mariadb-client \
    libssl1.0.0 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.byond/bin

COPY --from=build /vorestation/ ./
COPY --from=rust_g /rust_g/target/release/librust_g.so ./librust_g.so

#VOLUME [ "/vorestation/config", "/vorestation/data" ]

ENTRYPOINT [ "DreamDaemon", "vorestation.dmb", "-port", "2303", "-trusted", "-close", "-verbose" ]
