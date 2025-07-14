import { type GraphNodeData, type NodeInstance } from './types';

// Build a map for quick lookup
function buildNodeMap(instances: NodeInstance[]) {
  const map = new Map<string, NodeInstance>();
  for (const node of instances) {
    map.set(node.key, node);
  }
  return map;
}

// Recursive radial layout
function layoutRadial(
  node: NodeInstance,
  nodeMap: Map<string, NodeInstance>,
  x: number,
  y: number,
  radius: number,
  angleStart: number,
  angleEnd: number,
  nodes: GraphNodeData[],
  visited: Set<string>,
  level: number,
  distance: number, // <-- new argument
) {
  if (visited.has(node.key)) return;
  visited.add(node.key);

  nodes.push({
    key: node.key,
    name: node.name,
    x,
    y,
    type: node.Type,
    glitch: !!node.glitch,
    distortion: node.distortion ?? 0,
    connectsTo: [...(node.children ?? [])],
    pulseOffset: Math.random() * Math.PI * 2,
    latency: node.latency,
  });

  const children = node.children ?? [];
  if (!children.length) return;

  // Add a spread factor to increase angular separation
  const spreadFactor = 1.5; // Try 1.5, 2, etc. for more spread
  const angleStep =
    ((angleEnd - angleStart) / Math.max(children.length, 1)) * spreadFactor;
  const totalAngle = angleStep * children.length;
  const startAngle = (angleStart + angleEnd) / 2 - totalAngle / 2;

  children.forEach((childKey, i) => {
    const childNode = nodeMap.get(childKey);
    if (!childNode) return;
    // Halve the distance if the child is a subnode
    const effectiveDistance =
      childNode.Type === 'subnode' ? distance / 2 : distance;
    const childRadius = effectiveDistance + level;
    const angle = startAngle + angleStep * (i + 0.5);
    const childX = x + childRadius * Math.cos(angle);
    const childY = y + childRadius * Math.sin(angle);
    layoutRadial(
      childNode,
      nodeMap,
      childX,
      childY,
      childRadius,
      angle - angleStep / 2,
      angle + angleStep / 2,
      nodes,
      visited,
      level + 1,
      distance, // propagate original distance
    );
  });
}

export function layoutNetwork(
  instances: NodeInstance[],
  centerX = 0,
  centerY = 0,
  distance = 110, // <-- new argument with default
): GraphNodeData[] {
  const nodeMap = buildNodeMap(instances);
  // Automatically find the root node (localhost)
  const root = instances.find((n) => n.Type === 'localhost');
  if (!root) return [];

  const nodes: GraphNodeData[] = [];
  const visited = new Set<string>();

  // Start with a full circle (0 to 2π)
  layoutRadial(
    root,
    nodeMap,
    centerX,
    centerY,
    0,
    0,
    2 * Math.PI,
    nodes,
    visited,
    1,
    distance, // pass distance
  );

  // Place any unvisited nodes in a ring around the center
  const unvisited = instances.filter((n) => !visited.has(n.key));
  if (unvisited.length) {
    const r = distance;
    unvisited.forEach((node, i) => {
      const angle = (2 * Math.PI * i) / unvisited.length;
      nodes.push({
        key: node.key,
        name: node.name,
        x: centerX + r * Math.cos(angle),
        y: centerY + r * Math.sin(angle),
        type: node.Type,
        glitch: !!node.glitch,
        distortion: node.distortion ?? 0,
        connectsTo: [...(node.children ?? [])],
        pulseOffset: Math.random() * Math.PI * 2,
        latency: node.latency,
      });
    });
  }

  return nodes;
}
