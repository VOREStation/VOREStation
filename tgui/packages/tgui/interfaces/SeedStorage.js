import { useBackend } from "../backend";
import { Button, Flex, LabeledList, Section, Collapsible } from "../components";
import { Window } from "../layouts";
import { toTitleCase } from 'common/string';
import { sortBy } from 'common/collections';

export const SeedStorage = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    scanner,
    seeds,
  } = data;

  const sortedSeeds = sortBy(seed => seed.name.toLowerCase())(seeds);

  return (
    <Window width={600} height={760} resizable>
      <Window.Content scrollable>
        <Section title="Seeds">
          {sortedSeeds.map(seed => (
            <Flex spacing={1} mt={-1} key={seed.name + seed.uid}>
              <Flex.Item basis="60%">
                <Collapsible title={toTitleCase(seed.name) + " #" + seed.uid}>
                  <Section width="165%" title="Traits">
                    <LabeledList>
                      {Object.keys(seed.traits).map(key => (
                        <LabeledList.Item label={toTitleCase(key)} key={key}>
                          {seed.traits[key]}
                        </LabeledList.Item>
                      ))}
                    </LabeledList>
                  </Section>
                </Collapsible>
              </Flex.Item>
              <Flex.Item mt={0.4}>
                {seed.amount} Remaining
              </Flex.Item>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="download"
                  onClick={() => act("vend", { id: seed.id })}>
                  Vend
                </Button>
              </Flex.Item>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="trash"
                  onClick={() => act("purge", { id: seed.id })}>
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
