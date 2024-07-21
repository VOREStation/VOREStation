import { BooleanLike } from 'common/react';

export type Data = {
  is_ai: BooleanLike;
  menu_state: string;
  emagged: BooleanLike;
  authenticated: BooleanLike;
  authmax: BooleanLike;
  atcsquelch: BooleanLike;
  boss_short: string;
  stat_display: {
    type: string;
    line_1: string;
    line_2: string;
    presets: { name: string; label: string; desc: string }[];
  };
  security_level: number;
  security_level_color: string;
  str_security_level: string;
  levels: { id: number; name: string; icon: string }[];
  messages: message[];
  message_deletion_allowed: BooleanLike;
  message_current_id: number;
  message_current: message;
  current_viewing_message: number;
  msg_cooldown: number;
  cc_cooldown: number;
  esc_callable: BooleanLike;
  esc_recallable: BooleanLike;
  esc_status: BooleanLike | string;
};

type message = { id: string; title: String; contents: string };
