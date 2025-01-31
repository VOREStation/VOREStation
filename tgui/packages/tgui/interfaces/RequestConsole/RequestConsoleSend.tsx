import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import { RCS_MAINMENU } from './constants';

export const RequestConsoleSendMenu = (props: {
  dept_list: string[];
  department: string;
}) => {
  const { act } = useBackend();
  const { dept_list, department } = props;
  return (
    <LabeledList>
      {dept_list.sort().map(
        (dept) =>
          (dept !== department && (
            <LabeledList.Item
              label={dept}
              buttons={
                <>
                  <Button
                    icon="envelope-open-text"
                    onClick={() => act('write', { write: dept, priority: 1 })}
                  >
                    Message
                  </Button>
                  <Button
                    icon="exclamation-triangle"
                    onClick={() => act('write', { write: dept, priority: 2 })}
                  >
                    High Priority
                  </Button>
                </>
              }
            />
          )) ||
          null,
      )}
    </LabeledList>
  );
};

export const RequestConsoleSendPass = (props) => {
  const { act, data } = useBackend();
  return (
    <Section>
      <Box fontSize={2} color="good">
        Message Sent Successfully
      </Box>
      <Box>
        <Button
          icon="arrow-right"
          onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}
        >
          Continue
        </Button>
      </Box>
    </Section>
  );
};

export const RequestConsoleSendFail = (props) => {
  const { act, data } = useBackend();
  return (
    <Section>
      <Box fontSize={1.5} bold color="bad">
        An error occured. Message Not Sent.
      </Box>
      <Box>
        <Button
          icon="arrow-right"
          onClick={() => act('setScreen', { setScreen: RCS_MAINMENU })}
        >
          Continue
        </Button>
      </Box>
    </Section>
  );
};
