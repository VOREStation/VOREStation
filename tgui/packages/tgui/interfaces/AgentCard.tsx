import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  entries: { name: string; value: string }[];
  electronic_warfare: BooleanLike;
};

export const AgentCard = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { entries, electronic_warfare } = data;

  return (
    <Window width={550} height={400} theme="syndicate">
      <Window.Content>
        <Section title="Info">
          <Table>
            {entries.map((a) => (
              <Table.Row key={a.name}>
                <Table.Cell>
                  <Button onClick={() => act(a.name.toLowerCase().replace(/ /g, ''))} icon="cog" />
                </Table.Cell>
                <Table.Cell>{a.name}</Table.Cell>
                <Table.Cell>{a.value}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Section title="Electronic Warfare">
          <Button.Checkbox
            checked={electronic_warfare}
            content={
              electronic_warfare
                ? 'Electronic warfare is enabled. This will prevent you from being tracked by the AI.'
                : 'Electronic warfare disabled.'
            }
            onClick={() => act('electronic_warfare')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
