export type Data = {
  possible_modules: string[];
  possible_sprites?: spriteOption[];
  theme?: string;
  selected_module?: string;
  sprite_datum?: string | null;
  asset?: string | null;
};

export type spriteOption = { sprite: string; belly: boolean; type: string };
