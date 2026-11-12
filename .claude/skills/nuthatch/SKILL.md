---
name: nuthatch
description: Query this self-hosted nuthatch nest on arbitrum-one - decoded events, balances, and read-only SQL. Use when asked about on-chain activity for these contracts.
---

# Querying the nuthatch nest

Contracts indexed on arbitrum-one:
- `board` = 0x5f04b3aa9ba68db285a7216bdeb6efa9beb59962
- `board3` = 0xfbfcbb2e2da78db189443a340bc13c54bb703710

Data is local - never call an external API for it.

## Preferred: MCP
If a `nuthatch` MCP server is configured, use its tools. Call `schema` first to learn the
data model, then `sql` / `entity` / `balance` / `top_balances`.

## Fallback: HTTP (a `nuthatch dev` must be running)
- Recent rows:  `curl localhost:8288/entities?limit=20`
- Read-only SQL: `curl -G localhost:8288/sql --data-urlencode 'q=SELECT count(*) FROM board3__bounty_cancelled'`

`sql` reads hot and sealed rows together, so it covers the live tip. Each answer's
`provenance.sealed_through` is the block through which this nest has sealed history; newer rows
may still be hot, and it is not the chain's finality head.
