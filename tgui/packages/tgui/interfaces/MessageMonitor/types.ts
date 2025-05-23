import { BooleanLike } from 'tgui-core/react';

export type Data = {
  customsender: string;
  customrecepient: string;
  customjob: string;
  custommessage: string;
  temp: { color: string; text: string } | null;
  hacking: BooleanLike;
  emag: BooleanLike;
  auth: BooleanLike;
  linkedServer: {
    active: BooleanLike;
    broke: BooleanLike;
    pda_msgs: pda_msgs[];
    rc_msgs: rc_message[];
    spamFilter: { index: number; token: string }[];
  };
  possibleRecipients: Record<string, string>[];
  isMalfAI: BooleanLike;
};

type pda_msgs = {
  ref: string;
  sender: string;
  recipient: string;
  message: string;
};

type rc_message = {
  ref: string;
  sender: string;
  recipient: string;
  message: string;
  stamp: string;
  id_auth: string;
  priority: string;
};
