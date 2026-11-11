-- What an indexer's automation wants: the bounties still holding GRT, largest first.
CREATE VIEW open_bounties AS
  SELECT bounty_id, deployment_id, amount_grt, amount_wei, expires_at, posted_at, posted_block, developer
  FROM bounties
  WHERE status = 'open'
  ORDER BY amount_wei DESC;
