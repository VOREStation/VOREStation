import { useBackend } from '../backend';
import { LabeledList, Section, Slider } from '../components';
import { Window } from '../layouts';
import { PortableBasicInfo } from './common/PortableAtmos';

type Data = {
  rate: number;
  minrate: number;
  maxrate: number;
};

export const PortableScrubber = (props) => {
  const { act, data } = useBackend<Data>();

  const { rate, minrate, maxrate } = data;

  return (
    <Window width={320} height={350}>
      <Window.Content>
        <PortableBasicInfo />
        <Section title="Power Regulator">
          <LabeledList>
            <LabeledList.Item label="Volume Rate">
              <Slider
                mt="0.4em"
                animated
                minValue={minrate}
                maxValue={maxrate}
                value={rate}
                unit="L/s"
                onChange={(e, val) => act('volume_adj', { vol: val })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
