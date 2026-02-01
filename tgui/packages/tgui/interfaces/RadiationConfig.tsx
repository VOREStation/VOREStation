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
  nutrition_toggle: BooleanLike;
  current_nutrition: number;
};

export const RadiationConfig = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    radiation_color,
    glowing,
    glowtoggle,
    radiation_nutrition,
    radiation_nutrition_cap,
    nutrition_toggle,
    current_nutrition,
  } = data;

  const windowHeight =
    45 + (glowtoggle ? 100 : 0) + (nutrition_toggle ? 100 : 0);

  return (
    <Window width={255} height={windowHeight} theme="nuclear">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            {!!glowtoggle && (
              <Section fill title="Cosmetic Settings">
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
              </Section>
            )}
          </Stack.Item>
          <Stack.Item>
            {!!nutrition_toggle && (
              <Section fill title="Mechanical Settings">
                <NoticeBox danger={current_nutrition > radiation_nutrition_cap}>
                  {`Nutrition: ${current_nutrition.toFixed()} /
                  ${radiation_nutrition_cap}`}
                </NoticeBox>
                <LabeledList>
                  <LabeledList.Item label="Toggle Nutrition Gain">
                    <Button.Checkbox
                      checked={radiation_nutrition}
                      onClick={() => act('toggle_nutrition')}
                      tooltip={`Gain nutrition when toggled on, up to ${radiation_nutrition_cap}.`}
                    />
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
