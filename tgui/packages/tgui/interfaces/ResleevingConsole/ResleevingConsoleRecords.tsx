import { useBackend } from '../../backend';
import { Box, Button, Flex, Icon } from '../../components';
import { record } from './types';

export const ResleevingConsoleRecords = (props: {
  records: record[];
  actToDo: string;
}) => {
  const { act } = useBackend();
  const { records, actToDo } = props;
  if (!records.length) {
    return (
      <Flex height="100%" mt="0.5rem">
        <Flex.Item grow="1" align="center" textAlign="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No records found.
        </Flex.Item>
      </Flex>
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
