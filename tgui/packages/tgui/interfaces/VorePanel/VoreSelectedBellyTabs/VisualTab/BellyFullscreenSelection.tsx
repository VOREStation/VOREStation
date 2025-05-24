import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { type BooleanLike, classes } from 'tgui-core/react';

export const BellyFullscreenSelection = (props: {
  editMode: boolean;
  belly_fullscreen: string;
  colorization_enabled: BooleanLike;
  possible_fullscreens: string[];
}) => {
  const { act } = useBackend();

  const {
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
        {Object.keys(possible_fullscreens).map((key, index) => (
          <Stack.Item key={index} basis="32%">
            <Button
              width="256px"
              height="256px"
              selected={key === belly_fullscreen}
              onClick={() =>
                act('set_attribute', { attribute: 'b_fullscreen', val: key })
              }
            >
              <Box
                className={classes([
                  colorization_enabled ? 'vore240x240' : 'fixedvore240x240',
                  key,
                ])}
                style={{
                  transform: 'translate(0%, 4%)',
                }}
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
            <Box
              className={classes([
                colorization_enabled ? 'vore240x240' : 'fixedvore240x240',
                belly_fullscreen,
              ])}
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
