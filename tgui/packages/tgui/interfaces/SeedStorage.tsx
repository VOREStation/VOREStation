import { sortBy } from 'common/collections';
import { toTitleCase } from 'common/string';

import { useBackend } from '../backend';
import { Button, Collapsible, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  scanner: string[];
  seeds: seed[];
};

type seed = {
  name: string;
  uid: string;
  amount: number;
  id: number;
  traits: {
    Endurance: string;
    Yield: string;
    Production: string;
    Potency: string;
    'Repeat Harvest': string;
    'Ideal Heat': string;
    'Ideal Light': string;
    'Nutrient Consumption': string;
    'Water Consumption': string;
    notes: string;
  };
};

export const SeedStorage = (props) => {
  const { act, data } = useBackend<Data>();

  const { seeds } = data;

  const sortedSeeds = sortBy(seeds, (seed: seed) => seed.name.toLowerCase());

  return (
    <Window width={600} height={760}>
      <Window.Content scrollable>
        <Section title="Seeds">
          {sortedSeeds.map((seed) => (
            <Flex spacing={1} mt={-1} key={seed.name + seed.uid}>
              <Flex.Item basis="60%">
                <Collapsible title={toTitleCase(seed.name) + ' #' + seed.uid}>
                  <Section width="165%" title="Traits">
                    <LabeledList>
                      {Object.keys(seed.traits).map((key) => (
                        <LabeledList.Item label={toTitleCase(key)} key={key}>
                          {seed.traits[key]}
                        </LabeledList.Item>
                      ))}
                    </LabeledList>
                  </Section>
                </Collapsible>
              </Flex.Item>
              <Flex.Item mt={0.4}>{seed.amount} Remaining</Flex.Item>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="download"
                  onClick={() => act('vend', { id: seed.id })}
                >
                  Vend
                </Button>
              </Flex.Item>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="trash"
                  onClick={() => act('purge', { id: seed.id })}
                >
                  Purge
                </Button>
              </Flex.Item>
            </Flex>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
