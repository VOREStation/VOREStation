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
  item: { name: string; sprite: string; preview: string } | null;
};
