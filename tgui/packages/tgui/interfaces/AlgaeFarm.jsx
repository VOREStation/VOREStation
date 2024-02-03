import { useBackend } from '../backend';
import { Box, Button, NoticeBox, LabeledList, ProgressBar, Section, Table } from '../components';
import { Window } from '../layouts';
import { capitalize } from 'common/string';

export const AlgaeFarm = (props) => {
  const { act, data } = useBackend();
  const {
    usePower,
    materials,
    last_flow_rate,
    last_power_draw,
    inputDir,
    outputDir,
    input,
    output,
    errorText,
  } = data;

  return (
    <Window width={500} height={300} resizable>
      <Window.Content>
        {errorText && (
          <NoticeBox warning>
            <Box display="inline-block" verticalAlign="middle">
              {errorText}
            </Box>
          </NoticeBox>
        )}
        <Section
          title="Status"
          buttons={
            <Button
              icon="power-off"
              content="Processing"
              selected={usePower === 2}
              onClick={() => act('toggle')}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Flow Rate">
              {last_flow_rate} L/s
            </LabeledList.Item>
            <LabeledList.Item label="Power Draw">
              {last_power_draw} W
            </LabeledList.Item>
            <LabeledList.Divider size={1} />
            {materials.map((material) => (
              <LabeledList.Item
                key={material.name}
                label={capitalize(material.display)}>
                <ProgressBar
                  width="80%"
                  value={material.qty}
                  maxValue={material.max}>
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
          </LabeledList>
          <Table mt={1}>
            <Table.Row>
              <Table.Cell>
                <Section title={'Gas Input (' + inputDir + ')'}>
                  {input ? (
                    <LabeledList>
                      <LabeledList.Item label="Total Pressure">
                        {input.pressure} kPa
                      </LabeledList.Item>
                      <LabeledList.Item label={input.name}>
                        {input.percent}% ({input.moles} moles)
                      </LabeledList.Item>
                    </LabeledList>
                  ) : (
                    <Box color="bad">No connection detected.</Box>
                  )}
                </Section>
              </Table.Cell>
              <Table.Cell>
                <Section title={'Gas Output (' + outputDir + ')'}>
                  {output ? (
                    <LabeledList>
                      <LabeledList.Item label="Total Pressure">
                        {output.pressure} kPa
                      </LabeledList.Item>
                      <LabeledList.Item label={output.name}>
                        {output.percent}% ({output.moles} moles)
                      </LabeledList.Item>
                    </LabeledList>
                  ) : (
                    <Box color="bad">No connection detected.</Box>
                  )}
                </Section>
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
