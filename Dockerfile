# Open-source hardware model checkers, pinned versions (linux/amd64).
ARG UBUNTU=ubuntu:24.04

# ---- rIC3, built from a pinned tag ----
FROM ${UBUNTU} AS ric3
ARG RIC3_TAG=v1.5.2
# rIC3 needs nightly; pinned near its release date.
ARG RUST_NIGHTLY=nightly-2025-12-07
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl build-essential git cmake zlib1g-dev pkg-config libssl-dev \
      libmpfr-dev libgmp-dev meson ninja-build clang && rm -rf /var/lib/apt/lists/*
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain ${RUST_NIGHTLY}
ENV PATH="/root/.cargo/bin:${PATH}"
RUN git clone --depth 1 --branch ${RIC3_TAG} --recurse-submodules --shallow-submodules \
      https://github.com/gipsyh/rIC3 /src/rIC3
WORKDIR /src/rIC3
RUN cargo build --release && cp target/release/rIC3 /usr/local/bin/rIC3

# ---- runtime image ----
FROM ${UBUNTU}
ARG OSS_CAD_DATE=20261118
ARG OSS_CAD_TAG=2026-11-18
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl python3 time libmpfr6 libgmp10 zstd xz-utils bzip2 git \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sSfL "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_TAG}/oss-cad-suite-linux-x64-${OSS_CAD_DATE}.tgz" \
      | tar -xz -C /opt
COPY --from=ric3 /usr/local/bin/rIC3 /usr/local/bin/rIC3
RUN ln -s /usr/local/bin/rIC3 /usr/local/bin/ric3
ENV PATH="/opt/oss-cad-suite/bin:${PATH}"
WORKDIR /work
