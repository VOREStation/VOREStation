import { Blink, Box, Icon, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { getOverlays } from '../../functions';
import { MultiOverlayImage } from '../../VorePanelElements/MultiOverlayImage';

export function BellyFullscreenPreview(props: {
  colors: string[];
  alpha: number;
  belly_fullscreen: string;
  colorization_enabled: BooleanLike;
  possible_fullscreens: string[];
  targetSize?: number;
}) {
  const {
    colors,
    alpha,
    belly_fullscreen,
    colorization_enabled,
    possible_fullscreens,
    targetSize = 240,
  } = props;

  if (!belly_fullscreen) {
    return <Box>No overlay selected.</Box>;
  }

  if (!possible_fullscreens.includes(belly_fullscreen)) {
    return (
      <Stack vertical textAlign="center">
        <Stack.Item>
          <Blink>
            <Icon color="red" name="triangle-exclamation" size={10} />
          </Blink>
        </Stack.Item>
        <Stack.Item>
          <Box color="red">
            Selected overly "{belly_fullscreen}" no longer exists!
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Box color="label">Please select a new one.</Box>
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <MultiOverlayImage
      overlays={getOverlays(belly_fullscreen, colors, !!colorization_enabled)}
      alpha={alpha}
      size={colorization_enabled ? 120 : 480}
      targetSize={targetSize}
    />
  );
}
