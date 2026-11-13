-- One row per bounty any board has ever held, with where it stands now.
--
-- A bounty id is only unique on its own board, so `board` (the contract to call) goes with it.
-- Version 4.0.0 is where bounties are posted now; 3.0.0 and 2.0.0 are kept for what was posted on
-- them.
--
-- `expired` is not a status here: the contract has no event for the passing of time. On 3.0.0 and
-- 2.0.0 an open bounty whose `expires_at` is behind the clock can no longer be paid and can be
-- refunded by anyone. On 4.0.0 it is still paid for 72 hours after it, and is refundable only after
-- `expires_at + 259200`. Compare with your own clock; `expires_at` is unix seconds, 0 for none.
--
-- 4.0.0 has no cancel, so it has no BountyCancelled event and no `board4__bounty_cancelled` table.
CREATE VIEW bounties AS
  SELECT
    '4.0.0'                          AS board_version,
    '0xc2cf5a01c91d08d039a8527616346422e75ba47d' AS board,
    p."bountyId"                         AS bounty_id,
    p."deploymentId"                     AS deployment_id,
    p."developer"                        AS developer,
    p."amount_dec"                       AS amount_wei,
    p."amount_dec" / 1e18                AS amount_grt,
    p."expiresAt_dec"                    AS expires_at,
    p.block_timestamp                    AS posted_at,
    p.block_number                       AS posted_block,
    CASE
      WHEN d."bountyId" IS NOT NULL THEN 'paid'
      WHEN r."bountyId" IS NOT NULL THEN 'refunded'
      ELSE 'open'
    END                                  AS status,
    d."indexer"                          AS paid_indexer,
    d."payee"                            AS paid_to,
    d."allocationId"                     AS paid_allocation,
    d."caller"                           AS paid_by,
    COALESCE(d.block_timestamp, r.block_timestamp) AS settled_at
  FROM "board4__bounty_posted" p
  LEFT JOIN "board4__bounty_distributed" d ON d."bountyId" = p."bountyId"
  LEFT JOIN "board4__bounty_refunded"    r ON r."bountyId" = p."bountyId"
  UNION ALL
  SELECT
    '3.0.0'                          AS board_version,
    '0xfbfcbb2e2da78db189443a340bc13c54bb703710' AS board,
    p."bountyId"                         AS bounty_id,
    p."deploymentId"                     AS deployment_id,
    p."developer"                        AS developer,
    p."amount_dec"                       AS amount_wei,
    p."amount_dec" / 1e18                AS amount_grt,
    p."expiresAt_dec"                    AS expires_at,
    p.block_timestamp                    AS posted_at,
    p.block_number                       AS posted_block,
    CASE
      WHEN d."bountyId" IS NOT NULL THEN 'paid'
      WHEN c."bountyId" IS NOT NULL THEN 'cancelled'
      WHEN r."bountyId" IS NOT NULL THEN 'refunded'
      ELSE 'open'
    END                                  AS status,
    d."indexer"                          AS paid_indexer,
    d."payee"                            AS paid_to,
    d."allocationId"                     AS paid_allocation,
    d."caller"                           AS paid_by,
    COALESCE(d.block_timestamp, c.block_timestamp, r.block_timestamp) AS settled_at
  FROM "board3__bounty_posted" p
  LEFT JOIN "board3__bounty_distributed" d ON d."bountyId" = p."bountyId"
  LEFT JOIN "board3__bounty_cancelled"   c ON c."bountyId" = p."bountyId"
  LEFT JOIN "board3__bounty_refunded"    r ON r."bountyId" = p."bountyId"
  UNION ALL
  SELECT
    '2.0.0'                          AS board_version,
    '0x5f04b3aa9ba68db285a7216bdeb6efa9beb59962' AS board,
    p."bountyId"                         AS bounty_id,
    p."deploymentId"                     AS deployment_id,
    p."developer"                        AS developer,
    p."amount_dec"                       AS amount_wei,
    p."amount_dec" / 1e18                AS amount_grt,
    p."expiresAt_dec"                    AS expires_at,
    p.block_timestamp                    AS posted_at,
    p.block_number                       AS posted_block,
    CASE
      WHEN d."bountyId" IS NOT NULL THEN 'paid'
      WHEN c."bountyId" IS NOT NULL THEN 'cancelled'
      WHEN r."bountyId" IS NOT NULL THEN 'refunded'
      ELSE 'open'
    END                                  AS status,
    d."indexer"                          AS paid_indexer,
    d."payee"                            AS paid_to,
    d."allocationId"                     AS paid_allocation,
    d."caller"                           AS paid_by,
    COALESCE(d.block_timestamp, c.block_timestamp, r.block_timestamp) AS settled_at
  FROM "board__bounty_posted" p
  LEFT JOIN "board__bounty_distributed" d ON d."bountyId" = p."bountyId"
  LEFT JOIN "board__bounty_cancelled"   c ON c."bountyId" = p."bountyId"
  LEFT JOIN "board__bounty_refunded"    r ON r."bountyId" = p."bountyId";
