-- One row per bounty the board has ever held, with where it stands now.
--
-- `expired` is not a status here: the contract has no event for the passing of time. An open bounty
-- whose `expires_at` is behind the clock can no longer be paid and can be refunded by anyone, so
-- compare `expires_at` (unix seconds, 0 for none) with your own clock.
CREATE VIEW bounties AS
  SELECT
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
