-- Each time someone proved to board 3.0.0 that an allocation presented a POI that was not zero.
-- An allocation is paid a bounty posted before `presented_at`, its latest one here.
CREATE VIEW proven_pois AS
  SELECT
    "allocationId"      AS allocation,
    "poi"               AS poi,
    "blockNumber_dec"   AS presented_block,
    "presentedAt_dec"   AS presented_at,
    block_timestamp     AS proven_at,
    tx_hash             AS proven_in
  FROM "board3__p_o_i_proven";
