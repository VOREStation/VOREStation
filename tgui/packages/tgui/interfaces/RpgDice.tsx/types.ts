import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  last_rolls: {
    player: string;
    count: number;
    size?: number;
    results?: Result[];
    mod?: number;
    apply_to_all?: BooleanLike;
    sum: number;
  }[];
};

export type Result = { result: number; state: number };
