import { Component, createRef, RefObject, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Stack } from 'tgui-core/components';
import { clamp } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

const PX_PER_UNIT = 24;

type PaintCanvasProps = Partial<{
  onCanvasClick: (x: number, y: number) => void;
  value: string[][];
  dotsize: number;
  res: number;
  tool: Tool;
}>;

class PaintCanvas extends Component<PaintCanvasProps> {
  canvasRef: RefObject<HTMLCanvasElement>;
  mouseIsDown: boolean;
  lastSuccessfulPaint: number;
  onCVClick: (x: number, y: number) => void;
  lineStart: [number, number] | null;
  lastHovered: [number, number] | null;

  constructor(props) {
    super(props);
    this.canvasRef = createRef();
    this.onCVClick = props.onCanvasClick;
  }

  componentDidMount() {
    this.drawCanvas(this.props);
  }

  componentDidUpdate() {
    this.drawCanvas(this.props);
  }

  getLinePixels() {
    if (!this.lineStart || !this.lastHovered) {
      return;
    }

    let [x0, y0] = this.lineStart;
    let [x1, y1] = this.lastHovered;

    x0 = x0 - 1;
    x1 = x1 - 1;
    y0 = y0 - 1;
    y1 = y1 - 1;

    let dx = Math.abs(x1 - x0);
    let sx = x0 < x1 ? 1 : -1;
    let dy = -Math.abs(y1 - y0);
    let sy = y0 < y1 ? 1 : -1;
    let error = dx + dy;

    let pixels: [number, number][] = [];

    while (true) {
      pixels.push([x0, y0]);
      // grid[x0][y0] = '#000';

      if (x0 === x1 && y0 === y1) {
        break;
      }

      let e2 = error * 2;
      if (e2 >= dy) {
        error = error + dy;
        x0 = x0 + sx;
      }
      if (e2 <= dx) {
        error = error + dx;
        y0 = y0 + sy;
      }
    }

    return pixels;
  }

  drawLine(grid: string[][]) {
    let pixels = this.getLinePixels();
    if (!pixels) {
      return;
    }

    for (let [x, y] of pixels) {
      if (x < grid.length && y < grid[0].length) {
        grid[x][y] = '#000000';
      }
    }
  }

  areaFill(grid: string[][]) {
    if (!this.lastHovered) {
      return;
    }

    let [x_start, y_start] = this.lastHovered;
    x_start = clamp(x_start - 1, 0, grid.length - 1);
    y_start = clamp(y_start - 1, 0, grid[0].length - 1);

    const origPixelColor = grid[x_start][y_start];
    const inside = (x_c, y_c) => {
      if (x_c < 0 || y_c < 0 || x_c >= grid.length || y_c >= grid[0].length) {
        return false;
      }
      return grid[x_c][y_c] === origPixelColor;
    };

    let s: [number, number, number, number][] = [];
    s.push([x_start, x_start, y_start, 1]);
    s.push([x_start, x_start, y_start - 1, -1]);

    let pixels_touched: [number, number][] = [];

    while (s.length) {
      // This can't fail because of our while condition
      let [x1, x2, y, dy] = s.pop()!;

      let x = x1;
      if (inside(x, y)) {
        while (inside(x - 1, y)) {
          grid[x - 1][y] = '#000000';
          pixels_touched.push([x - 1, y]);
          x = x - 1;
        }
        if (x < x1) {
          s.push([x, x1 - 1, y - dy, -dy]);
        }
      }

      while (x1 <= x2) {
        while (inside(x1, y)) {
          grid[x1][y] = '#000000';
          pixels_touched.push([x1, y]);
          x1 = x1 + 1;
        }
        if (x1 > x) {
          s.push([x, x1 - 1, y + dy, dy]);
        }
        if (x1 - 1 > x2) {
          s.push([x2 + 1, x1 - 1, y - dy, -dy]);
        }
        x1 = x1 + 1;
        while (x1 < x2 && !inside(x1, y)) {
          x1 = x1 + 1;
        }
        x = x1;
      }
    }

    return pixels_touched;
  }

  drawCanvas(propSource: PaintCanvasProps) {
    const canvas = this.canvasRef.current!;
    const ctx = canvas.getContext('2d')!;
    const grid = JSON.parse(JSON.stringify(propSource.value));
    if (!grid) {
      return;
    }
    const x_size = grid.length;
    if (!x_size) {
      return;
    }
    const y_size = grid[0].length;
    const x_scale = Math.round(canvas.width / x_size);
    const y_scale = Math.round(canvas.height / y_size);
    ctx.save();
    ctx.scale(x_scale, y_scale);

    if (this.mouseIsDown && propSource.tool === Tool.Line) {
      this.drawLine(grid);
    } else if (propSource.tool === Tool.Fill) {
      this.areaFill(grid);
    }

    for (let x = 0; x < grid.length; x++) {
      const element = grid[x];
      for (let y = 0; y < element.length; y++) {
        const color = element[y];
        ctx.fillStyle = color;
        ctx.fillRect(x, y, 1, 1);
      }
    }
    ctx.restore();
  }

