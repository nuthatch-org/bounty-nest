-- Each time someone proved to board 3.0.0 or 4.0.0 that an allocation presented a POI that was not
-- zero. An allocation is paid a bounty posted before `presented_at`, its latest one here, on the
-- board that holds the bounty. A 4.0.0 bounty stays payable until `expires_at + 259200`, and only
-- then is refundable.
CREATE VIEW proven_pois AS
  SELECT
    '4.0.0'             AS board_version,
    '0xc2cf5a01c91d08d039a8527616346422e75ba47d' AS board,
    "allocationId"      AS allocation,
    "poi"               AS poi,
    "blockNumber_dec"   AS presented_block,
    "presentedAt_dec"   AS presented_at,
    block_timestamp     AS proven_at,
    tx_hash             AS proven_in
  FROM "board4__p_o_i_proven"
  UNION ALL
  SELECT
    '3.0.0'             AS board_version,
    '0xfbfcbb2e2da78db189443a340bc13c54bb703710' AS board,
    "allocationId"      AS allocation,
    "poi"               AS poi,
    "blockNumber_dec"   AS presented_block,
    "presentedAt_dec"   AS presented_at,
    block_timestamp     AS proven_at,
    tx_hash             AS proven_in
  FROM "board3__p_o_i_proven";
