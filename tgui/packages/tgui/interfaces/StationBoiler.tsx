import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

export const StationBoiler = (props) => {
  const { act, data } = useBackend();
  const { input, output, materials, timeleft } = data;
  return (
    <Window width={320} height={340}>
      <Window.Content>
        <Section
          title="Station Boiler"
          buttons={<Button onClick={() => act('ignite')}>Ignite</Button>}
        >
          <LabeledList>
            <LabeledList.Divider size={1} />
            {materials.map((material) => (
              <LabeledList.Item
                key={material.name}
                label={capitalize(material.display)}
              >
                <ProgressBar
                  width="70%"
                  value={material.qty}
                  maxValue={material.max}
                >
                  {material.qty}/{material.max}
                </ProgressBar>
                <Button
                  ml={1}
                  onClick={() =>
                    act('ejectMaterial', {
                      mat: material.name,
                    })
                  }
                >
                  Eject
                </Button>
              </LabeledList.Item>
            ))}
            <LabeledList.Item label="Time Left">
              <AnimatedNumber value={timeleft} />
            </LabeledList.Item>
          </LabeledList>
          <Section title="Input Pipe">
            {input ? (
              <LabeledList>
                <LabeledList.Item label="Total Pressure">
                  {input.pressure} kPa
                </LabeledList.Item>
                <LabeledList.Item label="Temperature">
                  {input.temp}C
                </LabeledList.Item>
              </LabeledList>
            ) : (
              <Box color="bad">No connection detected.</Box>
            )}
          </Section>
          <Section title="Output Pipe">
            {output ? (
              <LabeledList>
                <LabeledList.Item label="Total Pressure">
                  {output.pressure} kPa
                </LabeledList.Item>
                <LabeledList.Item label="Temperature">
                  {output.temp}C
                </LabeledList.Item>
              </LabeledList>
            ) : (
              <Box color="bad">No connection detected.</Box>
            )}
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
