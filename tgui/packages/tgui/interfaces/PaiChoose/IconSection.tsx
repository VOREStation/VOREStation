import { useBackend } from 'tgui/backend';
import { Box, Button, Divider, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { PreferenceEditColor } from '../PreferencesMenu/elements/ColorInput';
import type { Data } from './types';

export const IconSection = (props) => {
  const { act, data } = useBackend<Data>();
  const { sprite_datum_class, sprite_datum_size, selected_chassis, pai_color } =
    data;

  return (
    <Section
      title="Sprite"
      fill
      buttons={
        <Button disabled={!selected_chassis} onClick={() => act('confirm')}>
          Confirm
        </Button>
      }
    >
      <Stack.Item>
        <Stack>
          <Stack.Item color="label">Color:</Stack.Item>
          <Stack.Item>
            <PreferenceEditColor
              onClose={(value) => act('change_color', { color: value })}
              tooltip="Choose your pAI's default glow colour."
              back_color={pai_color}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Divider />
      {!!sprite_datum_class && !!sprite_datum_size && (
        <>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box
                  className={classes([
                    sprite_datum_size,
                    `${sprite_datum_class}N`,
                  ])}
                />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box
                  className={classes([
                    sprite_datum_size,
                    `${sprite_datum_class}S`,
                  ])}
                />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box
                  className={classes([
                    sprite_datum_size,
                    `${sprite_datum_class}W`,
                  ])}
                />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box
                  className={classes([
                    sprite_datum_size,
                    `${sprite_datum_class}E`,
                  ])}
                />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
        </>
      )}
    </Section>
  );
};
