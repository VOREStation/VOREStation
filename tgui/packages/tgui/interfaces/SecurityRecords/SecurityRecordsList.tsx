import { useBackend } from '../../backend';
import { Box, Button, Input } from '../../components';
import { Data } from './types';

export const SecurityRecordsList = (props) => {
  const { act, data } = useBackend<Data>();
  const { records } = data;
  return (
    <>
      <Input
        fluid
        placeholder="Search by Name, DNA, or ID"
        onChange={(e, value: string) => act('search', { t1: value })}
      />
      <Box mt="0.5rem">
        {records!.map((record, i) => (
          <Button
            key={i}
            icon="user"
            mb="0.5rem"
            color={record.color}
            onClick={() => act('d_rec', { d_rec: record.ref })}
          >
            {record.id +
              ': ' +
              record.name +
              ' (Criminal Status: ' +
              record.criminal +
              ')'}
          </Button>
        ))}
      </Box>
    </>
  );
};
