import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { getOverlays } from '../../functions';
import { MultiOverlayImage } from '../../VorePanelElements/MultiOverlayImage';

export const BellyFullscreenSelection = (props: {
  colors: string[];
  editMode: boolean;
  belly_fullscreen: string;
  colorization_enabled: BooleanLike;
  possible_fullscreens: string[];
}) => {
  const { act } = useBackend();

  const {
    colors,
    editMode,
    belly_fullscreen,
    colorization_enabled,
    possible_fullscreens,
  } = props;

  return editMode ? (
    <Section title="Belly Fullscreens Styles">
      <Stack wrap="wrap" justify="center">
        <Stack.Item basis="100%">
          <Button
            fluid
            selected={belly_fullscreen === '' || belly_fullscreen === null}
            onClick={() =>
              act('set_attribute', { attribute: 'b_fullscreen', val: null })
            }
          >
            Disabled
          </Button>
        </Stack.Item>
        {possible_fullscreens.map((fullscreen) => (
          <Stack.Item key={fullscreen} basis="32%">
            <Button
              width="256px"
              height="256px"
              selected={fullscreen === belly_fullscreen}
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_fullscreen',
                  val: fullscreen,
                })
              }
            >
              <MultiOverlayImage
                overlays={getOverlays(
                  fullscreen,
                  colors,
                  !!colorization_enabled,
                )}
                size={colorization_enabled ? 120 : 480}
                targetSize={240}
              />
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  ) : (
    <Section fill title="Belly Fullscreen">
      <Stack align="center">
        <Stack.Item grow />
        <Stack.Item>
          {belly_fullscreen ? (
            <MultiOverlayImage
              overlays={getOverlays(
                belly_fullscreen,
                colors,
                !!colorization_enabled,
              )}
              size={120}
              targetSize={240}
            />
          ) : (
            <Box>No overlay selected.</Box>
          )}
        </Stack.Item>
        <Stack.Item grow />
      </Stack>
    </Section>
  );
};
