import { Section, Stack, Table } from 'tgui-core/components';

import type { DatabaseRecord } from '../types';
import { DatabaseEntry } from './Helpers/DatabaseEntry';

export const BanSearchResults = (props: {
  database_records: DatabaseRecord[] | null;
}) => {
  const { database_records } = props;

  return (
    <Section fill scrollable>
      <Stack vertical>
        <Stack.Item grow>
          <Table>
            <Table.Row header backgroundColor="#383838">
              <Table.Cell align="center">TYPE</Table.Cell>
              <Table.Cell align="center">CKEY</Table.Cell>
              <Table.Cell align="center">IP</Table.Cell>
              <Table.Cell align="center">CID</Table.Cell>
              <Table.Cell align="center">TIME APPLIED</Table.Cell>
              <Table.Cell align="center">ADMIN</Table.Cell>
              <Table.Cell align="center">OPTIONS</Table.Cell>
            </Table.Row>
            {database_records?.map((record) => (
              <DatabaseEntry
                key={record.data_list[0]}
                databaseRecord={record}
              />
            ))}
          </Table>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
