import { Component, createRef } from 'react';
import { Box, Stack, Tooltip } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { PortData } from './types';

export type PortProps = {
  port: PortData;
  onPortUpdated?: (port: PortData, iconRef: HTMLSpanElement | null) => void;
  onPortLoaded?: (port: PortData, iconRef: HTMLSpanElement | null) => void;
  onPortMouseDown?: (
    port: PortData,
    iconRef: HTMLSpanElement | null,
    e: MouseEvent,
  ) => void;
  onPortMouseUp?: (
    port: PortData,
    iconRef: HTMLSpanElement | null,
    e: MouseEvent,
  ) => void;
  onPortRightClick?: (
    port: PortData,
    iconRef: HTMLSpanElement | null,
    e: MouseEvent,
  ) => void;
  color?: string;
  output?: boolean;
};

export type PortState = {
  portRef: React.RefObject<HTMLSpanElement>;
};

// eslint-disable-next-line react/prefer-stateless-function
export class Port extends Component<PortProps, PortState> {
  constructor(props) {
    super(props);

    this.state = {
      portRef: createRef(),
    };
  }

  handlePortMouseDown = (e) => {
    const { port, onPortMouseDown = () => {} } = this.props;
    onPortMouseDown(port, this.state.portRef.current, e);
  };

  handlePortMouseUp = (e) => {
    const { port, onPortMouseUp = () => {} } = this.props;
    onPortMouseUp(port, this.state.portRef.current, e);
  };

  handlePortRightClick = (e) => {
    const { port, onPortRightClick = () => {} } = this.props;
    onPortRightClick(port, this.state.portRef.current, e);
  };

  componentDidUpdate = () => {
    const { port, onPortUpdated } = this.props;
    if (onPortUpdated) {
      onPortUpdated(port, this.state.portRef.current);
    }
  };

  componentDidMount = () => {
    const { port, onPortLoaded } = this.props;
    if (onPortLoaded) {
      onPortLoaded(port, this.state.portRef.current);
    }
  };

  renderDisplayName = () => {
    const { port } = this.props;

    return <Stack.Item>{port.name}</Stack.Item>;
  };

  render() {
    const { portRef: iconRef } = this.state;
    const { port, color, output } = this.props;

    return (
      <Tooltip
        content={decodeHtmlEntities(port.type)}
        position={'bottom-start'}
      >
        <Stack align="center" justify={output ? 'flex-end' : 'flex-start'}>
          {!!output && this.renderDisplayName()}
          <Stack.Item>
            <Box
              className="ObjectComponent__Port"
              onMouseDown={this.handlePortMouseDown}
              onContextMenu={this.handlePortRightClick}
              onMouseUp={this.handlePortMouseUp}
              textAlign="center"
            >
              <svg
                style={{ width: '100%', height: '100%', position: 'absolute' }}
                viewBox="0, 0, 100, 100"
              >
                <circle
                  cx="50"
                  cy="50"
                  r="50"
                  className={`color-fill-${color}`}
                />
              </svg>
              <span ref={iconRef} className="ObjectComponent__PortPos" />
            </Box>
          </Stack.Item>
          {!output && this.renderDisplayName()}
        </Stack>
      </Tooltip>
    );
  }
}
