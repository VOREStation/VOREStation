import { BooleanLike } from 'common/react';

export type Data = {
  target: {
    name: string;
    ckey: string;
    module: string;
    crisis_override: BooleanLike;
    active_restrictions: string[];
    possible_restrictions: string[];
    front: string | null;
    side: string | null;
    back: string | null;
  } | null;
  all_players: DropdownEntry[];
};

export type DropdownEntry = {
  displayText: string;
  value: string;
};
