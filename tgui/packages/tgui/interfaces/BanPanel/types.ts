import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  player_ckey: string | null;
  admin_ckey: string | null;
  player_ip: string | null;
  player_cid: string | null;
  bantype: string | null;
  possible_jobs: string[];
  database_records: DatabaseRecord[] | null;

  min_search: BooleanLike;
};

export type DropdownEntry = {
  displayText: string;
  value: string;
};

// This list is of the format: banid, bantime, bantype, reason, job, duration, expiration,
//     ckey, ackey, unbanned, unbanckey, unbantime, edits, ip, cid
export type DatabaseRecord = {
  data_list: string[];
  auto: BooleanLike;
};
