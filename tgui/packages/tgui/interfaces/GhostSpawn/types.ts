export type Data = { all_ghost_pods: PodData[]; user_z: number };

export type PodData = {
  pod_type: string;
  pod_name: string;
  z_level: number;
  ref: string;
};
