export type Data = {
  name: string;
  base_color: string;
  icon: string;
  preview: string;
  possible_overlays: PossibleOverlay[];
  overlays: Overlay[];
};

export type Overlay = {
  icon_state: string;
  name?: string;
  color?: string;
  alpha?: number;
};

export type PossibleOverlay = { name: string; icon_state: string };

export type PlushieConfig = {
  name: string;
  base_color: string;
  icon: string;
  overlays: Overlay[];
};
