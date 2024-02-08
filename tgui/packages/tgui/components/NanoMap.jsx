import { Component } from 'react';
import { Box, Button, Icon, Tooltip, LabeledList, Slider } from '.';
import { useBackend } from '../backend';

const pauseEvent = (e) => {
  if (e.stopPropagation) {
    e.stopPropagation();
  }
  if (e.preventDefault) {
    e.preventDefault();
  }
  e.cancelBubble = true;
  e.returnValue = false;
  return false;
};

const zoomScale = 280;

export class NanoMap extends Component {
  constructor(props) {
    super(props);

    // Auto center based on window size
    const Xcenter = window.innerWidth / 2 - 256;
    const Ycenter = window.innerHeight / 2 - 256;

    this.state = {
      offsetX: Xcenter,
      offsetY: Ycenter,
      transform: 'none',
      dragging: false,
      originX: null,
      originY: null,
      zoom: 1,
    };

    // Dragging
    this.handleDragStart = (e) => {
      this.ref = e.target;
      this.setState({
        dragging: false,
        originX: e.screenX,
        originY: e.screenY,
      });
      document.addEventListener('mousemove', this.handleDragMove);
      document.addEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

    this.handleDragMove = (e) => {
      this.setState((prevState) => {
        const state = { ...prevState };
        const newOffsetX = e.screenX - state.originX;
        const newOffsetY = e.screenY - state.originY;
        if (prevState.dragging) {
          state.offsetX += newOffsetX;
          state.offsetY += newOffsetY;
          state.originX = e.screenX;
          state.originY = e.screenY;
        } else {
          state.dragging = true;
        }
        return state;
      });
      pauseEvent(e);
    };

    this.handleDragEnd = (e) => {
      this.setState({
        dragging: false,
        originX: null,
        originY: null,
      });
      document.removeEventListener('mousemove', this.handleDragMove);
      document.removeEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

    this.handleOnClick = (e) => {
      let byondX = e.offsetX / this.state.zoom / zoomScale;
      let byondY = 1 - e.offsetY / this.state.zoom / zoomScale; // Byond origin is bottom left, this is top left

      e.byondX = byondX;
      e.byondY = byondY;
      if (typeof this.props.onClick === 'function') {
        this.props.onClick(e);
      }
    };

    this.handleZoom = (_e, value) => {
      this.setState((state) => {
        const newZoom = Math.min(Math.max(value, 1), 8);
        let zoomDiff = (newZoom - state.zoom) * 1.5;
        state.zoom = newZoom;

        let newOffsetX = state.offsetX - 262 * zoomDiff;
        if (newOffsetX < -500) {
          newOffsetX = -500;
        }
        if (newOffsetX > 500) {
          newOffsetX = 500;
        }

        let newOffsetY = state.offsetY - 256 * zoomDiff;
        if (newOffsetY < -200) {
          newOffsetY = -200;
        }
        if (newOffsetY > 200) {
          newOffsetY = 200;
        }

        state.offsetX = newOffsetX;
        state.offsetY = newOffsetY;
        if (props.onZoom) {
          props.onZoom(state.zoom);
        }
        return state;
      });
    };
  }

  render() {
    const { config } = useBackend(this.context);
    const { dragging, offsetX, offsetY, zoom = 1 } = this.state;
    const { children } = this.props;

    const mapUrl = config.map + '_nanomap_z' + config.mapZLevel + '.png';
    // (x * zoom), x Needs to be double the turf- map size. (for virgo, 140x140)
    const mapSize = zoomScale * zoom + 'px';
    const newStyle = {
      width: mapSize,
      height: mapSize,
      'margin-top': offsetY + 'px',
      'margin-left': offsetX + 'px',
      'overflow': 'hidden',
      'position': 'relative',
      'background-image': 'url(' + mapUrl + ')',
      'background-size': 'cover',
      'background-repeat': 'no-repeat',
      'text-align': 'center',
      'cursor': dragging ? 'move' : 'auto',
    };

    return (
      <Box className="NanoMap__container">
        <Box
          style={newStyle}
          textAlign="center"
          onMouseDown={this.handleDragStart}
          onClick={this.handleOnClick}>
          <Box>{children}</Box>
        </Box>
        <NanoMapZoomer zoom={zoom} onZoom={this.handleZoom} />
      </Box>
    );
  }
}

const NanoMapMarker = (props, context) => {
  const { x, y, zoom = 1, icon, tooltip, color, onClick } = props;

  const handleOnClick = (e) => {
    pauseEvent(e);
    if (onClick) {
      onClick(e);
    }
  };

  const rx = x * 2 * zoom - zoom - 3;
  const ry = y * 2 * zoom - zoom - 3;
  return (
    <div>
      <Box
        position="absolute"
        className="NanoMap__marker"
        lineHeight="0"
        bottom={ry + 'px'}
        left={rx + 'px'}
        onMouseDown={handleOnClick}>
        <Icon name={icon} color={color} fontSize="6px" />
        <Tooltip content={tooltip} />
      </Box>
    </div>
  );
};

NanoMap.Marker = NanoMapMarker;

const NanoMapZoomer = (props) => {
  const { act, config, data } = useBackend();
  return (
    <Box className="NanoMap__zoomer">
      <LabeledList>
        <LabeledList.Item label="Zoom">
          <Slider
            minValue="1"
            maxValue="8"
            stepPixelSize="10"
            format={(v) => v + 'x'}
            value={props.zoom}
            onDrag={(e, v) => props.onZoom(e, v)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Z-Level">
          {data.map_levels
            .sort((a, b) => Number(a) - Number(b))
            .map((level) => (
              <Button
                key={level}
                selected={~~level === ~~config.mapZLevel}
                content={level}
                onClick={() => {
                  act('setZLevel', { 'mapZLevel': level });
                }}
              />
            ))}
        </LabeledList.Item>
      </LabeledList>
    </Box>
  );
};

NanoMap.Zoomer = NanoMapZoomer;
