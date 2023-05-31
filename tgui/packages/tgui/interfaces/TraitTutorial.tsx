/* eslint-disable react/no-danger */
import { useBackend } from '../backend';
import { Flex, Tabs, Section, Box, Divider } from '../components';
import { Window } from '../layouts';

type data = {
  namae: string;
  names: string[];
  descriptions: { key: string; val: string }[];
  categories: { key: string; val: string }[];
  tutorials: { key: string; val: string }[];
  selection: string;
};

export const TraitTutorial = (props, context) => {
  const { act, data } = useBackend<data>(context);
  return (
    <Window width={804} height={426} scrollable>
      <Window.Content scrollable>
        <Section title="Guide to Custom Traits" scrollable>
          <TraitSelection />
        </Section>
      </Window.Content>
    </Window>
  );
};

export const TraitSelection = (props, context) => {
  const { act, data } = useBackend<data>(context);

  const { names, selection } = data;

  return (
    <Flex scrollable>
      <Flex.Item shrink scrollable>
        <Section title="Trait Selection" scrollable>
          <Tabs vertical scrollable>
            {names.map((name) => (
              <Tabs.Tab
                key={name}
                selected={name === selection}
                onClick={() => act('select_trait', { name })}>
                <Box inline>{name}</Box>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Flex.Item>
      <Flex.Item grow={2}>
        <Divider vertical />
      </Flex.Item>
      <Flex.Item grow={8} scrollable>
        {selection && (
          <Section title={selection} scrollable>
            <TraitDescription name={selection} />
          </Section>
        )}
      </Flex.Item>
    </Flex>
  );
};

export const TraitDescription = (props, context) => {
  const { act, data } = useBackend<data>(context);

  const { name } = props;
  const { descriptions, categories, tutorials } = data;

  return (
    <Section scrollable flexWrap>
      <b>Name:</b> {name}
      <br />
      <b>Category:</b> {categories[name]}
      <br />
      <b>Description:</b> {descriptions[name]}
      <br />
      <b>Details & How to Use:</b>
      <br />
      <br />
      <div
        dangerouslySetInnerHTML={{
          __html: tutorials[name] as unknown as string,
        }}
      />
    </Section>
  );
};
