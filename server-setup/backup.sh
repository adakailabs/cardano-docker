#!/bin/bash

set -e
eval "$(ssh-agent -s)" && \
    ssh-add /home/galuisal/.ssh/id_rsa_ext
ssh-add -l
    rsync --delete -avzhe 'ssh -p 2222' --progress  lovelace@192.168.100.47:/home/lovelace/cardano-node/mainnet/rocinante/relay0 /mnt/storage/cardano/ \
    && ssh -p 2222 lovelace@192.168.100.40 'mkdir -p /home/lovelace/cardano-node/mainnet/rocinante/backup' \
    && rsync --delete -avzhe 'ssh -p 2222' --progress /mnt/storage/cardano/relay0/* lovelace@192.168.100.40:/home/lovelace/cardano-node/mainnet/rocinante/backup \
    && ssh -p 2222 lovelace@192.168.100.41 'mkdir -p /home/lovelace/cardano-node/mainnet/rocinante/backup' \
    && rsync --delete -avzhe 'ssh -p 2222' --progress /mnt/storage/cardano/relay0/* lovelace@192.168.100.41:/home/lovelace/cardano-node/mainnet/rocinante/backup \
    && ssh -p 2222 lovelace@192.168.100.42 'mkdir -p /home/lovelace/cardano-node/mainnet/rocinante/backup' \
    && rsync --delete -avzhe 'ssh -p 2222' --progress /mnt/storage/cardano/relay0/* lovelace@192.168.100.42:/home/lovelace/cardano-node/mainnet/rocinante/backup \
    && ssh -p 2222 lovelace@192.168.100.43 'mkdir -p /home/lovelace/cardano-node/mainnet/rocinante/backup' \
    && rsync --delete -avzhe 'ssh -p 2222' --progress /mnt/storage/cardano/relay0/* lovelace@192.168.100.43:/home/lovelace/cardano-node/mainnet/rocinante/backup \
    && ssh -p 2222 lovelace@192.168.100.44 'mkdir -p /home/lovelace/cardano-node/mainnet/rocinante/backup' \
    && rsync --delete -avzhe 'ssh -p 2222' --progress /mnt/storage/cardano/relay0/* lovelace@192.168.100.44:/home/lovelace/cardano-node/mainnet/rocinante/backup \
    

