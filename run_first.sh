#!/bin/bash
git clone https://github.com/cryptoandcoffee/monero-pool
cd monero-pool
docker build -t monero-pool .

docker-compose up -d
docker exec -it monero-pool aria2c --summary-interval=5 --max-connection-per-server=5 --min-split-size=10M https://downloads.getmonero.org/blockchain.raw
docker exec -it monero-pool ./monero-blockchain-import --input-file blockchain.raw

#Once data is imported - it's time to run the wallet and start the pool!
./monerod --block-notify '/usr/bin/pkill -USR1 monero-pool'
#Ensure everything is synced and ready
./monero-wallet-rpc --disable-rpc-login --trusted-daemon --rpc-bind-port 18085 --wallet-file your_wallet_name --prompt-for-password
#Finally, let's go swimming!
./monero-pool
