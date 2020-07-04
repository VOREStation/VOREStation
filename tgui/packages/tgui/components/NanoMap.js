import { Box, Icon, Tooltip } from '.';
import { Component } from 'inferno';
import { useBackend } from "../backend";

export class NanoMap extends Component {
  constructor(props) {
    super(props);

    this.state = {
      offsetX: 0,
      offsetY: 0,
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
        const state = { ... prevState };
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
    let { offsetX, offsetY } = this.state;
    const { children, zoom, reset } = this.props;
    
    if (reset) {
      this.setState({
        offsetX: 0,
        offsetY: 0,
      });
      offsetX = 0;
      offsetY = 0;
    }

    const newStyle = {
      width: 508 * zoom + 'px',
      height: 508 * zoom + 'px',
      "margin-top": offsetY + 'px',
      "margin-left": offsetX + 'px',
      "overflow": "hidden",
      "position": "relative",
      "padding": "0px",
      "background-image":
        "url("+config.map+"_nanomap_z"+config.mapZLevel+".png)",
      "background-size": "cover",
    };

    return (
      <Box className="NanoMap__container">
        <Box
          style={newStyle}
          onMouseDown={this.handleDragStart}>
          { children }
        </Box>
      </Box>
    );
  }
}

const NanoMapMarker = props => {
  const {
    x,
    y,
    zoom,
    icon,
    tooltip,
    color,
  } = props;
  return (
    <Box
      position="absolute"
      className="NanoMap__marker"
      top={((255 - y) * 2 * zoom) - 8 + 'px'}
      left={(((x - 1) * 2 * zoom)) - 6 + 'px'} >
      <Icon
        name={icon}
        color={color}
        size={0.5}
      />
      <Tooltip content={tooltip} />
    </Box>
  );
};

NanoMap.Marker = NanoMapMarker;
