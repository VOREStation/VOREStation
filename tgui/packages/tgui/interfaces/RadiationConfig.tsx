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
  radiation_color: string | null;
  glowing: number;
  glowtoggle: BooleanLike;
  radiation_nutrition: BooleanLike;
  radiation_nutrition_cap: number;
};

export const RadiationConfig = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    radiation_color,
    glowing,
    glowtoggle,
    radiation_nutrition,
    radiation_nutrition_cap,
  } = data;

  const windowHeight =
    125 + (glowtoggle ? 35 : 0) + (radiation_nutrition ? 35 : 0);

  return (
    <Window width={220} height={windowHeight} theme="nuclear">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section fill title="Cosmetic Settings">
              {glowtoggle && (
                <LabeledList>
                  <LabeledList.Item label="Radiation Color">
                    <Stack align="center">
                      <Stack.Item>
                        <Button
                          onClick={() => act('toggle_color')}
                          tooltip="Select a color you wish to glow when irradiated."
                        >
                          Set Color
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <ColorBox color={radiation_color || '#FFFFFF'} />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item label="Glow">
                    <Button.Checkbox
                      tooltip="Toggle if you glow when irradiated."
                      checked={glowing}
                      onClick={() => act('toggle_glow')}
                    />
                  </LabeledList.Item>
                </LabeledList>
              )}
              <Section fill title="Mechanical Settings">
                {radiation_nutrition && (
                  <LabeledList>
                    <LabeledList.Item label="Toggle Nutrition">
                      <Stack align="center">
                        <Stack.Item>
                          <Button
                            onClick={() => act('toggle_nutrition')}
                            tooltip="Toggle if you wish to gain nutrition when irradiated."
                          >
                            Nutrition Gain
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </LabeledList.Item>
                  </LabeledList>
                )}
                {radiation_nutrition && (
                  <Stack.Item>
                    <NoticeBox>
                      Nutrition is capped at {radiation_nutrition_cap}
                    </NoticeBox>
                  </Stack.Item>
                )}
              </Section>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
