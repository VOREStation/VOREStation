import { useBackend } from 'tgui/backend';
import {
  Button,
  ColorBox,
  Dropdown,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';

import { SPRITE_ACCESSORY_COLOR_CHANNEL_NAMES } from './constants';
import type { Data } from './types';

export const AppearanceChangerColors = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    change_eye_color,
    change_skin_tone,
    change_skin_color,
    change_hair_color,
    change_facial_hair_color,
    eye_color,
    skin_color,
    hair_color,
    hair_grad,
    hair_color_grad,
    facial_hair_color,
    ears_color,
    ears2_color,
    ears_alpha,
    secondary_ears_alpha,
    tail_color,
    tail2_color,
    tail3_color,
    tail_alpha,
    wing_color,
    wing2_color,
    wing3_color,
    wing_alpha,
    ear_secondary_colors,
    hair_grads,
  } = data;

  return (
    <Section title="Colors" fill scrollable>
      <Stack vertical fill>
        {change_eye_color ? (
          <Stack.Item>
            <ColorBox color={eye_color} mr={1} />
            <Button onClick={() => act('eye_color')}>Change Eye Color</Button>
          </Stack.Item>
        ) : (
          ''
        )}
        {change_skin_tone ? (
          <Stack.Item>
            <Button onClick={() => act('skin_tone')}>Change Skin Tone</Button>
          </Stack.Item>
        ) : (
          ''
        )}
        {change_skin_color ? (
          <Stack.Item>
            <ColorBox color={skin_color} mr={1} />
            <Button onClick={() => act('skin_color')}>Change Skin Color</Button>
          </Stack.Item>
        ) : (
          ''
        )}
        {change_hair_color ? (
          <>
            <Stack.Item>
              <ColorBox color={hair_color} mr={1} />
              <Button onClick={() => act('hair_color')}>
                Change Hair Color
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <ColorBox color={hair_color_grad} mr={1} />
                  <Button onClick={() => act('hair_color_grad')}>
                    Change Hair gradiant Color
                  </Button>
                </Stack.Item>
                <Stack.Item width="30%">
                  <Dropdown
                    autoScroll={false}
                    selected={hair_grad || 'None'}
                    options={hair_grads.map((key: string) => {
                      return {
                        displayText: key,
                        value: key,
                      };
                    })}
                    onSelected={(val: string) =>
                      act('hair_grad', { picked: val })
                    }
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={ears_color} mr={1} />
              <Button onClick={() => act('ears_color')}>
                Change Ears Color (Primary)
              </Button>
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={ears2_color} mr={1} />
              <Button onClick={() => act('ears2_color')}>
                Change Ears Color (Secondary)
              </Button>
            </Stack.Item>
            <Stack.Item>
              Ears Alpha:{' '}
              <NumberInput
                step={1}
                minValue={0}
                value={ears_alpha}
                maxValue={255}
                onDrag={(val: number) => act('ears_alpha', { ears_alpha: val })}
              />
            </Stack.Item>
            {ear_secondary_colors.map((color, index) => (
              <Stack.Item key={index}>
                <ColorBox color={color} mr={1} />
                <Button
                  onClick={() =>
                    act('ears_secondary_color', { channel: index + 1 })
                  }
                >
                  Change Secondary Ears Color (
                  {SPRITE_ACCESSORY_COLOR_CHANNEL_NAMES[index]})
                </Button>
              </Stack.Item>
            ))}
            <Stack.Item>
              Horns Alpha:{' '}
              <NumberInput
                step={1}
                minValue={0}
                value={secondary_ears_alpha}
                maxValue={255}
                onDrag={(val: number) =>
                  act('secondary_ears_alpha', { secondary_ears_alpha: val })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={tail_color} mr={1} />
              <Button onClick={() => act('tail_color')}>
                Change Tail Color
              </Button>
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={tail2_color} mr={1} />
              <Button onClick={() => act('tail2_color')}>
                Change Secondary Tail Color
              </Button>
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={tail3_color} mr={1} />
              <Button onClick={() => act('tail3_color')}>
                Change Tertiary Tail Color
              </Button>
            </Stack.Item>
            <Stack.Item>
              Tail Alpha:{' '}
              <NumberInput
                step={1}
                minValue={0}
                value={tail_alpha}
                maxValue={255}
                onDrag={(val: number) => act('tail_alpha', { tail_alpha: val })}
              />
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={wing_color} mr={1} />
              <Button onClick={() => act('wing_color')}>
                Change Wing Color
              </Button>
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={wing2_color} mr={1} />
              <Button onClick={() => act('wing2_color')}>
                Change Secondary Wing Color
              </Button>
            </Stack.Item>
            <Stack.Item>
              <ColorBox color={wing3_color} mr={1} />
              <Button onClick={() => act('wing3_color')}>
                Change Tertiary Wing Color
              </Button>
            </Stack.Item>
            <Stack.Item>
              Wing Alpha:{' '}
              <NumberInput
                step={1}
                minValue={0}
                value={wing_alpha}
                maxValue={255}
                onDrag={(val: number) => act('wing_alpha', { wing_alpha: val })}
              />
            </Stack.Item>
          </>
        ) : null}
        {change_facial_hair_color ? (
          <Stack.Item>
            <ColorBox color={facial_hair_color} mr={1} />
            <Button onClick={() => act('facial_hair_color')}>
              Change Facial Hair Color
            </Button>
          </Stack.Item>
        ) : null}
      </Stack>
    </Section>
  );
};
