import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  ColorBox,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

type Data = {
  stun_time: number;
  flicker_time: number;
  flicker_color: string | null;
  flicker_break_chance: number;
  flicker_distance: number;
};

export const ShadekinConfig = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    stun_time,
    flicker_time,
    flicker_color,
    flicker_break_chance,
    flicker_distance,
  } = data;

  const isSubtle =
    flicker_time < 5 || flicker_break_chance < 5 || flicker_distance < 5;

  return (
    <Window width={300} height={isSubtle ? 220 : 190} theme="abductor">
      <Window.Content>
        <Stack fill vertical g={0}>
          {isSubtle && (
            <Stack.Item>
              <NoticeBox>Subtle Phasing, causes {stun_time} s stun.</NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item>
            <Section fill title="Shadekin Settings">
              <LabeledList>
                <LabeledList.Item label="Flicker Count">
                  <Stack>
                    <Stack.Item>
                      <NumberInput
                        step={1}
                        minValue={2}
                        maxValue={20}
                        value={flicker_time}
                        onChange={(value) => act('adjust_time', { val: value })}
                        unit="x"
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Tooltip content="Adjust how long lights flicker when you phase in! (Min 10 Max 20 times!)">
                        <Box className="VorePanel__floatingButton">?</Box>
                      </Tooltip>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Flicker Color">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('adjust_color')}
                        tooltip="Select a color you wish the lights to flicker as (Default is #E0EFF0)"
                      >
                        Set Color
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <ColorBox color={flicker_color || '#E0EFF0'} />
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Flicker Light Break Chance">
                  <Stack>
                    <Stack.Item>
                      <NumberInput
                        step={1}
                        minValue={0}
                        maxValue={25}
                        value={flicker_break_chance}
                        onChange={(value) =>
                          act('adjust_break', { val: value })
                        }
                        unit="%"
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Tooltip content="Adjust the % chance for lights to break when you phase in! (Default 0. Min 0. Max 25)">
                        <Box className="VorePanel__floatingButton">?</Box>
                      </Tooltip>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Flicker Distance">
                  <Stack>
                    <Stack.Item>
                      <NumberInput
                        step={1}
                        minValue={4}
                        maxValue={10}
                        value={flicker_distance}
                        onChange={(value) =>
                          act('adjust_distance', { val: value })
                        }
                        unit="tiles"
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Tooltip content="Adjust the range in which lights flicker when you phase in! (Default 4. Min 4. Max 10)">
                        <Box className="VorePanel__floatingButton">?</Box>
                      </Tooltip>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
