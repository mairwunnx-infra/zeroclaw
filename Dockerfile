FROM rust:1.83-slim-bookworm AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \\
    build-essential \\
    pkg-config \\
    libssl-dev \\
    git \\
  && rm -rf /var/lib/apt/lists/*
WORKDIR /build
# Копируем submodule с исходниками
COPY zeroclaw/Cargo.toml zeroclaw/Cargo.lock ./
RUN mkdir -p src && echo 'fn main(){}' > src/main.rs && \\
    cargo build --release --locked && \\
    rm -rf src
COPY zeroclaw/ .
RUN touch src/main.rs && \\
    cargo build --release --locked

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends \\
    ca-certificates \\
    libssl3 \\
    sqlite3 \\
  && rm -rf /var/lib/apt/lists/*
RUN useradd -m -u 1001 -s /bin/sh zeroclaw && \\
    mkdir -p /home/zeroclaw/.zeroclaw/workspace && \\
    chown -R zeroclaw:zeroclaw /home/zeroclaw/.zeroclaw
COPY --from=builder /build/target/release/zeroclaw /usr/local/bin/zeroclaw

COPY --chown=zeroclaw:zeroclaw config.toml  /home/zeroclaw/.zeroclaw/config.toml
COPY --chown=zeroclaw:zeroclaw IDENTITY.md  /home/zeroclaw/.zeroclaw/workspace/IDENTITY.md
COPY --chown=zeroclaw:zeroclaw SOUL.md      /home/zeroclaw/.zeroclaw/workspace/SOUL.md
USER zeroclaw
WORKDIR /home/zeroclaw
VOLUME ["/home/zeroclaw/.zeroclaw"]
EXPOSE 3000
ENTRYPOINT ["zeroclaw"]
CMD ["daemon"]