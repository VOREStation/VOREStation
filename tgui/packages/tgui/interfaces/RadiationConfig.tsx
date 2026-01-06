import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  ColorBox,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

type Data = {
  radiation_color: string | null;
  glowing: number;
};

export const RadiationConfig = (props) => {
  const { act, data } = useBackend<Data>();

  const { radiation_color, glowing } = data;
  return (
    <Window width={220} height={125} theme="nuclear">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
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
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
