export type Data = {
  base_color: string;
  icon: string;
  preview: string;
  possible_overlays: { name: string; icon_state: string }[];
  overlays: {
    icon_state: string;
    name: string;
    color: string;
    alpha: number;
  }[];
};

export type Overlay = Data['overlays'][number];

export type PlushieConfig = {
  base_color: string;
  overlays: Array<{
    icon_state: string;
    name?: string;
    color?: string;
    alpha?: number;
  }>;
};
