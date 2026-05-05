import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Button,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

export const StationBoiler = (props) => {
  const { act, data } = useBackend();
  const { input, output, materials, timeleft } = data;
  return (
    <Window width={600} height={200}>
      <Window.Content>
        <Section title="Station Boiler">
          <Stack nowrap>
            <Stack.Item>
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
                  <Flex color="bad">No connection detected.</Flex>
                )}
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section title="Wood">
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
                        content="Eject"
                        onClick={() =>
                          act('ejectMaterial', {
                            mat: material.name,
                          })
                        }
                      />
                    </LabeledList.Item>
                  ))}
                  <LabeledList.Item label="Time Left">
                    <AnimatedNumber value={timeleft} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Actions">
                    <Button content="Ignite" onClick={() => act('ignite')} />
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
            <Stack.Item>
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
                  <Flex color="bad">No connection detected.</Flex>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
