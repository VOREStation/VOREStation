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
  no_retreat: number;
  extended_kin: number;
  nutrition_energy_conversion: number;
};

export const ShadekinConfig = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    stun_time,
    flicker_time,
    flicker_color,
    flicker_break_chance,
    flicker_distance,
    no_retreat,
    extended_kin,
    nutrition_energy_conversion,
  } = data;

  const isSubtle =
    flicker_time < 5 || flicker_break_chance < 5 || flicker_distance < 5;

  const windowHeight = (isSubtle ? 220 : 190) + (extended_kin ? 100 : 0);

  return (
    <Window width={300} height={windowHeight} theme="abductor">
      <Window.Content>
        <Stack fill vertical g={0}>
          {isSubtle && (
            <Stack.Item>
              <NoticeBox>Subtle Phasing, causes {stun_time} s stun.</NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item>
            <Section fill title="Light Settings">
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
          {!!extended_kin && (
            <Stack.Item>
              <Section fill title="Misc Settings">
                <LabeledList.Item label="Retreat on Death">
                  <Button.Checkbox
                    tooltip="Toggle if you wish to return to the Dark Retreat upon death!"
                    checked={!no_retreat}
                    onClick={() => act('toggle_retreat')}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Nutrition Conversion">
                  <Button.Checkbox
                    tooltip="Toggle to have dark energy and nutrition being converted into each other when full!"
                    checked={nutrition_energy_conversion}
                    onClick={() => act('toggle_nutrition')}
                  />
                </LabeledList.Item>
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
