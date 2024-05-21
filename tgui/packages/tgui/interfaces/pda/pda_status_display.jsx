import { useBackend } from '../../backend';
import { Box, Button, LabeledList } from '../../components';

export const pda_status_display = (props) => {
  const { act, data } = useBackend();

  const { records } = data;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Code">
          <Button
            color="transparent"
            icon="trash"
            onClick={() => act('Status', { statdisp: 'blank' })}
          >
            Clear
          </Button>
          <Button
            color="transparent"
            icon="cog"
            onClick={() => act('Status', { statdisp: 'shuttle' })}
          >
            Evac ETA
          </Button>
          <Button
            color="transparent"
            icon="cog"
            onClick={() => act('Status', { statdisp: 'message' })}
          >
            Message
          </Button>
          <Button
            color="transparent"
            icon="exclamation-triangle"
            onClick={() => act('Status', { statdisp: 'alert' })}
          >
            ALERT
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Message line 1">
          <Button
            icon="pen"
            onClick={() => act('Status', { statdisp: 'setmsg1' })}
          >
            {records.message1 + ' (set)'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Message line 2">
          <Button
            icon="pen"
            onClick={() => act('Status', { statdisp: 'setmsg2' })}
          >
            {records.message2 + ' (set)'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Box>
  );
};
