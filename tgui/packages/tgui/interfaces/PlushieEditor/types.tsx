export type Data = {
  name: string;
  base_color: string;
  icon: string;
  preview: string;
  possible_overlays: { name: string; icon_state: string }[];
  overlays: Overlay[];
};

export type Overlay = {
  icon_state: string;
  name?: string;
  color?: string;
  alpha?: number;
};

export type PlushieConfig = {
  name: string;
  base_color: string;
  icon: string;
  overlays: Overlay[];
};
