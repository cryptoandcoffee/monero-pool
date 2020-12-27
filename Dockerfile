FROM debian:latest
#For Monero build
RUN apt-get update ; apt-get dist-upgrade -yqq ; apt-get install -yqq git build-essential cmake pkg-config libboost-all-dev libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev doxygen graphviz libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev aria2
#For monero-pool build
RUN apt install -yqq liblmdb-dev libevent-dev libjson-c-dev uuid-dev
#Get Monero
RUN git clone https://github.com/monero-project/monero
#Build Monero
RUN cd monero ; git submodule update --init --force ; make -j6 release
RUN cd /monero/build/Linux/master/release/bin/
#RUN pwd ; ls -la
#RUN cd /monero/build/Linux/master/release/bin
#Secure Wallet
RUN echo "\
$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 128 | tr -d '\n'; echo)\
" >> /monero/build/Linux/master/release/bin/commands

RUN echo "\
$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 128 | tr -d '\n'; echo)\
" >> /monero/build/Linux/master/release/bin/commands

RUN tail -n 1 /monero/build/Linux/master/release/bin/commands >> /monero/build/Linux/master/release/bin/commands
RUN echo "1" >> /monero/build/Linux/master/release/bin/commands
RUN echo "0" >> /monero/build/Linux/master/release/bin/commands
RUN cat /monero/build/Linux/master/release/bin/commands

RUN aria2c --summary-interval=5 --max-connection-per-server=5 --min-split-size=10M https://downloads.getmonero.org/blockchain.raw
RUN ./monero-blockchain-import --input-file blockchain.raw
