import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';

type Data = {
  volume_channels: { key; val: number }[];
};

export const VolumePanel = (props) => {
  const { act, data } = useBackend<Data>();

  const { volume_channels } = data;

  return (
    <Window width={550} height={600}>
      <Window.Content>
        <Section title="Volume Levels" fill scrollable>
          <LabeledList>
            {Object.keys(volume_channels).map((key) => (
              <LabeledList.Item label={key} key={key}>
                <Stack>
                  <Stack.Item grow>
                    <Slider
                      ml="1rem"
                      minValue={0}
                      maxValue={200}
                      value={volume_channels[key] * 100}
                      onChange={(e, val) =>
                        act('adjust_volume', { channel: key, vol: val / 100 })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      ml="1rem"
                      icon="undo"
                      onClick={() =>
                        act('adjust_volume', { channel: key, vol: 1 })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
