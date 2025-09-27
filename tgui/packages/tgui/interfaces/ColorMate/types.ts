export type Data = {
  activemode: number;
  matrixcolors: {
    rr: number;
    rg: number;
    rb: number;
    gr: number;
    gg: number;
    gb: number;
    br: number;
    bg: number;
    bb: number;
    cr: number;
    cg: number;
    cb: number;
  };
  buildhue: number;
  buildsat: number;
  buildval: number;
  temp: string | null;
  item_name: string | null;
  item_sprite: string | null;
  item_preview: string | null;
  message?: string;
  title?: string;
  matrix_only?: number;
};
