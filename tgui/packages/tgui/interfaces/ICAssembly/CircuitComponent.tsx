import { decodeHtmlEntities } from 'common/string';
import { Component } from 'react';
import { useBackend } from 'tgui/backend';
import { Box } from 'tgui/components';
import { BoxProps } from 'tgui/components/Box';
import { Button, Icon, Stack } from 'tgui-core/components';
import { shallowDiffers } from 'tgui-core/react';

import { Port, PortProps } from './Port';
import { CircuitData, PortTypesToColor as PORT_TYPES_TO_COLOR } from './types';

export type CircuitProps = {
  x: number;
  y: number;
  circuit: CircuitData;
  color?: string;
  gridMode?: boolean;
  onComponentMoved?: (newPos: { x: number; y: number }) => void;
} & BoxProps &
  Pick<
    PortProps,
    | 'onPortUpdated'
    | 'onPortLoaded'
    | 'onPortMouseDown'
    | 'onPortMouseUp'
    | 'onPortRightClick'
  >;

export type CircuitState = {
  lastMousePos: { x: number; y: number } | null;
  isDragging: boolean;
  dragPos: { x: number; y: number } | null;
  startPos: { x: number; y: number } | null;
};

// This has to be a class component to manage window state unfortunately
export class CircuitComponent extends Component<CircuitProps, CircuitState> {
  constructor(props: CircuitProps) {
    super(props);
    this.state = {
      isDragging: false,
      dragPos: null,
      startPos: null,
      lastMousePos: null,
    };
  }

  // THIS IS IMPORTANT:
  // This reduces the amount of unnecessary updates, which reduces the amount of work that has to be done
  // by the `Plane` component to keep track of where ports are located.
  shouldComponentUpdate = (
    nextProps: CircuitProps,
    nextState: CircuitState,
  ) => {
    const { inputs = [], outputs = [], activators = [] } = this.props.circuit;

    return (
      shallowDiffers(this.props, nextProps) ||
      shallowDiffers(this.state, nextState) ||
      shallowDiffers(inputs, nextProps.circuit.inputs!) ||
      shallowDiffers(outputs, nextProps.circuit.outputs!) ||
      shallowDiffers(activators, nextProps.circuit.activators!)
    );
  };

  handleStartDrag = (e: React.MouseEvent<HTMLDivElement>) => {
    const { x, y } = this.props;
    e.stopPropagation();
    this.setState({
      lastMousePos: null,
      isDragging: true,
      dragPos: { x, y },
      startPos: { x, y },
    });
    window.addEventListener('mousemove', this.handleDrag);
    window.addEventListener('mouseup', this.handleStopDrag);
  };

  handleStopDrag = (e: React.MouseEvent<HTMLDivElement> | MouseEvent) => {
    const { onComponentMoved } = this.props;
    const { dragPos } = this.state;

    if (dragPos && onComponentMoved) {
      onComponentMoved({
        x: this.roundToGrid(dragPos.x),
        y: this.roundToGrid(dragPos.y),
      });
    }

    window.removeEventListener('mousemove', this.handleDrag);
    window.removeEventListener('mouseup', this.handleStopDrag);
    this.setState({ isDragging: false });
  };

  handleDrag = (e: any) => {
    const { dragPos, isDragging, lastMousePos } = this.state;
    if (!dragPos || !isDragging) {
      return;
    }

    e.preventDefault();

    const { screenZoomX, screenZoomY, screenX, screenY } = e;
    let xPos = screenZoomX || screenX;
    let yPos = screenZoomY || screenY;

    if (lastMousePos) {
      this.setState({
        dragPos: {
          x: dragPos.x - (lastMousePos.x - xPos),
          y: dragPos.y - (lastMousePos.y - yPos),
        },
      });
    }

    this.setState({
      lastMousePos: { x: xPos, y: yPos },
    });
  };

  // Round the units to the grid (bypass if grid mode is off)
  roundToGrid = (input_value) => {
    if (!this.props.gridMode) return input_value;
    return Math.round(input_value / 10) * 10;
  };

