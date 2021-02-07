#!/bin/bash

set -e 

./entrypoint.sh --id 0 \
		--secrets_path ../stack/secrets \
		--type relay \
		--mock 

./entrypoint.sh --id 1 \
		--secrets_path ../stack/secrets \
		--type relay \
		--mock 
		

./entrypoint.sh --id 0 \
		--secrets_path ../stack/secrets \
		--type producer \
		--mock 
