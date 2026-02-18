FROM rust:1.93-slim-bookworm AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    git \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /build
COPY zeroclaw/ .
RUN cargo build --release --locked
FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    sqlite3 \
  && rm -rf /var/lib/apt/lists/*
RUN useradd -m -u 1001 -s /bin/sh zeroclaw && \
    mkdir -p /home/zeroclaw/.zeroclaw/workspace && \
    chown -R zeroclaw:zeroclaw /home/zeroclaw/.zeroclaw
COPY --from=builder /build/target/release/zeroclaw /usr/local/bin/zeroclaw
COPY --chown=zeroclaw:zeroclaw configuration/config.toml  /home/zeroclaw/.zeroclaw/config.toml
COPY --chown=zeroclaw:zeroclaw configuration/IDENTITY.md  /home/zeroclaw/.zeroclaw/workspace/IDENTITY.md
COPY --chown=zeroclaw:zeroclaw configuration/SOUL.md      /home/zeroclaw/.zeroclaw/workspace/SOUL.md
USER zeroclaw
WORKDIR /home/zeroclaw
VOLUME ["/home/zeroclaw/.zeroclaw"]
EXPOSE 3000
ENTRYPOINT ["zeroclaw"]
CMD ["daemon"]