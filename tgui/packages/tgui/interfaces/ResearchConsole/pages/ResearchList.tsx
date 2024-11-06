import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Table } from 'tgui/components';

import { Data } from '../data';

export const ResearchList = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section
      title="Research List"
      fill
      textAlign="center"
      buttons={
        <Button icon="print" onClick={() => act('print', { print: 1 })}>
          Print This Page
        </Button>
      }
    >
      <Table>
        {data.tech.map((thing) => (
          <Table.Row key={thing.name}>
            <Table.Cell>
              <Box color="label">{thing.name}</Box>
              <Box> - Level {thing.level}</Box>
            </Table.Cell>
            <Table.Cell>
              <Box color="label">{thing.desc}</Box>
            </Table.Cell>
            {!!data.t_disk && !data.t_disk.stored && (
              <Table.Cell>
                <Button
                  icon="download"
                  onClick={() => act('copy_tech', { copy_tech_ID: thing.id })}
                >
                  Save To Disk
                </Button>
              </Table.Cell>
            )}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
