export type GraphNodeData = {
  key: string;
  name: string;
  x: number;
  y: number;
  parentXs?: number[];
  parentYs?: number[];
  type: 'localhost' | 'node' | 'subnode';
  glitch: boolean;
  distortion: number;
  connectsTo: string[];
  pulseOffset: number;
  latency: number;
  angleFromParent?: number[];
};

export type NodeInstance = {
  name: string; // Display name
  key: string; // Byond ID
  Type: 'localhost' | 'node' | 'subnode'; // Type of node
  parents: string[]; // Parent nodes
  children: string[]; // Child nodes
  glitch: boolean; // Is this node glitched?
  distortion: number; // Distortion level
  latency: number; // Latency in ms
};

export type LogType = 'error' | 'standard';

export type Log = {
  source: string;
  time: number;
  station_time: string;
  owner: string;
  command: string;
  logs: {
    [key: string]: [LogType, string]; // key is dynamic, value is a tuple of [type, message]
  };
};
