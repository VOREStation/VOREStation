import { Component } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend, useSharedState } from 'tgui/backend';
// TODO: Replace when tgui-core is fixed https://github.com/tgstation/tgui-core/issues/25
import { InfinitePlane } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { type Connection, Connections } from '../common/Connections';
import { CircuitComponent } from './CircuitComponent';
import type { PortProps } from './Port';
import {
  ABSOLUTE_Y_OFFSET,
  type CircuitData,
  type Data,
  MOUSE_BUTTON_LEFT,
  type PortData,
  PortTypesToColor,
} from './types';

export type PlaneProps = {};

type PlaneState = {
  locations: Record<string, { x: number; y: number }>;
  selectedPort: PortData | null;
  backgroundX: number;
  backgroundY: number;
  zoom: number;
  mouseX: number;
  mouseY: number;
};

// eslint-disable-next-line react/prefer-stateless-function
export class Plane extends Component<PlaneProps, PlaneState> {
  constructor(props) {
    super(props);

    this.state = {
      locations: {},
      selectedPort: null,
      backgroundX: 50,
      backgroundY: 50,
      zoom: 1,
      mouseX: 0,
      mouseY: 0,
    };
  }

  getPosition = (dom: HTMLElement | null) => {
    let xPos = 0;
    let yPos = 0;

    while (dom) {
      xPos += dom.offsetLeft;
      yPos += dom.offsetTop;
      dom = dom.offsetParent as HTMLElement;
    }

    return {
      x: xPos,
      y: yPos + ABSOLUTE_Y_OFFSET,
    };
  };

  handlePortLocation = (port: PortData, dom: HTMLSpanElement) => {
    const { locations } = this.state;

    if (!dom) {
      return;
    }

    const lastPosition = locations[port.ref];
    const position = this.getPosition(dom);

    if (
      isNaN(position.x) ||
      isNaN(position.y) ||
      (lastPosition &&
        lastPosition.x === position.x &&
        lastPosition.y === position.y)
    ) {
      return;
    }

    locations[port.ref] = position;

    this.setState({ locations });
  };

  handleZoomChange = (newZoom) => {
    this.setState({
      zoom: newZoom,
    });
  };

  handleBackgroundMoved = (newX, newY) => {
    this.setState({
      backgroundX: newX,
      backgroundY: newY,
    });
  };

  handleDragging = (event: MouseEvent) => {
    this.setState((state) => ({
      mouseX: event.clientX - state.backgroundX,
      mouseY: event.clientY - state.backgroundY,
    }));
  };

  handlePortUp = (port: PortData, ref: HTMLDivElement, event: MouseEvent) => {
    const { act } = useBackend();
    const { selectedPort } = this.state;

    if (!selectedPort) {
      return;
    }

    this.setState({
      selectedPort: null,
    });

    // Don't actually wire a port to itself...
    if (selectedPort.ref === port.ref) {
      return;
    }

    act('wire_internal', { pin1: selectedPort.ref, pin2: port.ref });
  };

  handlePortRelease = (event: MouseEvent) => {
    window.removeEventListener('mouseup', this.handlePortRelease);

    this.setState({
      selectedPort: null,
    });

    window.removeEventListener('mousemove', this.handleDragging);
  };

  handlePortClick = (
    port: PortData,
    ref: HTMLDivElement,
    event: MouseEvent,
  ) => {
    if (this.state.selectedPort) {
      this.handlePortUp(port, ref, event);
    }

    if (event.button !== MOUSE_BUTTON_LEFT) {
      return;
    }

    event.stopPropagation();
    this.setState({
      selectedPort: port,
    });

    this.handleDragging(event);

    window.addEventListener('mousemove', this.handleDragging);
    window.addEventListener('mouseup', this.handlePortRelease);
  };

  handlePortRightClick = (
    port: PortData,
    ref: HTMLDivElement,
    event: MouseEvent,
  ) => {
    const { act } = useBackend();

    event.preventDefault();
    act('remove_all_wires', {
      pin: port.ref,
    });
  };

  render() {
    const { act, data } = useBackend<Data>();
    const { locations, selectedPort, mouseX, mouseY } = this.state;

    const connections: Connection[] = [];

    for (const circuit of data.circuits) {
      if (circuit.inputs) {
        for (const input of circuit.inputs) {
          connectionloop: for (const output of input.linked) {
            const output_port = locations[output.ref];
            for (const connection of connections) {
              if (
                connection.from === locations[input.ref] &&
                connection.to === output_port
              ) {
                continue connectionloop;
              }
            }
            connections.push({
              color: PortTypesToColor[decodeHtmlEntities(input.type)] || 'blue',
              from: output_port,
              to: locations[input.ref],
            });
          }
        }
      }
      if (circuit.activators) {
        for (const activator of circuit.activators) {
          if (activator.rawdata) {
            // input
            connectionloop: for (const output of activator.linked) {
              const output_port = locations[output.ref];
              for (const connection of connections) {
                if (
                  connection.from === locations[activator.ref] &&
                  connection.to === output_port
                ) {
                  continue connectionloop;
                }
              }
              connections.push({
                color:
                  PortTypesToColor[decodeHtmlEntities(activator.type)] ||
                  'blue',
                to: output_port,
                from: locations[activator.ref],
              });
            }
          }
        }
      }
    }

    if (selectedPort) {
      const { zoom } = this.state;
      const portLocation = locations[selectedPort.ref];
      const mouseCoords = {
        x: mouseX * Math.pow(zoom, -1),
        y: (mouseY + ABSOLUTE_Y_OFFSET) * Math.pow(zoom, -1),
      };
      connections.push({
        color:
          PortTypesToColor[decodeHtmlEntities(selectedPort.type)] || 'blue',
        from: portLocation,
        to: mouseCoords,
      });
    }

    return (
      <InfinitePlane
        width="100%"
        height="100%"
        backgroundImage={resolveAsset('grid_background.png')}
        imageWidth={900}
        onZoomChange={this.handleZoomChange}
        onBackgroundMoved={this.handleBackgroundMoved}
        initialLeft={50}
        initialTop={50}
      >
        {data.circuits.map((circuit) => (
          <Circuit
            circuit={circuit}
            key={circuit.ref}
            onPortLoaded={this.handlePortLocation}
            onPortUpdated={this.handlePortLocation}
            onPortMouseDown={this.handlePortClick}
            onPortMouseUp={this.handlePortUp}
            onPortRightClick={this.handlePortRightClick}
          />
        ))}
        <Connections connections={connections} />
      </InfinitePlane>
    );
  }
}

const Circuit = (
  props: { circuit: CircuitData } & Pick<
    PortProps,
    | 'onPortUpdated'
    | 'onPortLoaded'
    | 'onPortMouseDown'
    | 'onPortMouseUp'
    | 'onPortRightClick'
  >,
) => {
  const {
    circuit,
    onPortUpdated,
    onPortLoaded,
    onPortMouseDown,
    onPortMouseUp,
    onPortRightClick,
  } = props;

  const [pos, setPos] = useSharedState('component-pos-' + circuit.ref, {
    x: 0,
    y: 0,
  });

  return (
    <CircuitComponent
      circuit={circuit}
      gridMode
      x={pos.x}
      y={pos.y}
      onComponentMoved={(val) => setPos(val)}
      onPortUpdated={onPortUpdated}
      onPortLoaded={onPortLoaded}
      onPortMouseDown={onPortMouseDown}
      onPortMouseUp={onPortMouseUp}
      onPortRightClick={onPortRightClick}
    />
  );
};
