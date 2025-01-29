/* eslint-disable react/no-danger */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Section, Stack, Tabs } from 'tgui-core/components';

type data = {
  namae: string;
  names: string[];
  descriptions: Record<string, string>[];
  categories: Record<string, string>[];
  tutorials: Record<string, string>[];
  selection: string;
};

export const TraitTutorial = (props) => {
  const { act, data } = useBackend<data>();
  return (
    <Window width={804} height={426}>
      <Window.Content scrollable>
        <Section title="Guide to Custom Traits">
          <TraitSelection />
        </Section>
      </Window.Content>
    </Window>
  );
};

export const TraitSelection = (props) => {
  const { act, data } = useBackend<data>();

  const { names, selection } = data;

  return (
    <Stack>
      <Stack.Item shrink>
        <Section title="Trait Selection">
          <Tabs vertical>
            {names.map((name) => (
              <Tabs.Tab
                key={name}
                selected={name === selection}
                onClick={() => act('select_trait', { name })}
              >
                <Box inline>{name}</Box>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow={8}>
        {selection && (
          <Section title={selection}>
            <TraitDescription name={selection} />
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

export const TraitDescription = (props) => {
  const { act, data } = useBackend<data>();

  const { name } = props;
  const { descriptions, categories, tutorials } = data;

  return (
    <Section>
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
