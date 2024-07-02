import { BooleanLike } from 'common/react';

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
  target_feed: { name: string; author: string; messages: NewsMessage[] } | null;
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

export type ContactsTabData = {
  knownDevices: { address: string; name: string }[];
};

export type WeatherTabData = {
  aircontents: AirContent[];
  weather: Weather[];
};

export type AirContent = {
  entry: string;
  val;
  bad_low: number;
  poor_low: number;
  poor_high: number;
  bad_high: number;
  units;
};

type Weather = {
  Planet: string;
  Time: string;
  Weather: string;
  Temperature;
  High;
  Low;
  WindDir;
  WindSpeed;
  Forecast: string;
};
