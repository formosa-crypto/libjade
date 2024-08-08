# if you are (your terminal) in the same directory of this file, then:
#   $ docker build -t libjade:latest -f Dockerfile ../../
#
# otherwise, if it is run at the root directory of this project:
#   $ docker build -t libjade:latest -f scripts/docker/Dockerfile .

FROM debian:stable-slim
MAINTAINER Tiago Oliveira <tiago.oliveira@sandboxquantum.com>

ARG USER=formosa
ARG JASMIN_COMMIT=8524bf05785c601fd1eb3832811cb16465d3b1ef
ARG EASYCRYPT_COMMIT=2b3bbadffa084466fd3450f367b2102e032c1301

ARG ALTERGO_VERSION=2.5.4
# note: CVC4_VERSION is not set. Below, you can find and replace the url.
ARG Z3_VERSION=4.12.4

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get --quiet --assume-yes update && \
    apt-get --quiet --assume-yes upgrade && \
    apt-get --quiet --assume-yes install apt-utils && \
    apt-get --quiet --assume-yes install \
      sudo wget curl git time xz-utils libicu-dev \
      ocaml ocaml-native-compilers camlp4-extra opam \
      autoconf debianutils libgmp-dev pkg-config zlib1g-dev \
      vim build-essential python3 python3-pip m4 libgsl-dev \ 
      libpcre3-dev jq parallel valgrind bash-completion \
      libtext-diff-perl qemu-user-static binutils-arm-linux-gnueabi* \
      gcc-arm-linux-gnueabi

RUN apt-get --quiet --assume-yes clean

RUN echo "%sudo  ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers && \
    chown root:root /etc/sudoers.d/sudoers && \
    chmod 0400 /etc/sudoers.d/sudoers && \
    useradd --create-home --shell /bin/bash --home-dir /home/$USER --user-group --groups sudo --uid 1001 $USER

USER $USER
WORKDIR /home/$USER

RUN curl -L https://nixos.org/nix/install > nix-install && \
    sh nix-install

# jasmin ######################################################################

RUN git clone https://gitlab.com/jasmin-lang/jasmin-compiler.git jasmin_$JASMIN_COMMIT
RUN cd jasmin_$JASMIN_COMMIT/ && \
    git fetch --append && \
    git checkout $JASMIN_COMMIT && \
    cd compiler/ && \
    USER=$USER source /home/$USER/.nix-profile/etc/profile.d/nix.sh && \
    nix-channel --update && \
    nix-shell --command "make" && \
    sudo install -D jasminc /usr/local/bin/ && \
    sudo install -D jasmin-ct /usr/local/bin/

# easycrypt ###################################################################

# alt-ergo (via opam)
RUN export OPAMYES=true OPAMVERBOSE=0 OPAMJOBS=$(nproc) && \
    opam init --disable-sandboxing && \
    opam install opam-depext && \
    opam pin add -n alt-ergo $ALTERGO_VERSION && \
    opam install alt-ergo && \
    opam clean

# cvc4 (for a different version replace the following url)
RUN wget --no-verbose --show-progress --progress=bar:force:noscroll --timeout=10 --waitretry=5 --tries=5 \
      -O cvc4 https://github.com/CVC4/CVC4-archived/releases/download/1.8/cvc4-1.8-x86_64-linux-opt && \ 
    sudo install -D cvc4 /usr/local/bin/
    
# z3
RUN wget --no-verbose --show-progress --progress=bar:force:noscroll --timeout=10 --waitretry=5 --tries=5 \
      https://github.com/Z3Prover/z3/releases/download/z3-$Z3_VERSION/z3-$Z3_VERSION-x64-glibc-2.31.zip && \
    unzip -j z3-$Z3_VERSION-x64-glibc-2.31.zip z3-$Z3_VERSION-x64-glibc-2.31/bin/z3 && \
    sudo install -D z3 /usr/local/bin/

# easycrypt
RUN git clone https://github.com/EasyCrypt/easycrypt.git easycrypt_$EASYCRYPT_COMMIT
RUN eval $(opam env) && \
    cd easycrypt_$EASYCRYPT_COMMIT/ && \
    git checkout $EASYCRYPT_COMMIT && \
    USER=$USER source /home/$USER/.nix-profile/etc/profile.d/nix.sh && \
    export NIXPKGS_ALLOW_UNFREE=1 && \
    nix-channel --update && \
    nix-shell --command "make" && \
    nix-shell --command "./ec.native why3config -why3 why3config.conf"

RUN cd easycrypt_$EASYCRYPT_COMMIT/ && \
    echo -e "#!/bin/bash\n$(pwd)/ec.native -I Jasmin:/home/$USER/jasmin_$JASMIN_COMMIT/eclib/ "\$@" -why3 $(pwd)/why3config.conf" > easycrypt && \
    sudo install -D easycrypt /usr/local/bin/

# formosa-25519 ###############################################################

COPY --chown=$USER:$USER . /home/$USER/libjade
WORKDIR /home/$USER/libjade

