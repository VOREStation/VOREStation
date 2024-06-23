import { BooleanLike } from 'common/react';

export const HOMETAB = 1;
export const PHONTAB = 2;
export const CONTTAB = 3;
export const MESSTAB = 4;
export const MESSSUBTAB = 40;
export const NEWSTAB = 5;
export const NOTETAB = 6;
export const WTHRTAB = 7;
export const MANITAB = 8;
export const SETTTAB = 9;

export const tabs = [
  HOMETAB,
  PHONTAB,
  CONTTAB,
  MESSTAB,
  MESSSUBTAB,
  NEWSTAB,
  NOTETAB,
  WTHRTAB,
  MANITAB,
  SETTTAB,
];

export function notFound(val) {
  return tabs.includes(val);
}

export type Data = {
  // GENERAL
  currentTab: number;
  video_comm: BooleanLike;
  mapRef: string;

  // FOOTER
  time: string;
  connectionStatus: BooleanLike;
  owner: string;
  occupation: string;

  // HEADER
  flashlight: BooleanLike;

  // HOMETAB
  homeScreen: { number: number; module: string; icon: string }[];

  // PHONETAB
  targetAddress: string;
  voice_mobs: { name: string; true_name: string; ref: string }[];
  communicating: {
    address: string;
    name: string;
    true_name: string;
    ref: string;
  }[];
  requestsReceived: { address: string; name: string; ref: string }[];
  invitesSent: { address: string; name: string }[];
  phone_video_comm: string;
  selfie_mode: BooleanLike;

  // MESSAGING
  imContacts: { address: string; name: string }[];
  targetAddressName: string;
  imList: { address: string; to_address: string; im: string }[];

  // SETTINGS
  address: string;
  visible: BooleanLike;
  ring: BooleanLike;

  // NEWSTAB
  feeds: { index: number; name: string }[];
  target_feed: { name: string; author: string; messages: NewsMessage[] };
  latest_news: NewsMessage[];

  // NOTETAB
  note: string;
};

type NewsMessage = {
  ref: string;
  body: string;
  img: string;
  caption: string;
  message_type: string;
  author: string;
  time_stamp: string;

  index: number;
  channel: string;
};
