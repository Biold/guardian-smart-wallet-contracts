-include .env

.PHONY: all test test_anvil clean deploy fund help install snapshot format anvil 

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove update build deploy

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

test_anvil :; forge test --rpc-url $(ANVIL_RPC_URL)

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

ifeq ($(findstring --network areon,$(ARGS)),--network areon)
	NETWORK_ARGS := --rpc-url $(AREON_RPC_URL) --private-key $(AREON_PRIVATE_KEY) --broadcast -vvvv
endif

ifeq ($(findstring --network ganache,$(ARGS)),--network ganache)
	NETWORK_ARGS := --rpc-url $(GANACHE_RPC_URL) --private-key $(GANACHE_PRIVATE_KEY) --broadcast -vvvv
endif

deploy_smart_wallet_factory:
	@forge script scripts/DeploySmartAccountUtilContracts.s.sol:DeploySmartAccountUtilContracts $(NETWORK_ARGS)