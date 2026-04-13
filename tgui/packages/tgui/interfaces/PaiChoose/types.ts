export type Data = {
  selected_chassis: string | null;
  pai_color: string;
  pai_chassises?: spriteOption[];
  pai_chassis?: string;
  sprite_datum_class?: string;
  sprite_datum_size?: string;
};

export type spriteOption = { sprite: string; belly: boolean; type: string };
