# Pocket Network Contracts

Pocket Network is a blockchain agnostic, decentralized relay network. Nodes in the network spend compute in the form of running local nodes (geth/parity, bitcoin core, zcash, etc) and hosting standardized REST API endpoints. Nodes relay transactions for users in return for mint in PKT.

Users must stake PKT in order to use Node services. User transactions are throttled based on the amount of PKT staked in the PocketToken contract. Users must stake more PKT to send more transactions.

## Overview

- ERC20 token
- Tokens burned through registry contract
- Tokens staked by users and relayers
- Transactions throttled based on amount staked
- 3 primary contracts: Token, Relay and Registry

## TODOs

- Staking and slashing functions for nodes
- Relays throttled based on Node amount staked
- Relay/Node Slashing

## Known excessive/high gas costs

- changeDelegate called every time for PocketNode contracts
- strings should be bytes
- Registry too expensive
- Relay contract created for each relay
