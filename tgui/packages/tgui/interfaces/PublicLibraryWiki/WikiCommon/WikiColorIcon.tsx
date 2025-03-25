import { useEffect, useRef } from 'react';
import { Color } from 'tgui-core/color';
import { Box, Icon } from 'tgui-core/components';

export const ColoredIcon = (props: {
  icon: string | null;
  icon_state: string | null;
  color: string | null;
}) => {
  const { icon, icon_state, color } = props;

  const iconRef = icon ? Byond.iconRefMap?.[icon] : null;

  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    if (!iconRef) {
      return;
    }
    const canvas = canvasRef.current;
    if (!canvas) {
      return;
    }
    const context = canvas.getContext('2d');
    if (!context) {
      return;
    }

    const src = `${iconRef}?state=${icon_state}`;

    const image = document.createElement('img');
    document.body.appendChild(image);
    image.setAttribute('style', 'display:none');
    image.src = src;
    image.onload = () => {
      renderImage(image, canvas, context, color);
    };
    image.onerror = () => {
      context.fillStyle = 'red';
      context.fillText('Error', 0, 0, 64);
    };
  }, [icon, icon_state, color]);

  if (!iconRef) {
    return <Icon size={4} name="spinner" />;
  }

  return (
    <Box width={4} height={4}>
      <canvas key={icon_state} ref={canvasRef} width={64} height={64} />
    </Box>
  );
};

export const renderImage = (
  image: HTMLImageElement,
  canvas: HTMLCanvasElement,
  context: CanvasRenderingContext2D,
  color: string | null,
) => {
  context.drawImage(image, 0, 0, canvas.width, canvas.height);

  if (!color) {
    return;
  }

  const color_rgb = Color.fromHex(color);
  const imageData = context.getImageData(0, 0, canvas.width, canvas.height);

  let i = 0;
  const recolor = () => {
    while (i < imageData.data.length) {
      imageData.data[i + 0] *= color_rgb.r / 255;
      imageData.data[i + 1] *= color_rgb.g / 255;
      imageData.data[i + 2] *= color_rgb.b / 255;
      i += 4;
    }

    context.putImageData(imageData, 0, 0);
  };
  recolor();
};
