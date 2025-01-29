import { BooleanLike } from 'tgui-core/react';

export type Data = {
  temp: { text: string; style: string } | null;
  user: string;
  unit_no: number;
  wanted_issue: {
    author: string;
    criminal: string;
    desc: string;
    img: string | null;
  };
  securityCaster: BooleanLike;
  channels: {
    admin: BooleanLike;
    ref: string;
    name: string;
    censored: BooleanLike;
  }[];
  channel_name: string;
  c_locked: BooleanLike;
  msg: string;
  title: string;
  photo_data: BooleanLike;
  total_num: number;
  active_num: number;
  message_num: number;
  paper_remaining: number;
  viewing_channel: {
    name: string;
    author: string;
    censored: BooleanLike;
    messages: {
      title: string | null;
      body: string;
      img: string | null;
      type: string;
      caption: string | null;
      author: string;
      timestamp: string;
      ref: string;
    }[];
    ref: string;
  };
  company: string;
};
