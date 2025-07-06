import React, { useEffect, useRef, useState } from 'react';
import { CSS_COLORS } from 'tgui/constants';
import { classes } from 'tgui-core/react';

const SVG_CURVE_INTENSITY = 64;

export enum ConnectionStyle {
  CURVE = 'curve',
  SUBWAY = 'subway',
  SUBWAY_SHARP = 'subway sharp',
  DIRECT = 'direct',
}

export type Position = {
  x: number;
  y: number;
};

export type Connection = {
  // X, Y starting point
  from: Position;
  // X, Y ending point
  to: Position;
  // Color of the line, defaults to blue
  color?: string;
  // Type of line - Curvy or Straight / angled, defaults to curvy
  style?: ConnectionStyle;
  // Optional: the ref of what element this connection is sourced
  ref?: string;
  // Optional: Used to group some connections together
  index?: number;

  // how quick it goes from start to end
  packetDurationMs: any;

  // how often a new packet is spawned
  // if this is not set, no packets will be spawned
  // if this is set, packetDurationMs must also be set
  packetFrequencyMs: any;

  // Size of the packet
  packetSize: number;

  // Color of the packet, defaults to cyan
  packetColor: string | undefined;
};

export const Connections = (props: {
  connections: Connection[];
  zLayer?: number;
  lineWidth?: number;
}) => {
  const { connections, zLayer = -1, lineWidth = '2px' } = props;

  const isColorClass = (str) => {
    if (typeof str === 'string') {
      return CSS_COLORS.includes(str as any);
    }
  };

  // --- PACKET ANIMATION ---
  const [packets, setPackets] = useState<{ [key: number]: { t: number }[] }>(
    {},
  );
  const lastUpdate = useRef(Date.now());

  useEffect(() => {
    let running = true;
    function tick() {
      const now = Date.now();
      setPackets((prev) => {
        const updated = { ...prev };
        props.connections.forEach((conn, idx) => {
          if (!conn.packetDurationMs || !conn.packetFrequencyMs) return;
          if (!updated[idx]) updated[idx] = [];
          // Spawn new packet if needed
          if (
            updated[idx].length === 0 ||
            now - lastUpdate.current > conn.packetFrequencyMs
          ) {
            updated[idx].push({ t: 0 });
            lastUpdate.current = now;
          }
          // Advance all packets
          updated[idx] = updated[idx]
            .map((p) => ({
              t: p.t + (now - lastUpdate.current) / conn.packetDurationMs,
            }))
            .filter((p) => p.t < 1.0);
        });
        return updated;
      });
      if (running) requestAnimationFrame(tick);
    }
    tick();
    return () => {
      running = false;
    };
  }, [props.connections]);

  return (
    <svg
      width="100%"
      height="100%"
      style={{
        position: 'absolute',
        pointerEvents: 'none',
        zIndex: zLayer,
        overflow: 'visible',
      }}
    >
      {connections.map((val, index) => {
        const from = val.from;
        const to = val.to;
        if (!to || !from) {
          return;
        }

        val.color = val.color || 'blue';
        val.style = val.style || ConnectionStyle.CURVE;

        // Starting point
        let path = `M ${from.x} ${from.y}`;

        switch (val.style) {
          case ConnectionStyle.CURVE: {
            path += `C ${from.x + SVG_CURVE_INTENSITY}, ${from.y},`;
            path += `${to.x - SVG_CURVE_INTENSITY}, ${to.y},`;
            path += `${to.x}, ${to.y}`;
            break;
          }
          case ConnectionStyle.SUBWAY: {
            const yDiff = Math.abs(from.y - (to.y - 16));
            path += `L ${to.x - yDiff} ${from.y}`;
            path += `L ${to.x - 16} ${to.y}`;
            path += `L ${to.x} ${to.y}`;
            break;
          }
          case ConnectionStyle.SUBWAY_SHARP: {
            let offset = 16;
            if (val.index !== undefined) {
              offset = 8 * (val.index % 32) + 32;
            }
            const yDiff = Math.abs(to.y - from.y);
            path += `L ${Math.max(from.x + offset, to.x - offset)} ${from.y}`;
            path += `L ${Math.max(from.x + offset, to.x - offset)} ${to.y}`;
            path += `L ${to.x} ${to.y}`;
            break;
          }
          case ConnectionStyle.DIRECT: {
            path += `L ${to.x} ${to.y}`;
            break;
          }
        }

        return (
          <path
            className={classes([
              isColorClass(val.color) && `color-stroke-${val.color}`,
            ])}
            stroke={(!isColorClass(val.color) && val.color) || undefined}
            key={index}
            d={path}
            fill="transparent"
            stroke-width={lineWidth}
          />
        );
      })}
      {/* Packets. this only goes from A to B directly, can't be assed atm */}
      {props.connections.map((conn, idx) => {
        const packetDurationMs = conn.packetDurationMs ?? 2000;
        const packetFrequencyMs = conn.packetFrequencyMs ?? 800;
        const packetSize = conn.packetSize ?? 4;
        const packetColor = conn.packetColor || conn.color || 'cyan';

        if (!packetDurationMs || !packetFrequencyMs) return null;
        const from = conn.from,
          to = conn.to;
        const ps = packets[idx] || [];
        return ps.map((p, i) => {
          const x = from.x + (to.x - from.x) * p.t;
          const y = from.y + (to.y - from.y) * p.t;
          return (
            <circle
              key={i}
              className="connection-packet"
              cx={x}
              cy={y}
              r={packetSize}
              fill={packetColor}
              style={
                {
                  pointerEvents: 'none',
                  '--packet-glow': packetColor,
                } as React.CSSProperties
              }
            />
          );
        });
      })}
    </svg>
  );
};
