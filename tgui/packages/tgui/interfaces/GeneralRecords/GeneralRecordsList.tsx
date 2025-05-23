import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Input } from 'tgui-core/components';

import { selectRecords } from './functions';
import type { Data, record } from './types';

export const GeneralRecordsList = (props) => {
  const { act, data } = useBackend<Data>();

  const [searchText, setSearchText] = useState<string>('');

  const records: record[] = selectRecords(data.records!, searchText);
  return (
    <>
      <Box mb="0.2rem">
        <Button icon="pen" onClick={() => act('new')}>
          New Record
        </Button>
      </Box>
      <Input
        fluid
        placeholder="Search by Name, DNA, or ID"
        onInput={(e, value: string) => setSearchText(value)}
      />
      <Box mt="0.5rem">
        {records.map((record, i) => (
          <Button
            key={i}
            icon="user"
            mb="0.5rem"
            onClick={() => act('d_rec', { d_rec: record.ref })}
          >
            {record.id + ': ' + record.name}
          </Button>
        ))}
      </Box>
    </>
  );
};
