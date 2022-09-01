FROM arm32v7/ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        git \
        unzip \
        tar \
        curl \
        ca-certificates \
        cmake \
        build-essential \
        gcc-9 \
        g++-9 \
        gosu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG VVCORE_REPO_URL=https://github.com/VOICEVOX/voicevox_core.git
ARG VVCORE_REPO_VERSION=0.12.1
RUN git clone "${VVCORE_REPO_URL}" /opt/voicevox_core && \
    cd /opt/voicevox_core && \
    git checkout "${VVCORE_REPO_VERSION}"

#ARG VVCORE_RELEASE_URL=https://github.com/VOICEVOX/voicevox_core/releases/download/0.12.1/voicevox_core-linux-armhf-cpu-0.12.1.zip
ARG VVCORE_RELEASE_URL=https://github.com/aoirint/voicevox_core/releases/download/0.13.0-aoirint-1/voicevox_core-linux-armhf-cpu-0.13.0-aoirint-1.zip
RUN mkdir -p /opt/core_tmp && \
    cd /opt/core_tmp && \
    curl -L -o core.zip "${VVCORE_RELEASE_URL}" && \
    unzip core.zip && \
    cd voicevox_core-* && \
    cp libcore.so core.h /opt/voicevox_core/example/cpp/unix && \
    rm -rf /opt/core_tmp

ARG ORT_RELEASE_URL=https://github.com/VOICEVOX/onnxruntime-builder/releases/download/1.10.0.1/onnxruntime-linux-armhf-cpu-v1.10.0.tgz
RUN mkdir -p /opt/ort_tmp && \
    cd /opt/ort_tmp && \
    curl -L -o ort.tgz "${ORT_RELEASE_URL}" && \
    tar xf ort.tgz && \
    cd onnxruntime-* && \
    cp lib/libonnxruntime.so.* /opt/voicevox_core/example/cpp/unix && \
    rm -rf /opt/ort_tmp

ARG OJTDICT_RELEASE_URL=https://downloads.sourceforge.net/open-jtalk/open_jtalk_dic_utf_8-1.11.tar.gz
RUN mkdir -p /opt/ojtdict_tmp && \
    cd /opt/ojtdict_tmp && \
    curl -L -o ojtdict.tgz "${OJTDICT_RELEASE_URL}" && \
    tar xf ojtdict.tgz && \
    mv open_jtalk_dic_* /opt/voicevox_core/example/cpp/unix && \
    rm -rf /opt/ojtdict_tmp 

#ARG CMAKE_RELEASE_URL=https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1.tar.gz
#RUN mkdir -p /opt/cmake_tmp && \
#    curl -L -o cmake.tgz "${CMAKE_RELEASE_URL}" && \
#    tar xf cmake.tgz && \
#    cd cmake-* && \
#    ./bootstrap && \
#    make && \
#    make install && \
#    rm -rf /opt/cmake_tmp

# https://gitlab.kitware.com/cmake/cmake/-/issues/20568
RUN cd /opt/voicevox_core/example/cpp/unix && \
    cmake -S . -B build || true && \
    cmake -S . -B build && \
    cmake --build build && \
    cp build/simple_tts ./

RUN useradd -ou 1000 -m user

RUN mkdir -p /work && \
    chown -R 1000:1000 /work

ADD ./entrypoint.sh /

WORKDIR /work
ENTRYPOINT [ "/entrypoint.sh" ]

