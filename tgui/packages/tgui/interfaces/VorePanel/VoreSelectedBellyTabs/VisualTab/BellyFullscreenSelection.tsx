import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { getOverlays } from '../../functions';
import { MultiOverlayImage } from '../../VorePanelElements/MultiOverlayImage';
import { BellyFullscreenPreview } from './BellyFullscreenPreview';

export const BellyFullscreenSelection = (props: {
  colors: string[];
  liveColors: string[] | null;
  alpha: number;
  editMode: boolean;
  belly_fullscreen: string;
  colorization_enabled: BooleanLike;
  possible_fullscreens: string[];
}) => {
  const { act } = useBackend();

  const {
    colors,
    liveColors,
    alpha,
    editMode,
    belly_fullscreen,
    colorization_enabled,
    possible_fullscreens,
  } = props;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section fill title="Belly Fullscreen">
          <Stack align="center">
            <Stack.Item grow />
            <Stack.Item>
              <BellyFullscreenPreview
                colors={editMode ? (liveColors ?? colors) : colors}
                alpha={alpha}
                belly_fullscreen={belly_fullscreen}
                colorization_enabled={colorization_enabled}
                possible_fullscreens={possible_fullscreens}
                targetSize={360}
              />
            </Stack.Item>
            <Stack.Item grow />
          </Stack>
        </Section>
      </Stack.Item>
      {editMode && (
        <Stack.Item>
          <Section title="Belly Fullscreens Styles">
            <Stack wrap="wrap" justify="center">
              <Stack.Item basis="100%">
                <Button
                  fluid
                  selected={
                    belly_fullscreen === '' || belly_fullscreen === null
                  }
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_fullscreen',
                      val: null,
                    })
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
                      gallery
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
        </Stack.Item>
      )}
    </Stack>
  );
};
