import React, { useEffect, useRef, useState } from 'react';
import { Box, Button, InfinitePlane } from 'tgui-core/components';

import { resolveAsset } from '../../assets';
import {
  type Connection,
  Connections,
  ConnectionStyle,
} from '../common/Connections';
import { GraphNode } from './graphNodes';
import { type GraphNodeData } from './types';

export const NetworkGraph = (props: {
  nodes: GraphNodeData[];
  theme: string;
}) => {
  const { nodes, theme } = props;
  const planeRef = useRef<HTMLDivElement>(null);

  const [coords, setCoords] = useState<[number, number]>([0, 0]);

  // Center on first node after mount
  useEffect(() => {
    if (!planeRef.current || nodes.length === 0) return;
    const rect = planeRef.current.getBoundingClientRect();
    setCoords([
      nodes[0].x * -1 + rect.width / 2,
      nodes[0].y * -1 + rect.height / 2,
    ]);
  }, [nodes.length]);

  // Build connections from nodes prop
  const connections: Connection[] = [];
  for (const node of nodes) {
    for (const targetKey of node.connectsTo) {
      const target = nodes.find((n) => n.key === targetKey);
      if (!target) continue;
      connections.push({
        from: { x: node.x, y: node.y },
        to: { x: target.x, y: target.y },
        style: ConnectionStyle.DIRECT,
        packetDurationMs: 20000,
        packetFrequencyMs: 1000,
        packetSize: 4,
        packetColor: node.glitch
          ? 'var(--graph-color-glitch, #ff00ff)'
          : undefined,
      });
    }
  }

  // Center on a specific node
  const center = (node?: GraphNodeData) => {
    if (!planeRef.current || nodes.length === 0) return;
    const rect = planeRef.current.getBoundingClientRect();
    const target = node || nodes[0];

    console.log(
      `Centering on node: ${target.name} at (${target.x}, ${target.y})`,
    );
    setCoords([
      target.x * -1 + rect.width / 2,
      target.y * -1 + rect.height / 2,
    ]);
  };

  return (
    <div
      ref={planeRef}
      style={{ width: '100%', height: '100%', position: 'relative' }}
    >
      <Box width="100%" height="100%" position="relative">
        <Button onClick={() => center()}>Center on first node</Button>
        <InfinitePlane
          imageWidth={900}
          maximumZoom={3}
          minimumZoom={0.1}
          zoomToX={coords[0]}
          zoomToY={coords[1]}
          backgroundImage={resolveAsset('cmd_ui_hex.png')}
        >
          {nodes.map((node) => (
            <GraphNode
              key={node.key}
              node={node}
              onClick={() => center(node)}
            />
          ))}
          <div className="connection-glow">
            <Connections connections={connections} />
          </div>
        </InfinitePlane>
      </Box>
    </div>
  );
};
