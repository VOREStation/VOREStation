import { useCallback, useEffect, useRef, useState } from 'react';
import { getImage } from '../../PublicLibraryWiki/WikiCommon/WikiColorIcon';
import type { Overlay } from '../types';

const imageCache = new Map<string, Promise<HTMLImageElement | null>>();

function cachedGetImage(url: string) {
  if (!imageCache.has(url)) {
    imageCache.set(
      url,
      getImage(url).catch(() => null),
    );
  }
  return imageCache.get(url)!;
}

export const MultiOverlayImage = (props: {
  overlays: Overlay[];
  size: number;
  targetSize: number;
}) => {
  const { overlays, size, targetSize } = props;
  const [src, setSrc] = useState<string>('');
  const blobRef = useRef<string>('');

  const render = useCallback(
    async (canvas: OffscreenCanvas, ctx: OffscreenCanvasRenderingContext2D) => {
      ctx.clearRect(0, 0, targetSize, targetSize);
      ctx.imageSmoothingEnabled = false;

      const images = await Promise.all(
        overlays.map(async (o, i) => {
          const iconRef = o.icon ? Byond.iconRefMap?.[o.icon] : null;
          if (!iconRef) return null;
          const url = `${iconRef}?state=${o.iconState}`;
          const img = await cachedGetImage(url);
          return img;
        }),
      );

      for (let i = 0; i < overlays.length; i++) {
        const overlay = overlays[i];
        const image = images[i];
        if (!image) continue;

        ctx.globalCompositeOperation = 'source-over';
        ctx.drawImage(image, 0, 0, size, size, 0, 0, targetSize, targetSize);

        if (overlay.color) {
          const tempCanvas = new OffscreenCanvas(targetSize, targetSize);
          const tempCtx = tempCanvas.getContext('2d');
          if (!tempCtx) continue;

          tempCtx.imageSmoothingEnabled = false;
          tempCtx.drawImage(
            image,
            0,
            0,
            size,
            size,
            0,
            0,
            targetSize,
            targetSize,
          );

          tempCtx.globalCompositeOperation = 'multiply';
          tempCtx.fillStyle = overlay.color;
          tempCtx.fillRect(0, 0, targetSize, targetSize);

          tempCtx.globalCompositeOperation = 'destination-in';
          tempCtx.drawImage(
            image,
            0,
            0,
            size,
            size,
            0,
            0,
            targetSize,
            targetSize,
          );

          ctx.drawImage(tempCanvas, 0, 0);
        }
      }

      ctx.globalCompositeOperation = 'source-over';
    },
    [overlays],
  );

  const drawToBlob = useCallback(async () => {
    const offscreen = new OffscreenCanvas(targetSize, targetSize);
    const ctx = offscreen.getContext('2d');
    if (!ctx) return;

    try {
      await render(offscreen, ctx);
      const blob = await offscreen.convertToBlob();
      if (!blob) return;

      const url = URL.createObjectURL(blob);
      if (blobRef.current) URL.revokeObjectURL(blobRef.current);
      blobRef.current = url;
      setSrc(url);
    } catch (e) {
      console.error('Failed to render image', e);
    }
  }, [render]);

  useEffect(() => {
    drawToBlob();
    return () => {
      if (blobRef.current) {
        URL.revokeObjectURL(blobRef.current);
        blobRef.current = '';
      }
    };
  }, [drawToBlob]);

  return src ? (
    <img
      src={src}
      width={targetSize}
      height={targetSize}
      style={{ transform: 'translate(1%, 3%)', imageRendering: 'pixelated' }}
    />
  ) : null;
};
