import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  ColorBox,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  silk_reserve: number;
  silk_max_reserve: number;
  silk_color: string | null;
  silk_production: number;
  savefile_selected: BooleanLike;
};

export const WeaverConfig = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    silk_reserve,
    silk_max_reserve,
    silk_color,
    silk_production,
    savefile_selected,
  } = data;
  const windowHeight = savefile_selected ? 0 : 90;

  return (
    <Window width={305} height={345 + windowHeight} theme="spookyconsole">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <NoticeBox>
              Silk Reserves currently at {silk_reserve} out of{' '}
              {silk_max_reserve}
            </NoticeBox>
          </Stack.Item>
          {!savefile_selected && (
            <Stack.Item>
              <NoticeBox>
                WARNING: Your current selected savefile (in Character Setup) is
                not the same as your currently loaded savefile. Please select it
                to prevent savefile corruption.
              </NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item>
            <Section fill title="Generation Settings">
              <LabeledList>
                <LabeledList.Item label="Silk Color">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('new_silk_color')}
                        tooltip="Select a color you wish for your silk to be."
                      >
                        Set Color
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <ColorBox color={silk_color || '#FFFFFF'} />
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Production">
                  <Button.Checkbox
                    tooltip="Toggle your silk production."
                    checked={silk_production}
                    onClick={() => act('toggle_silk_production')}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section fill title="Create Objects">
              <LabeledList>
                <LabeledList.Item label="Bindings">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('weave_binding')}
                        tooltip="Requires 50 silk!"
                      >
                        Weave Bindings (50)
                      </Button>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Floor">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('weave_floor')}
                        disabled={silk_reserve < 25}
                        tooltip="Requires 25 silk."
                      >
                        Weave Floor (25)
                      </Button>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Wall">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('weave_wall')}
                        disabled={silk_reserve < 100}
                        tooltip="Requires 100 silk."
                      >
                        Weave Wall (100)
                      </Button>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Nest">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('weave_nest')}
                        disabled={silk_reserve < 100}
                        tooltip="Requires 100 silk."
                      >
                        Weave Nest (100)
                      </Button>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Trap">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('weave_trap')}
                        disabled={silk_reserve < 250}
                        tooltip="Requires 250 silk."
                      >
                        Weave Trap (250)
                      </Button>
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
