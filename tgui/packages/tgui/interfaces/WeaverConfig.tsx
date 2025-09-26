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
    savefile_selected
  } = data;
  const windowHeight =
    (savefile_selected ? 0 : 90);

  return (
    <Window width={305} height={260+windowHeight} theme="spookyconsole">
      <Window.Content>
        <Stack vertical g={0}>
          <Stack.Item>
            <NoticeBox>Silk Reserves currently at {silk_reserve} out of {silk_max_reserve}</NoticeBox>
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
            <Section fill title="Create Objects">
              <LabeledList>
                <LabeledList.Item label="Items">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('weave_item')}
                        tooltip="Weave an item!"
                      >
                        Weave Item
                      </Button>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
                <LabeledList.Item label="Structures">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        onClick={() => act('weave_structure')}
                        tooltip="Weave a structure!"
                      >
                        Weave Structure
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
