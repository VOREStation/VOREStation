import React, { useCallback, useEffect, useState } from 'react';
import { Box, Icon } from 'tgui-core/components';

export const getImage = async (url: string): Promise<HTMLImageElement> => {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => {
      resolve(image);
    };
    image.src = url;
  });
};

// This component
export const CanvasBackedImage = (props: {
  dimension: number;
  render: (
    canvas: OffscreenCanvas,
    ctx: OffscreenCanvasRenderingContext2D,
  ) => Promise<void>;
}) => {
  const { dimension } = props;
  const [bitmap, setBitmap] = useState<string>('');

  useEffect(() => {
    const offscreenCanvas: OffscreenCanvas = new OffscreenCanvas(
      dimension,
      dimension,
    );

    const ctx = offscreenCanvas.getContext('2d');
    if (!ctx) {
      return;
    }

    setBitmap('');

    const drawImage = async () => {
      // Render
      await props.render(offscreenCanvas, ctx);

      // Convert to a blob and put in our <img> tag
      const bitmap = await offscreenCanvas.convertToBlob();
      setBitmap(URL.createObjectURL(bitmap));
    };

    drawImage();

    return () => {
      if (bitmap !== '') {
        URL.revokeObjectURL(bitmap);
      }
    };
  }, [props.render]);

  return <img src={bitmap} width={dimension} height={dimension} />;
};

export const ColorizedImage = (props: {
  icon: string | null;
  iconState: string | null;
  fillLevel?: number;
  color?: string | null;
}) => {
  const { icon, iconState, color, fillLevel = 1 } = props;

  const iconRef = icon ? Byond.iconRefMap?.[icon] : null;

  const iconSize = 64;
  const realFill = iconSize * (1 - fillLevel);

  const render = useCallback(
    async (canvas: OffscreenCanvas, ctx: OffscreenCanvasRenderingContext2D) => {
      // Pixel art please
      ctx.imageSmoothingEnabled = false;

      // Load the image from the server
      const image = await getImage(`${iconRef}?state=${iconState}`);

      // Draw the image on top
      ctx.drawImage(image, 0, 0, iconSize, iconSize);

      // Draw a square over the image with the color
      ctx.globalCompositeOperation = 'multiply';
      ctx.fillStyle = color || '#ffffff';
      ctx.fillRect(0, realFill, iconSize, iconSize);

      // Use the image as a mask
      ctx.globalCompositeOperation = 'destination-in';
      ctx.drawImage(image, 0, 0, iconSize, iconSize);

      // Colour it white for the outline
      ctx.globalCompositeOperation = 'destination-over';
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(0, 0, iconSize, iconSize);

      // Draw an outline
      const factor = 1.1;
      const scaleX = image.width * factor;
      const scaleY = image.height * factor;
      ctx.scale(factor, factor);
      ctx.globalCompositeOperation = 'destination-in';
      ctx.drawImage(
        image,
        -(scaleX - image.width) / factor,
        -(scaleY - image.height) / factor,
        iconSize,
        iconSize,
      );
    },
    [iconRef, iconState, color],
  );

  return iconRef ? (
    <CanvasBackedImage render={render} dimension={iconSize} />
  ) : (
    <Box height="64px">
      <Icon
        position="absolute"
        name="question"
        size={4}
        width="64px"
        height="64px"
      />
    </Box>
  );
};
