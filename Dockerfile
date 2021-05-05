FROM tgstation/byond:513.1533 as base

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
    && git remote add origin https://github.com/tgstation/rust-g

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

COPY --from=rust_g /rust_g/target/release/librust_g.so /root/.byond/bin/rust_g
COPY --from=build /vorestation/ ./

#VOLUME [ "/vorestation/config", "/vorestation/data" ]

ENTRYPOINT [ "DreamDaemon", "vorestation.dmb", "-port", "2303", "-trusted", "-close", "-verbose" ]
