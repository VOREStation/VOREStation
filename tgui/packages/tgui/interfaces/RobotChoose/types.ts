export type Data = {
  possible_modules: string[];
  possible_sprites?: spriteOption[];
  theme?: string;
  selected_module?: string;
  sprite_datum?: string | null;
  sprite_datum_class?: string | null;
  sprite_datum_size?: string;
};

export type spriteOption = { sprite: string; belly: boolean; type: string };