  render() {
    const {
      x,
      y,
      circuit,
      color = 'blue',
      onPortUpdated,
      onPortLoaded,
      onPortMouseDown,
      onPortMouseUp,
      onPortRightClick,
      ...rest
    } = this.props;

    const { name, ref, inputs = [], outputs = [], activators = [] } = circuit;

    const { startPos, dragPos } = this.state;

    const { act } = useBackend();

    let [x_pos, y_pos] = [x, y];
    if (dragPos && startPos && startPos.x === x_pos && startPos.y === y_pos) {
      x_pos = this.roundToGrid(dragPos.x);
      y_pos = this.roundToGrid(dragPos.y);
    }

    return (
      <Box
        position="absolute"
        left={x_pos + 'px'}
        top={y_pos + 'px'}
        onMouseDown={this.handleStartDrag}
        onMouseUp={this.handleStopDrag}
        {...rest}
      >
        <Box
          backgroundColor={color}
          py={1}
          px={1}
          className="ObjectComponent__Titlebar"
        >
          <Stack align="center" justify="space-between">
            <Stack.Item>{name}</Stack.Item>
            <Stack.Item>
              <Button
                icon="external-link-alt"
                color="transparent"
                compact
                tooltip="View Component UI"
                tooltipPosition="bottom-end"
                onClick={() => act('open_circuit', { ref })}
              />
              <Button
                icon="info"
                color="transparent"
                compact
                tooltip={
                  <Box>
                    <Box mb={1}>
                      {
                        <div
                          // All of the descriptions are pulled from the game files
                          // eslint-disable-next-line react/no-danger
                          dangerouslySetInnerHTML={{
                            __html: circuit.extended_desc,
                          }}
                        />
                      }
                    </Box>
                    {!!circuit.power_draw_idle && (
                      <Box
                        backgroundColor="orange"
                        style={{ borderRadius: '4px' }}
                        px={1}
                      >
                        <Icon name="bolt" mr={1} />
                        Power Draw (Passive): {circuit.power_draw_idle}
                      </Box>
                    )}
                    {!!circuit.power_draw_per_use && (
                      <Box
                        backgroundColor="orange"
                        style={{ borderRadius: '4px' }}
                        px={1}
                      >
                        <Icon name="bolt" mr={1} />
                        Power Draw (Active): {circuit.power_draw_per_use}
                      </Box>
                    )}
                  </Box>
                }
                tooltipPosition="bottom-end"
              />
              {!!circuit.removable && (
                <Button
                  icon="times"
                  color="transparent"
                  compact
                  tooltip="Remove Circuit"
                  tooltipPosition="bottom-end"
                  onClick={() => act('remove_circuit', { ref })}
                />
              )}
            </Stack.Item>
          </Stack>
        </Box>
        <Box className="ObjectComponent__Content" p={1}>
          <Stack vertical>
            <Stack.Item>
              <Stack align="flex-start" justify="space-between">
                <Stack.Item>
                  <Stack vertical fill>
                    {inputs.map((port) => (
                      <Stack.Item key={port.ref}>
                        <Port
                          color={
                            PORT_TYPES_TO_COLOR[decodeHtmlEntities(port.type)]
                          }
                          port={port}
                          onPortUpdated={onPortUpdated}
                          onPortLoaded={onPortLoaded}
                          onPortMouseDown={onPortMouseDown}
                          onPortMouseUp={onPortMouseUp}
                          onPortRightClick={onPortRightClick}
                        />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
                <Stack.Item ml={5}>
                  <Stack vertical>
                    {outputs.map((port) => (
                      <Stack.Item key={port.ref}>
                        <Port
                          color={
                            PORT_TYPES_TO_COLOR[decodeHtmlEntities(port.type)]
                          }
                          output
                          port={port}
                          onPortUpdated={onPortUpdated}
                          onPortLoaded={onPortLoaded}
                          onPortMouseDown={onPortMouseDown}
                          onPortMouseUp={onPortMouseUp}
                          onPortRightClick={onPortRightClick}
                        />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item mt={inputs.length || outputs.length ? 5 : 0}>
              <Stack align="flex-start" justify="space-between">
                <Stack.Item>
                  <Stack vertical>
                    {activators
                      .filter((port) => !port.rawdata)
                      .map((port) => (
                        <Stack.Item key={port.ref}>
                          <Port
                            color={
                              PORT_TYPES_TO_COLOR[decodeHtmlEntities(port.type)]
                            }
                            output={!!port.rawdata}
                            port={port}
                            onPortUpdated={onPortUpdated}
                            onPortLoaded={onPortLoaded}
                            onPortMouseDown={onPortMouseDown}
                            onPortMouseUp={onPortMouseUp}
                            onPortRightClick={onPortRightClick}
                          />
                        </Stack.Item>
                      ))}
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack vertical>
                    {activators
                      .filter((port) => !!port.rawdata)
                      .map((port) => (
                        <Stack.Item key={port.ref}>
                          <Port
                            color={
                              PORT_TYPES_TO_COLOR[decodeHtmlEntities(port.type)]
                            }
                            output={!!port.rawdata}
                            port={port}
                            onPortUpdated={onPortUpdated}
                            onPortLoaded={onPortLoaded}
                            onPortMouseDown={onPortMouseDown}
                            onPortMouseUp={onPortMouseUp}
                            onPortRightClick={onPortRightClick}
                          />
                        </Stack.Item>
                      ))}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Box>
      </Box>
    );
  }
}
