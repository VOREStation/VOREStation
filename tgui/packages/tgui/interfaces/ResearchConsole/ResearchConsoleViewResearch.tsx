import { useBackend } from '../../backend';
import { Box, Button, Section, Table } from '../../components';
import { Data } from './types';

export const ResearchConsoleViewResearch = (props) => {
  const { act, data } = useBackend<Data>();

  const { tech } = data;

  return (
    <Section
      title="Current Research Levels"
      buttons={
        <Button icon="print" onClick={() => act('print', { print: 1 })}>
          Print This Page
        </Button>
      }
    >
      <Table>
        {tech.map((thing) => (
          <Table.Row key={thing.name}>
            <Table.Cell>
              <Box color="label">{thing.name}</Box>
              <Box> - Level {thing.level}</Box>
            </Table.Cell>
            <Table.Cell>
              <Box color="label">{thing.desc}</Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
