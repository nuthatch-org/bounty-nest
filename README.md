# bounty-nest

Sync bounties on [BountyBoard 3.0.0](https://repo.sourcify.dev/42161/0xfBFcbb2e2da78dB189443a340Bc13C54BB703710)
(Arbitrum One), as SQL, with what was posted on [2.0.0](https://repo.sourcify.dev/42161/0x5f04B3aA9BA68Db285a7216bDEB6efa9beb59962)
before it. A [nuthatch](https://nuthatch-indexer.com) nest: one binary, a local
database, no service to ask.

```sh
nuthatch dev
nuthatch sql "SELECT * FROM open_bounties"
```

Or ask the copy we run, which needs no key and takes `GET` only:

```sh
curl 'https://nuthatch-indexer.com/nests/bounty-nest/sql?q=SELECT%20*%20FROM%20open_bounties'
```

It follows the chain a minute behind at most. It carries no uptime promise, which is the reason
the nest is here for you to run yourself.

| Relation | What it is |
|---|---|
| `open_bounties` | Bounties still in escrow, largest first. What an indexer's automation polls. |
| `bounties` | Every bounty, with its status: open, paid, cancelled or refunded. |
| `proven_pois` | Each proof 3.0.0 has accepted that an allocation presented a POI that was not zero. |
| `board3__bounty_posted`, `…_distributed`, `…_cancelled`, `…_refunded`, `board3__p_o_i_proven` | The five events of 3.0.0, decoded. |
| `board__bounty_posted`, `…_distributed`, `…_cancelled`, `…_refunded` | The four events of 2.0.0. |

A `bounty_id` is unique only on its own board, so every row carries `board`, the contract to
call, and `board_version`.

To earn an open bounty on 3.0.0: allocate to `deployment_id`, sync it and present a POI that is
not zero. Anyone can then call `proveAndDistribute(bounty_id, allocation, proof)` on `board`. The
proof is the header of the block the POI was presented in and its receipt, which the contract
checks against the chain's own record of block hashes, so it has to be sent within about a day
of the presentation. [lodestar-dashboard.com/bounties](https://www.lodestar-dashboard.com/bounties)
builds and sends it, and an allocation that has since closed is still paid.

On 2.0.0 it is `distribute(bounty_id, allocation)`, with the allocation still open.

`expires_at` is unix seconds, 0 for none. The contract has no event for time passing, so an open
bounty past its expiry still reads `open` here; compare it with your own clock.

One real bounty has been through the views, open, on 2.0.0. No paid, cancelled or refunded bounty
has yet, and 3.0.0 has emitted no event at all, so its half of the views has only ever been
empty.
