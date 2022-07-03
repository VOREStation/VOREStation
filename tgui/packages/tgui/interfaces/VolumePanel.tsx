import { useBackend } from '../backend';
import { Button, LabeledList, Slider, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  volume_channels: { key; val: number }[];
};

export const VolumePanel = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { volume_channels } = data;

  return (
    <Window width={350} height={600}>
      <Window.Content>
        <Section title="Volume Levels">
          <LabeledList>
            {Object.keys(volume_channels).map((key) => (
              <LabeledList.Item label={key} key={key}>
                <Slider
                  width="88%"
                  minValue={0}
                  maxValue={200}
                  value={volume_channels[key] * 100}
                  onChange={(e, val) => act('adjust_volume', { channel: key, vol: val / 100 })}
                />
                <Button ml={1} icon="undo" onClick={() => act('adjust_volume', { channel: key, vol: 1 })} />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
