# bounty-nest

Sync bounties on [BountyBoard 4.0.0](https://repo.sourcify.dev/42161/0xc2CF5A01c91D08d039a8527616346422E75BA47d)
(Arbitrum One), as SQL, with what was posted on [3.0.0](https://repo.sourcify.dev/42161/0xfBFcbb2e2da78dB189443a340Bc13C54BB703710)
and [2.0.0](https://repo.sourcify.dev/42161/0x5f04B3aA9BA68Db285a7216bDEB6efa9beb59962) before it. A [nuthatch](https://nuthatch-indexer.com) nest: one binary, a local
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
| `bounties` | Every bounty, with its status: open, paid, cancelled or refunded. 4.0.0 has no cancel. |
| `proven_pois` | Each proof 4.0.0 or 3.0.0 has accepted that an allocation presented a POI that was not zero, with the board that accepted it. |
| `board4__bounty_posted`, `…_distributed`, `…_refunded`, `board4__p_o_i_proven` | The four events of 4.0.0, decoded. |
| `board3__bounty_posted`, `…_distributed`, `…_cancelled`, `…_refunded`, `board3__p_o_i_proven` | The five events of 3.0.0. |
| `board__bounty_posted`, `…_distributed`, `…_cancelled`, `…_refunded` | The four events of 2.0.0. |

A `bounty_id` is unique only on its own board, so every row carries `board`, the contract to
call, and `board_version`.

To earn an open bounty on 4.0.0 or 3.0.0: allocate to `deployment_id`, sync it and present a POI that is
not zero. Anyone can then call `proveAndDistribute(bounty_id, allocation, proof)` on `board`. The
proof is the header of the block the POI was presented in and its receipt, which the contract
checks against the chain's own record of block hashes, so it has to be sent within about a day
of the presentation. [lodestar-dashboard.com/bounties](https://www.lodestar-dashboard.com/bounties)
builds and sends it, and an allocation that has since closed is still paid.

On 2.0.0 it is `distribute(bounty_id, allocation)`, with the allocation still open.

`expires_at` is unix seconds, 0 for none. The contract has no event for time passing, so an open
bounty past its expiry still reads `open` here; compare it with your own clock. On 3.0.0 and 2.0.0
it can no longer be paid once its expiry passes. On 4.0.0 it is still paid for 72 hours after, and
is refundable only after `expires_at + 259200`.

Run from the start blocks on 2026-11-13, the views held one open bounty on 2.0.0, two paid
bounties and one proven POI on 3.0.0, and nothing on 4.0.0, which had just been deployed. No
cancelled or refunded bounty has been through them yet.
