export type GraphNodeData = {
  key: string; // unique path-based key
  name: string; // display name
  x: number;
  y: number;
  parentX?: number;
  parentY?: number;
  type: 'localhost' | 'node' | 'subnode';
  glitch?: boolean;
  angleFromParent?: number; // angle from parent node in radians
  distortion?: number;
  connectsTo: string[]; // keys of children
  pulseOffset?: number;
  latency?: number;
};
