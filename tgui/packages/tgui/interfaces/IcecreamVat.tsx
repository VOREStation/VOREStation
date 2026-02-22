import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

type IceMachineData = {
  index: number;
  name: string;
  amount_left: number;
  ingredients: string[];
};

type Data = {
  current_flavor: string;
  icecrem_data: IceMachineData[];
  cone_data: IceMachineData[];
  reagent_data: { name: string; volume: number; id: string }[];
};

export const IcecreamVat = (props) => {
  const { data, act } = useBackend<Data>();

  const { current_flavor, icecrem_data, cone_data, reagent_data } = data;

  return (
    <Window width={630} height={420}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section fill title="Ice Types">
              <Table>
                <Table.Row>
                  <Table.Cell color="label" collapsing>
                    Select Ice Type
                  </Table.Cell>
                  <Table.Cell color="label" textAlign="center">
                    Scoops Left
                  </Table.Cell>
                  <Table.Cell color="label">Produce</Table.Cell>
                  <Table.Cell color="label">Ingredients</Table.Cell>
                </Table.Row>
                {icecrem_data.map((iceData) => (
                  <IceCreamEntry
                    selectable
                    key={iceData.index}
                    iceIndex={iceData.index}
                    current_flavor={current_flavor}
                    machineData={iceData}
                    type="Ice Cream"
                  />
                ))}
              </Table>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section fill title="Cone Types">
              <Table>
                <Table.Row>
                  <Table.Cell color="label" collapsing>
                    Dispense Cone Type
                  </Table.Cell>
                  <Table.Cell color="label" textAlign="center">
                    Cones Left
                  </Table.Cell>
                  <Table.Cell color="label">Produce</Table.Cell>
                  <Table.Cell color="label">Ingredients</Table.Cell>
                </Table.Row>
                {cone_data.map((coneData) => (
                  <IceCreamEntry
                    key={coneData.index}
                    iceIndex={coneData.index}
                    current_flavor={current_flavor}
                    machineData={coneData}
                    type="Cone"
                  />
                ))}
              </Table>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title="Reagents" scrollable>
              <Table collapsing>
                <Table.Row>
                  <Table.Cell>Reagent</Table.Cell>
                  <Table.Cell>Amount</Table.Cell>
                  <Table.Cell />
                </Table.Row>
                {reagent_data.map((reagent) => (
                  <Table.Row key={reagent.id}>
                    <Table.Cell color="label">{`${reagent.name}:`}</Table.Cell>
                    <Table.Cell textAlign="center">{reagent.volume}</Table.Cell>
                    <Table.Cell>
                      <Button.Confirm
                        icon="trash"
                        onClick={() => act('clear_reagent', { id: reagent.id })}
                      />
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const IceCreamEntry = (props: {
  selectable?: boolean;
  iceIndex: number;
  current_flavor: string;
  machineData: IceMachineData;
  type: string;
}) => {
  const { act } = useBackend<Data>();

  const { selectable, iceIndex, current_flavor, machineData, type } = props;
  const [productionAmount, setProductionAmount] = useState(1);

  return (
    <Table.Row>
      <Table.Cell>
        <Stack>
          <Stack.Item grow>
            <Button
              fluid
              disabled={machineData.amount_left <= 0}
              selected={selectable && machineData.name === current_flavor}
              onClick={() =>
                act('index_action', {
                  iceIndex,
                })
              }
            >
              {`${capitalize(machineData.name)} ${type}`}
            </Button>
          </Stack.Item>
        </Stack>
      </Table.Cell>
      <Table.Cell textAlign="center">{machineData.amount_left}</Table.Cell>
      <Table.Cell>
        <Stack>
          <Stack.Item>
            <NumberInput
              width="20px"
              minValue={1}
              maxValue={10}
              value={productionAmount}
              onChange={setProductionAmount}
              format={(v) => `${v} x`}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              onClick={() =>
                act('make_type', {
                  index: iceIndex,
                  amount: productionAmount,
                })
              }
            >
              Produce
            </Button>
          </Stack.Item>
        </Stack>
      </Table.Cell>
      <Table.Cell>{`${machineData.ingredients.join(', ')}`}</Table.Cell>
    </Table.Row>
  );
};
