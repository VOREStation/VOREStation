import { BooleanLike } from 'tgui-core/react';

export type Data = {
  category: number;
  piping_layer: number;
  pipe_layers: {
    Regular: number;
    Supply: number;
    Scrubber: number;
    Fuel: number;
    Aux: number;
  };
  preview_rows: {
    previews: {
      selected: BooleanLike;
      dir: string;
      dir_name: string;
      icon_state: string;
      flipped: BooleanLike;
    };
  }[];
  categories: { cat_name: string; recipes: recipe[] }[];
  selected_color: string;
  paint_colors: Record<string, string>;
  mode: number;
};

type recipe = { pipe_name: string; pipe_index: number; selected: BooleanLike };
