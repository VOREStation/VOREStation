import { Box, Icon, Tooltip } from '.';
import { Component } from 'inferno';
import { useBackend } from "../backend";
import { resolveAsset } from '../assets';
import { logger } from '../logging';

export class NanoMap extends Component {
  constructor(props) {
    super(props);

    // Auto center based on window size
    this.state = {
      offsetX: 0,
      offsetY: 0,
      transform: 'none',
      dragging: false,
      originX: null,
      originY: null,
    };

    this.handleDragStart = e => {
      document.body.style['pointer-events'] = 'none';
      this.ref = e.target;
      this.setState({
        dragging: false,
        originX: e.screenX,
        originY: e.screenY,
      });
      this.timer = setTimeout(() => {
        this.setState({
          dragging: true,
        });
      }, 250);
      document.addEventListener('mousemove', this.handleDragMove);
      document.addEventListener('mouseup', this.handleDragEnd);
    };

    this.handleDragMove = e => {
      this.setState(prevState => {
        const state = { ...prevState };
        const newOffsetX = e.screenX - state.originX;
        const newOffsetY = e.screenY - state.originY;
        if (prevState.dragging) {
          state.offsetX += (newOffsetX / this.props.zoom);
          state.offsetY += (newOffsetY / this.props.zoom);
          state.originX = e.screenX;
          state.originY = e.screenY;
        } else {
          state.dragging = true;
        }
        return state;
      });
    };

    this.handleDragEnd = e => {
      document.body.style['pointer-events'] = 'auto';
      clearTimeout(this.timer);
      this.setState({
        dragging: false,
        originX: null,
        originY: null,
      });
      document.removeEventListener('mousemove', this.handleDragMove);
      document.removeEventListener('mouseup', this.handleDragEnd);
    };
  }

  render() {
    const { config } = useBackend(this.context);
    const { offsetX, offsetY } = this.state;
    const { children, zoom, reset } = this.props;
    
    let matrix 
      = `matrix(${zoom}, 0, 0, ${zoom}, ${offsetX * zoom}, ${offsetY * zoom})`;

    const newStyle = {
      width: '560px',
      height: '560px',
      "overflow": "hidden",
      "position": "relative",
      "padding": "0px",
      "background-image":
        "url("+config.map+"_nanomap_z"+config.mapZLevel+".png)",
      "background-size": "cover",
      "text-align": "center",
      "transform": matrix,
    };

    return (
      <Box className="NanoMap__container">
        <Box
          style={newStyle}
          textAlign="center"
          onMouseDown={this.handleDragStart}>
          <Box>
            {children}
          </Box>
        </Box>
      </Box>
    );
  }
}

const NanoMapMarker = (props, context) => {
  const {
    x,
    y,
    zoom,
    icon,
    tooltip,
    color,
    onClick,
  } = props;
  const rx = (x * 4) - 5;
  const ry = (y * 4) - 4;

  return (
    <Box
      position="absolute"
      className="NanoMap__marker"
      lineHeight="0"
      bottom={ry + 'px'}
      left={rx + 'px'}
      onMouseDown={onClick} >
      <Icon
        name={icon}
        color={color}
        fontSize="4px"
      />
      <Tooltip content={tooltip} scale={zoom} />
    </Box>
  );
};

NanoMap.Marker = NanoMapMarker;