  getCoord(
    event: React.MouseEvent<HTMLCanvasElement, MouseEvent>,
  ): [number, number] | null {
    const value = this.props.value;
    if (!value) {
      return null;
    }
    const x_size = value.length;
    if (!x_size) {
      return null;
    }

    const y_size = this.props.value[0].length;
    const canvas = this.canvasRef.current!;
    const x_scale = canvas.width / x_size;
    const y_scale = canvas.height / y_size;
    const x = Math.floor(event.nativeEvent.offsetX / x_scale) + 1;
    const y = Math.floor(event.nativeEvent.offsetY / y_scale) + 1;

    return [x, y];
  }

  mouseDown(event: React.MouseEvent<HTMLCanvasElement, MouseEvent>) {
    this.mouseIsDown = true;

    let coord = this.getCoord(event);
    if (!coord) {
      return;
    }

    this.lineStart = coord;
    this.lastHovered = coord;

    if (this.props.tool === Tool.Paintbrush) {
      this.onCVClick(coord[0], coord[1]);
    } else if (this.props.tool === Tool.Fill) {
      let gridCopy = JSON.parse(JSON.stringify(this.props.value));
      let pixels_touched = this.areaFill(gridCopy);
      if (pixels_touched) {
        for (let [x, y] of pixels_touched) {
          this.onCVClick(x + 1, y + 1);
        }
      }
    }
  }

  mouseUp(event: React.MouseEvent<HTMLCanvasElement, MouseEvent>) {
    this.mouseIsDown = false;

    let coord = this.getCoord(event);
    if (!coord) {
      return;
    }

    this.lastHovered = coord;

    if (this.props.tool === Tool.Line) {
      let line = this.getLinePixels();
      if (line) {
        for (let [x, y] of line) {
          this.onCVClick(x + 1, y + 1);
        }
      }
    }
  }

  mouseMove(event: React.MouseEvent<HTMLCanvasElement, MouseEvent>) {
    const coord = this.getCoord(event);
    if (!coord) {
      return;
    }

    this.lastHovered = coord;

    let time = new Date().getTime();

    if (this.lastSuccessfulPaint + 50 > time) {
      return;
    }

    if (this.mouseIsDown && this.props.tool === Tool.Paintbrush) {
      this.onCVClick(coord[0], coord[1]);
      this.lastSuccessfulPaint = time;
    } else if (this.mouseIsDown && this.props.tool === Tool.Line) {
      // Force redraw
      this.drawCanvas(this.props);
      this.lastSuccessfulPaint = time;
    } else if (this.props.tool === Tool.Fill) {
      this.drawCanvas(this.props);
    }
  }

  render() {
    const { res = 1, value, dotsize = PX_PER_UNIT, ...rest } = this.props;
    const [width, height] = getImageSize(value);
    return (
      <canvas
        ref={this.canvasRef}
        width={width * dotsize || 300}
        height={height * dotsize || 300}
        {...rest}
        // onClick={(e) => this.clickwrapper(e)}
        onMouseDown={(e) => this.mouseDown(e)}
        onMouseMove={(e) => this.mouseMove(e)}
        onMouseUp={(e) => this.mouseUp(e)}
      >
        Canvas failed to render.
      </canvas>
    );
  }
}

const getImageSize = (value) => {
  const width = value.length;
  const height = width !== 0 ? value[0].length : 0;
  return [width, height];
};

type Data = {
  grid: string[][];
  name: string;
  finalized: BooleanLike;
};

enum Tool {
  Paintbrush,
  Line,
  Fill,
}

export const Canvas = (props) => {
  const { act, data } = useBackend<Data>();

  const [tool, setTool] = useState<Tool>(Tool.Paintbrush);

  const dotsize = PX_PER_UNIT;
  const [width, height] = getImageSize(data.grid);
  return (
    <Window
      width={Math.min(700, width * dotsize + 72)}
      height={Math.min(700, height * dotsize + 72)}
    >
      <Window.Content>
        <Stack>
          <Stack.Item basis="10%">
            <Stack vertical>
              <Stack.Item>
                <Button
                  icon="paintbrush"
                  fontSize={2}
                  onClick={() => setTool(Tool.Paintbrush)}
                  selected={tool === Tool.Paintbrush}
                  tooltip="Paintbrush"
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="grip-lines"
                  fontSize={2}
                  iconRotation={-45}
                  onClick={() => setTool(Tool.Line)}
                  selected={tool === Tool.Line}
                  tooltip="Line"
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="bucket"
                  fontSize={2}
                  onClick={() => setTool(Tool.Fill)}
                  selected={tool === Tool.Fill}
                  tooltip="Fill"
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item pr={1}>
            <PaintCanvas
              tool={tool}
              value={data.grid}
              dotsize={dotsize}
              onCanvasClick={(x, y) => act('paint', { x, y })}
            />
          </Stack.Item>
        </Stack>
        <Box textAlign="center">
          {!data.finalized && (
            <Button.Confirm onClick={() => act('finalize')}>
              Finalize
            </Button.Confirm>
          )}
          &nbsp;{data.name}
        </Box>
      </Window.Content>
    </Window>
  );
};
