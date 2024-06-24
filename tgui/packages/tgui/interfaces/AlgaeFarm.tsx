import { capitalize } from 'common/string';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';

type Data = {
  usePower: number;
  materials: {
    name: string;
    display: string;
    qty: number;
    max: number;
    percent: number;
  }[];
  last_flow_rate: number;
  last_power_draw: number;
  inputDir: string;
  outputDir: string;
  input: gas;
  output: gas;
  errorText: string | null;
};

type gas = { pressure: number; name: string; percent: number; moles: number };

export const AlgaeFarm = (props) => {
  const { act, data } = useBackend<Data>();
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
    <Window width={500} height={300}>
      <Window.Content>
        {errorText && (
          <NoticeBox warning>
            <Box inline verticalAlign="middle">
              {errorText}
            </Box>
          </NoticeBox>
        )}
        <Section
          title="Status"
          buttons={
            <Button
              icon="power-off"
              selected={usePower === 2}
              onClick={() => act('toggle')}
            >
              Processing
            </Button>
          }
        >
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
                label={capitalize(material.display)}
              >
                <ProgressBar
                  width="80%"
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
