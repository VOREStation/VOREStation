import { useCallback, useEffect, useRef, useState } from 'react';
import { getIconFromRefMap } from 'tgui/events/handlers/assets';
import { getImage } from '../../PublicLibraryWiki/WikiCommon/WikiColorIcon';
import type { Overlay } from '../types';

const imageCache = new Map<string, Promise<HTMLImageElement | null>>();

async function cachedGetImage(url: string) {
  const existing = imageCache.get(url);
  if (existing) return existing;

  const promise = getImage(url)
    .then((img) => {
      imageCache.set(url, Promise.resolve(img));
      return img;
    })
    .catch(() => {
      imageCache.delete(url);
      return null;
    });

  imageCache.set(url, promise);
  return promise;
}

export const MultiOverlayImage = (props: {
  overlays: Overlay[];
  size: number;
  targetSize: number;
  alpha?: number;
  gallery?: boolean;
}) => {
  const { overlays, size, targetSize, alpha, gallery } = props;

  const [src, setSrc] = useState<string | null>(null);
  const blobRef = useRef<string>('');
  const lastOverlayKeyRef = useRef<string>('');

  const mainCanvasRef = useRef<OffscreenCanvas | null>(null);
  const mainCtxRef = useRef<OffscreenCanvasRenderingContext2D | null>(null);

  const tempCanvasRef = useRef<OffscreenCanvas | null>(null);
  const tempCtxRef = useRef<OffscreenCanvasRenderingContext2D | null>(null);

  const drawToBlob = useCallback(async () => {
    const overlayKey = overlays
      .map((o) => `${o.icon}:${o.iconState}:${o.color ?? ''}`)
      .join('|');

    if (overlayKey === lastOverlayKeyRef.current) return;
    lastOverlayKeyRef.current = overlayKey;

    const images = await Promise.all(
      overlays.map(async (o) => {
        if (!o.icon) return null;
        const iconRef = getIconFromRefMap(o.icon);
        if (!iconRef) return null;
        return cachedGetImage(`${iconRef}?state=${o.iconState}`);
      }),
    );

    if (images.some((img, i) => overlays[i].icon && !img)) return;

    if (!mainCanvasRef.current)
      mainCanvasRef.current = new OffscreenCanvas(targetSize, targetSize);
    if (!mainCtxRef.current)
      mainCtxRef.current = mainCanvasRef.current.getContext('2d')!;
    if (!tempCanvasRef.current)
      tempCanvasRef.current = new OffscreenCanvas(targetSize, targetSize);
    if (!tempCtxRef.current)
      tempCtxRef.current = tempCanvasRef.current.getContext('2d')!;

    const ctx = mainCtxRef.current!;
    const tempCtx = tempCtxRef.current!;
    const tempCanvas = tempCanvasRef.current;

    ctx.clearRect(0, 0, targetSize, targetSize);
    ctx.imageSmoothingEnabled = true;

    for (let i = 0; i < overlays.length; i++) {
      const overlay = overlays[i];
      const image = images[i];
      if (!image) continue;

      ctx.globalCompositeOperation = 'source-over';
      ctx.drawImage(image, 0, 0, size, size, 0, 0, targetSize, targetSize);

      if (overlay.color) {
        tempCtx.clearRect(0, 0, targetSize, targetSize);
        tempCtx.imageSmoothingEnabled = true;

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

        tempCtx.globalCompositeOperation = 'source-over';
        ctx.drawImage(tempCanvas, 0, 0);
      }
    }

    const blob = await mainCanvasRef.current.convertToBlob();
    if (!blob) return;

    const url = URL.createObjectURL(blob);

    if (blobRef.current) URL.revokeObjectURL(blobRef.current);
    blobRef.current = url;
    setSrc(url);
  }, [overlays]);

  useEffect(() => {
    drawToBlob();
    return () => {
      if (blobRef.current) URL.revokeObjectURL(blobRef.current);
      blobRef.current = '';
    };
  }, [drawToBlob]);

  return src ? (
    <img
      src={src}
      width={targetSize}
      height={targetSize}
      style={{
        opacity: (alpha ?? 255) / 255,
        transform: gallery ? 'translate(1%, 3%)' : undefined,
      }}
      draggable={false}
    />
  ) : null;
};
