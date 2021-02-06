#!/bin/bash

set -e 

./entrypoint.sh --name relay \
		--id 0 \
		--producer_addr ../stack/secrets/producer_private_host_name.txt \
		--relay_other_public_addr ../stack/secrets/relay1_public_host_name.txt \
		--relay_other_private_addr ../stack/secrets/relay1_private_host_name.txt \
		--relay_this_public_addr ../stack/secrets/relay0_public_host_name.txt \
		--relay_this_private_addr ../stack/secrets/relay0_private_host_name.txt \
		--type relay \
		--test 

./entrypoint.sh --name relay \
		--id 1 \
		--producer_addr ../stack/secrets/producer_private_host_name.txt \
		--relay_other_public_addr ../stack/secrets/relay0_public_host_name.txt \
		--relay_other_private_addr ../stack/secrets/relay0_private_host_name.txt \
		--relay_this_public_addr ../stack/secrets/relay1_public_host_name.txt \
		--relay_this_private_addr ../stack/secrets/relay1_private_host_name.txt \
		--type relay \
		--test 

./entrypoint.sh --name relay \
		--id 0 \
		--producer_addr ../stack/secrets/producer_private_host_name.txt \
		--relay_other_public_addr ../stack/secrets/relay1_public_host_name.txt \
		--relay_other_private_addr ../stack/secrets/relay1_private_host_name.txt \
		--relay_this_public_addr ../stack/secrets/relay0_public_host_name.txt \
		--relay_this_private_addr ../stack/secrets/relay0_private_host_name.txt \
		--type producer \
		--test 
