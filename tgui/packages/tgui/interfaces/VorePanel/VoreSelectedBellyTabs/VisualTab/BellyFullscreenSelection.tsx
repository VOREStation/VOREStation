import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { MultiOverlayImage } from '../../VorePanelElements/VorePanelCanvas';

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
        {Object.keys(possible_fullscreens).map((key) => (
          <Stack.Item key={key} basis="32%">
            <Button
              width="256px"
              height="256px"
              selected={key === belly_fullscreen}
              onClick={() =>
                act('set_attribute', { attribute: 'b_fullscreen', val: key })
              }
            >
              <MultiOverlayImage
                overlays={
                  colorization_enabled
                    ? [
                        {
                          icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_base.dmi',
                          iconState: key,
                          color: colors[0],
                        },
                        {
                          icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer1.dmi',
                          iconState: key,
                          color: colors[1],
                        },
                        {
                          icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer2.dmi',
                          iconState: key,
                          color: colors[2],
                        },
                        {
                          icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer3.dmi',
                          iconState: key,
                          color: colors[3],
                        },
                      ]
                    : [
                        {
                          icon: 'icons/mob/screen_full_vore.dmi',
                          iconState: key,
                        },
                      ]
                }
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
              overlays={
                colorization_enabled
                  ? [
                      {
                        icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_base.dmi',
                        iconState: belly_fullscreen,
                        color: colors[0],
                      },
                      {
                        icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer1.dmi',
                        iconState: belly_fullscreen,
                        color: colors[1],
                      },
                      {
                        icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer2.dmi',
                        iconState: belly_fullscreen,
                        color: colors[2],
                      },
                      {
                        icon: 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_layer3.dmi',
                        iconState: belly_fullscreen,
                        color: colors[3],
                      },
                    ]
                  : [
                      {
                        icon: 'icons/mob/screen_full_vore.dmi',
                        iconState: belly_fullscreen,
                      },
                    ]
              }
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
