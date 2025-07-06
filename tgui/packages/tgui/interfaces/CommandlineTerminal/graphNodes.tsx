import 'tgui/styles/interfaces/CommandlineTerminal.scss';

import React, { useState } from 'react';

import { type GraphNodeData } from './types';

type GraphNodeProps = {
  node: GraphNodeData;
  selected?: boolean;
  onClick?: () => void;
};

export const GraphNode: React.FC<GraphNodeProps> = ({
  node,
  selected,
  onClick,
}) => {
  const [pulse, setPulse] = React.useState(0);
  const [glitchOffset, setGlitchOffset] = React.useState({ x: 0, y: 0 });
  const [hovered, setHovered] = useState(false);

  React.useEffect(() => {
    let frame: number;
    const animate = () => {
      setPulse((Math.sin(Date.now() / 800 + (node.pulseOffset || 0)) + 1) / 2);
      // Add shake if glitch is true
      if (node.glitch) {
        setGlitchOffset({
          x: (Math.random() - 0.5) * 6, // shake up to ±3px
          y: (Math.random() - 0.5) * 6,
        });
      } else {
        setGlitchOffset({ x: 0, y: 0 });
      }
      frame = requestAnimationFrame(animate);
    };
    animate();
    return () => cancelAnimationFrame(frame);
  }, [node.pulseOffset, node.glitch]);

  // Size by type
  let size = 32;
  let nodeClass = 'graph-node';
  if (node.type === 'localhost') {
    nodeClass += ' graph-node--hex';
    size = 32;
  } else if (node.type === 'node') {
    size = 20;
    nodeClass += ' graph-node--node';
  } else if (node.type === 'subnode') {
    size = 10;
    nodeClass += ' graph-node--subnode';
  }
  if (node.glitch) nodeClass += ' graph-node--glitch';
  if (selected) nodeClass += ' graph-node--selected';
  nodeClass += ' graph-node--glow-animate';

  // Subtle opacity pulse
  const opacity = 0.85 + pulse * 0.15;

  // Common label style
  const parentX = node.parentX ?? node.x;
  const parentY = node.parentY ?? node.y;
  const dx = node.x - parentX;
  const dy = node.y - parentY;

  // Default: label below
  let labelOffsetY = size / 2 + 8;
  let labelOffsetX = 0;
  let labelAlign = 'translate(-50%, 0)';

  if (Math.abs(dx) > Math.abs(dy)) {
    // More horizontal: label left or right
    labelOffsetY = 0;
    labelOffsetX = dx > 0 ? size / 2 + 8 : -size / 2 - 8;
    labelAlign = dx > 0 ? 'translate(0, -50%)' : 'translate(-100%, -50%)';
  } else {
    // More vertical: label above or below
    labelOffsetY = dy > 0 ? size / 2 + 8 : -size / 2 - 8;
    labelOffsetX = 0;
    labelAlign = 'translate(-50%, 0)';
  }

  // Apply glitch offset to node position
  const nodeX = node.x + glitchOffset.x;
  const nodeY = node.y + glitchOffset.y;

  // --- Label logic ---
  // Always above the node
  const labelY = nodeY - size / 2 - 4;

  const labelStyle: React.CSSProperties = {
    position: 'absolute',
    left: nodeX,
    top: labelY,
    transform: 'translate(-50%, -100%)',
    color: node.glitch
      ? 'var(--graph-label-glitch, #ff00ff)'
      : 'var(--graph-label, #fff)',
    fontFamily: "'Share Tech Mono', monospace",
    fontSize: hovered ? 12 : 6,
    textShadow: 'none',
    pointerEvents: 'auto',
    whiteSpace: hovered ? 'normal' : 'nowrap',
    opacity: 0.95,
    zIndex: 3,
    maxWidth: hovered ? 300 : 60,
    overflow: 'hidden',
    textOverflow: hovered ? 'clip' : 'ellipsis',
    background: hovered ? 'rgba(0,0,0,0.7)' : undefined,
    padding: hovered ? '2px 6px' : undefined,
    borderRadius: hovered ? 4 : undefined,
    transition: 'font-size 0.15s, max-width 0.15s',
    fontWeight: hovered ? 'bold' : undefined,
  };

  if (node.type === 'localhost') {
    const glowSize = size * 0.9;
    return (
      <>
        <div
          className="graph-node-hex-glow graph-node--glow-animate"
          style={{
            left: nodeX - glowSize / 2,
            top: nodeY - glowSize / 2,
            width: glowSize,
            height: glowSize,
            position: 'absolute',
            opacity: opacity * 0.5,
            filter: 'blur(8px)',
            borderRadius: '20%',
            zIndex: 1,
            pointerEvents: 'none',
            transition: 'opacity 0.2s',
          }}
        />
        <div
          className={nodeClass}
          style={{
            left: nodeX - size / 2,
            top: nodeY - size / 2,
            width: size,
            height: size,
            opacity,
            position: 'absolute',
            clipPath:
              'polygon(25% 0%, 75% 0%, 100% 50%, 75% 100%, 25% 100%, 0% 50%)',
            zIndex: 2,
            pointerEvents: 'auto',
            transition: 'opacity 0.2s',
          }}
        />
        <span className="graph-node-label" style={labelStyle}>
          {node.name}
        </span>
      </>
    );
  }

  // All other nodes: animated glowing circle
  const style: React.CSSProperties = {
    left: nodeX - size / 2,
    top: nodeY - size / 2,
    width: size,
    height: size,
    borderRadius: '50%',
    position: 'absolute',
    opacity,
    transition: 'opacity 0.2s',
  } as React.CSSProperties;

  return (
    <>
      <div
        className={nodeClass}
        onMouseEnter={() => setHovered(true)}
        onMouseLeave={() => setHovered(false)}
        onClick={onClick}
        style={style}
      />
      <span className="graph-node-label" style={labelStyle} title={node.name}>
        {node.name}
      </span>
    </>
  );
};
