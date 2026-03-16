import type React from 'react';
import { useEffect, useRef } from 'react';
import type { ColorUpdate } from '../types';

export function ColorPickerCanvas(props: {
  imageData: string | null;
  onPick: ColorUpdate;
  isMatrix: boolean;
}) {
  const { imageData, onPick, isMatrix } = props;
  const canvasRef = useRef<HTMLCanvasElement>(null);

  const CANVAS_WIDTH = 475;
  const CANVAS_HEIGHT = 475;

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas || !imageData) return;

    const ctx = canvas.getContext('2d');
    const img = new Image();
    img.src = `data:image/jpeg;base64,${imageData}`;

    img.onload = () => {
      canvas.width = CANVAS_WIDTH;
      canvas.height = CANVAS_HEIGHT;

      ctx?.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);

      const imgAspect = img.width / img.height;
      const canvasAspect = CANVAS_WIDTH / CANVAS_HEIGHT;

      let drawWidth = CANVAS_WIDTH;
      let drawHeight = CANVAS_HEIGHT;

      if (imgAspect > canvasAspect) {
        drawWidth = CANVAS_WIDTH;
        drawHeight = CANVAS_WIDTH / imgAspect;
      } else {
        drawHeight = CANVAS_HEIGHT;
        drawWidth = CANVAS_HEIGHT * imgAspect;
      }

      const offsetX = (CANVAS_WIDTH - drawWidth) / 2;
      const offsetY = (CANVAS_HEIGHT - drawHeight) / 2;
      if (ctx) {
        ctx.imageSmoothingEnabled = false;
        ctx.drawImage(img, offsetX, offsetY, drawWidth, drawHeight);
      }
    };
  }, [imageData]);

  const handleClick = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!isMatrix) return;
    const canvas = canvasRef.current;
    if (!canvas) return;

    const rect = canvas.getBoundingClientRect();
    const scaleX = canvas.width / rect.width;
    const scaleY = canvas.height / rect.height;

    const x = Math.floor((e.clientX - rect.left) * scaleX);
    const y = Math.floor((e.clientY - rect.top) * scaleY);

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const pixel = ctx.getImageData(x, y, 1, 1).data;
    const hex = `#${[pixel[0], pixel[1], pixel[2]]
      .map((c) => c.toString(16).padStart(2, '0'))
      .join('')}`;

    onPick(hex);
  };

  return (
    <canvas
      ref={canvasRef}
      onClick={handleClick}
      style={{
        cursor: isMatrix ? 'crosshair' : 'default',
        imageRendering: 'pixelated',
        display: 'block',
        margin: '0 auto',
      }}
      width={CANVAS_WIDTH}
      height={CANVAS_HEIGHT}
    />
  );
}
