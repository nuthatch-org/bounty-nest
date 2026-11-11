# bounty-nest

Sync bounties on [BountyBoard 2.0.0](https://repo.sourcify.dev/42161/0x5f04B3aA9BA68Db285a7216bDEB6efa9beb59962)
(Arbitrum One), as SQL. A [nuthatch](https://nuthatch-indexer.com) nest: one binary, a local
database, no service to ask.

```sh
nuthatch dev
nuthatch sql "SELECT * FROM open_bounties"
```

| Relation | What it is |
|---|---|
| `open_bounties` | Bounties still in escrow, largest first. What an indexer's automation polls. |
| `bounties` | Every bounty, with its status: open, paid, cancelled or refunded. |
| `board__bounty_posted`, `…_distributed`, `…_cancelled`, `…_refunded` | The contract's four events, decoded. |

To earn an open bounty: allocate to `deployment_id`, sync it, present a POI and leave the
allocation open. Anyone can then call `distribute(bounty_id, allocation)`, and the contract's
`check(bounty_id, allocation)` says beforehand whether it would pay.

`expires_at` is unix seconds, 0 for none. The contract has no event for time passing, so an open
bounty past its expiry still reads `open` here; compare it with your own clock.

One real bounty has been through the views, open. No paid, cancelled or refunded bounty has yet,
because the board has not had one.
