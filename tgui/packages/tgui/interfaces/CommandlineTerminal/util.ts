import { type GraphNodeData } from './types';

export type NodeConfig = {
  name: string;
  parent?: string;
  subs?: (string | NodeConfig)[];
  glitch?: boolean;
  distortion?: number;
  latency?: number;
};

// Radial tree layout: localhost in center, children in circles around parent
export function layoutNetwork(
  configs: NodeConfig[],
  rootName = 'LOCALHOST',
  centerX = 0,
  centerY = 0,
  radiusStep = 240,
): GraphNodeData[] {
  const nodes: GraphNodeData[] = [];

  function placeNode(
    config: NodeConfig,
    x: number,
    y: number,
    type: GraphNodeData['type'],
    path: string,
    parentX?: number,
    parentY?: number,
    depth: number = 0,
    angleStart: number = 0,
    angleSpan: number = Math.PI * 2,
  ): string {
    const node: GraphNodeData = {
      key: path,
      name: config.name,
      x,
      y,
      parentX,
      parentY,
      type,
      glitch: !!config.glitch,
      distortion: config.distortion ?? 0,
      connectsTo: [],
      pulseOffset: Math.random() * Math.PI * 2,
      latency: config.latency,
    };
    nodes.push(node);

    // Gather all children (subs and configs with parent = this node)
    const children = configs.filter((c) => c.parent === config.name);
    const allChildren: NodeConfig[] = [
      ...(Array.isArray(config.subs)
        ? config.subs.map((sub) =>
            typeof sub === 'string'
              ? { name: sub, glitch: false, distortion: 0, latency: 0 }
              : sub,
          )
        : []),
      ...children,
    ];

    if (allChildren.length > 0) {
      allChildren.forEach((childConfig, idx) => {
        const angleStep = angleSpan / allChildren.length;
        const angle = angleStart + idx * angleStep;
        let childType: GraphNodeData['type'] = 'node';
        if (
          (Array.isArray(childConfig.subs) && childConfig.subs.length > 0) ||
          configs.some((c) => c.parent === childConfig.name)
        ) {
          childType = 'node';
        } else {
          childType = 'subnode';
        }
        // Double the distance for non-subnodes, keep subnodes close
        const childRadius =
          childType === 'subnode' ? radiusStep * 1 : radiusStep * 2;
        const cx = x + Math.cos(angle) * childRadius;
        const cy = y + Math.sin(angle) * childRadius;
        const childKey = `${path}/${idx}-${childConfig.name}`;
        // Each child gets its own angle sector (for subtree)
        const childAngleSpan = angleStep;
        const childAngleStart = angle - angleStep / 2 + angleStep / 2;
        const childPath = placeNode(
          childConfig,
          cx,
          cy,
          childType,
          childKey,
          x,
          y,
          depth + 1,
          childAngleStart,
          childAngleSpan,
        );
        node.connectsTo.push(childPath);
        const angleFromParent = angle; // angle used for this child
        // After node creation:
        nodes[nodes.length - 1].angleFromParent = angleFromParent;
      });
    }

    return path;
  }

  // Find root node config
  const rootConfig = configs.find((c) => c.name === rootName) || configs[0];
  placeNode(rootConfig, centerX, centerY, 'localhost', rootConfig.name);

  return nodes;
}
