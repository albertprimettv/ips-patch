FROM messense/rust-musl-cross:armv7-musleabihf-amd64

WORKDIR /src

COPY . .

ENV TARGET=armv7-unknown-linux-musleabihf

RUN rustup target add ${TARGET}

RUN ./build-de10-nano.sh

RUN test -f /src/target/${TARGET}/release/ips-patch

RUN armv7-unknown-linux-musleabihf-strip \
    --strip-all \
    /src/target/${TARGET}/release/ips-patch

RUN echo "========================================" && \
    echo " ELF FILE" && \
    echo "========================================" && \
    file /src/target/${TARGET}/release/ips-patch

RUN echo "========================================" && \
    echo " ELF INTERPRETER CHECK" && \
    echo "========================================" && \
    if armv7-unknown-linux-musleabihf-readelf \
        -l /src/target/${TARGET}/release/ips-patch | \
        grep -q 'Requesting program interpreter'; then \
        echo "ERROR: dynamic ELF interpreter found"; \
        exit 1; \
    else \
        echo "PASS: no ELF interpreter"; \
    fi

RUN echo "========================================" && \
    echo " DYNAMIC DEPENDENCY CHECK" && \
    echo "========================================" && \
    if armv7-unknown-linux-musleabihf-readelf \
        -d /src/target/${TARGET}/release/ips-patch | \
        grep -q 'NEEDED'; then \
        echo "ERROR: dynamic dependency found"; \
        armv7-unknown-linux-musleabihf-readelf \
            -d /src/target/${TARGET}/release/ips-patch; \
        exit 1; \
    else \
        echo "PASS: no dynamic dependencies"; \
    fi
