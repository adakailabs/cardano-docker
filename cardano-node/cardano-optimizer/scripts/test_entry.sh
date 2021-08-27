#!/bin/bash

set -e 

./entrypoint.sh --id 0 \
		--secrets_path ../secrets \
		--type relay \
		--mock 

./entrypoint.sh --id 1 \
		--secrets_path ../secrets \
		--type relay \
		--mock 
		

./entrypoint.sh --id 0 \
		--secrets_path ../secrets \
		--type producer \
		--mock 

./entrypoint.sh --id 0 \
		--secrets_path ../secrets \
		--type relay \
		--mock \
                --testnet 

./entrypoint.sh --id 1 \
		--secrets_path ../secrets \
		--type relay \
		--mock \
                --testnet
		

./entrypoint.sh --id 0 \
		--secrets_path ../secrets \
		--type producer \
		--mock \
                --testnet

#./entrypoint.sh --mock --testnet --standalone

#./entrypoint.sh --mock --standalone
