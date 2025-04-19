import React, {
  type PropsWithChildren,
  type ReactNode,
  useCallback,
  useEffect,
  useState,
} from 'react';
import { Button, ColorBox, ImageButton, Stack } from 'tgui-core/components';

export const getImage = async (url: string): Promise<HTMLImageElement> => {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => {
      resolve(image);
    };
    image.onerror = (error) => {
      reject(error);
    };
    image.src = url;
  });
};

// This component
export const CanvasBackedImage = (props: {
  render: (
    canvas: OffscreenCanvas,
    ctx: OffscreenCanvasRenderingContext2D,
  ) => Promise<void>;
}) => {
  const [bitmap, setBitmap] = useState<string>('');

  useEffect(() => {
    const offscreenCanvas: OffscreenCanvas = new OffscreenCanvas(64, 64);

    const ctx = offscreenCanvas.getContext('2d');
    if (!ctx) {
      return;
    }

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

  return <img src={bitmap} width={64} height={64} />;
};

export const drawColorizedIconToOffscreenCanvas = async (
  color: string,
  icon: string,
  icon_state: string,
  dir?: string,
): Promise<OffscreenCanvas | null> => {
  const canvas = new OffscreenCanvas(64, 64);
  const ctx = canvas.getContext('2d');
  if (!ctx) {
    return null;
  }

  ctx.imageSmoothingEnabled = false;

  let image;
  try {
    image = await getImage(
      icon + '?state=' + icon_state + '&dir=' + (dir || '2'),
    );
  } catch (e) {
    return null;
  }

  ctx.drawImage(image, 0, 0, 64, 64);

  // Draw a square over the image with the color
  ctx.globalCompositeOperation = 'multiply';
  ctx.fillStyle = color || '#ffffff';
  ctx.fillRect(0, 0, 64, 64);

  // Use the image as a mask
  ctx.globalCompositeOperation = 'destination-in';
  ctx.drawImage(image, 0, 0, 64, 64);

  return canvas;
};

export const ColorizedImage = (props: {
  iconRef: string;
  iconState: string;
  preRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
  postRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
  color?: string | null;
  dir?: string;
}) => {
  const { iconRef, iconState, color, dir, preRender, postRender } = props;

  const render = useCallback(
    async (canvas: OffscreenCanvas, ctx: OffscreenCanvasRenderingContext2D) => {
      // Pixel art please
      ctx.imageSmoothingEnabled = false;

      if (preRender) await preRender(ctx);

      const finalDir = dir || '2';

      // Load the image from the server
      let image;
      try {
        image = await getImage(
          `${iconRef}?state=${iconState}&dir=${finalDir}&frame=1`,
        );
      } catch (e) {
        ctx.fillStyle = '#ff0000';
        ctx.fillRect(0, 0, 64, 64);
        return;
      }

      // Draw the image to the canvas
      ctx.drawImage(image, 0, 0, 64, 64);

      // Draw a square over the image with the color
      ctx.globalCompositeOperation = 'multiply';
      ctx.fillStyle = color || '#ffffff';
      ctx.fillRect(0, 0, 64, 64);

      // Use the image as a mask
      ctx.globalCompositeOperation = 'destination-in';
      ctx.drawImage(image, 0, 0, 64, 64);

      // Color background white
      // ctx.globalCompositeOperation = 'source-out';
      // ctx.fillStyle = '#ffffff';
      // ctx.fillRect(0, 0, 64, 64);

      if (postRender) await postRender(ctx);
    },
    [iconRef, iconState, color, preRender, postRender, dir],
  );

  return <CanvasBackedImage render={render} />;
};

export const CustomImageButton = (
  props: PropsWithChildren<{
    image: ReactNode;
    tooltip?: string;
    selected?: boolean;
    onClick: () => void;
    buttons?: ReactNode;
  }>,
) => {
  return (
    <ImageButton
      dmIcon="not_a_real_icon.dmi"
      dmIconState="equally_fake_icon_state"
      dmFallback={props.image}
      onClick={props.onClick}
      tooltip={props.tooltip}
      selected={props.selected}
      buttons={props.buttons}
      verticalAlign="top"
    >
      {props.children}
    </ImageButton>
  );
};

export const ColorizedImageButton = (
  props: PropsWithChildren<{
    iconRef: string;
    iconState: string;
    color?: string | null;
    dir?: string;
    onClick: () => void;
    preRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
    postRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
    selected?: boolean;
    tooltip?: string;
    buttons?: ReactNode;
  }>,
) => {
  const {
    iconRef,
    iconState,
    color,
    dir,
    onClick,
    selected,
    preRender,
    postRender,
  } = props;

  return (
    <CustomImageButton
      image={
        <ColorizedImage
          iconRef={iconRef}
          iconState={iconState}
          color={color}
          dir={dir}
          preRender={preRender}
          postRender={postRender}
        />
      }
      onClick={onClick}
      selected={selected}
      tooltip={props.tooltip}
      buttons={props.buttons}
    >
      {props.children}
    </CustomImageButton>
  );
};

export enum ColorType {
  First,
  Second,
  Third,
  Alpha,
}

export const ColorPicker = (props: {
  onClick: (type: ColorType) => void;
  color_one?: string | null;
  color_two?: string | null;
  color_three?: string | null;
  alpha?: number;
}) => {
  const { onClick, color_one, color_two, color_three, alpha } = props;

  return (
    <Stack>
      <Stack.Item>
        <Button onClick={() => onClick(ColorType.First)}>
          First Color: <ColorBox color={color_one} />
        </Button>
      </Stack.Item>
      {!!color_two && (
        <Stack.Item>
          <Button onClick={() => onClick(ColorType.Second)}>
            Second Color: <ColorBox color={color_two} />
          </Button>
        </Stack.Item>
      )}
      {!!color_three && (
        <Stack.Item>
          <Button onClick={() => onClick(ColorType.Third)}>
            Third Color: <ColorBox color={color_three} />
          </Button>
        </Stack.Item>
      )}
      {alpha !== undefined && (
        <Stack.Item>
          <Button onClick={() => onClick(ColorType.Alpha)}>
            Alpha: {alpha}
          </Button>
        </Stack.Item>
      )}
    </Stack>
  );
};
