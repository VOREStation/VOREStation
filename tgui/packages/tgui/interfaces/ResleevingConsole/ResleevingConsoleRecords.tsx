import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Stack } from 'tgui-core/components';

import { record } from './types';

export const ResleevingConsoleRecords = (props: {
  records: record[];
  actToDo: string;
}) => {
  const { act } = useBackend();
  const { records, actToDo } = props;
  if (!records.length) {
    return (
      <Stack height="100%" mt="0.5rem">
        <Stack.Item grow align="center" textAlign="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No records found.
        </Stack.Item>
      </Stack>
    );
  }
  return (
    <Box mt="0.5rem">
      {records.map((record, i) => (
        <Button
          key={i}
          icon="user"
          mb="0.5rem"
          onClick={() =>
            act(actToDo, {
              ref: record.recref,
            })
          }
        >
          {record.name}
        </Button>
      ))}
    </Box>
  );
};
