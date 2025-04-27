import type { ReactNode } from 'react';
import type { Box } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type LobbyData = {
  display_loading: BooleanLike;
  server_name: string;
  map: string;
  station_time: string;
  round_start: BooleanLike;
  round_time: string;
  ready: BooleanLike;
  new_news: BooleanLike;
  can_submit_feedback: BooleanLike;
  show_station_news: BooleanLike;
  new_station_news: BooleanLike;
  new_changelog: BooleanLike;
};

export type LobbyContextType = {
  animationsDisabled: boolean;
  animationsFinished: boolean;
  setModal?: (_: ReactNode | false) => void;
};

export type LobbyButtonProps = React.ComponentProps<typeof Box> & {
  readonly index: number;
  readonly selected?: boolean;
  readonly disabled?: boolean;
  readonly icon?: string;
  readonly tooltip?: string;
};
