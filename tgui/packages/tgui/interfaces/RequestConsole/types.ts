import { BooleanLike } from 'common/react';

export type Data = {
  department: string;
  screen: number;
  message_log: string[][];
  newmessagepriority: number;
  silent: BooleanLike;
  announcementConsole: BooleanLike;
  assist_dept: string[];
  supply_dept: string[];
  info_dept: string[];
  message: string;
  recipient: string;
  priority: number;
  msgStamped: string;
  msgVerified: string;
  announceAuth: BooleanLike;
};
