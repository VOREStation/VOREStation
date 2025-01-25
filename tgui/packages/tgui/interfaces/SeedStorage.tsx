import { sortBy } from 'common/collections';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Collapsible,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { toTitleCase } from 'tgui-core/string';

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
            <Stack mt={-1} key={seed.name + seed.uid}>
              <Stack.Item basis="60%">
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
              </Stack.Item>
              <Stack.Item mt={0.4}>{seed.amount} Remaining</Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon="download"
                  onClick={() => act('vend', { id: seed.id })}
                >
                  Vend
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon="trash"
                  onClick={() => act('purge', { id: seed.id })}
                >
                  Purge
                </Button>
              </Stack.Item>
            </Stack>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
