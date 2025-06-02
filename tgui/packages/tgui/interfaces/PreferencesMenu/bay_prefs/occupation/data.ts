import { type BooleanLike } from 'tgui-core/react';

export enum AlternateOption {
  GET_RANDOM_JOB = 0,
  BE_ASSISTANT = 1,
  RETURN_TO_LOBBY = 2,
}

export enum Selected {
  Yes = 4,
  High = 3,
  Medium = 2,
  Low = 1,
  Never = 0,
}

export type Job = {
  title: string;
  ref: string;
  selection_color: string;
  banned: BooleanLike;
  denylist_days: BooleanLike;
  available_in_days: number;
  denylist_playtime: BooleanLike;
  available_in_hours: number;
  denylist_whitelist: BooleanLike;
  // evil
  denylist_character_age: BooleanLike;
  min_age: number;
  special_color: string;
  selected: Selected;
  selected_title: string;
  alt_titles: string[];
};

export type OccupationData = {
  alternate_option: AlternateOption;
  jobs: Record<string, Job[]>;
};

export type OccupationDataStatic = {};
export type OccupationDataConstant = {};
