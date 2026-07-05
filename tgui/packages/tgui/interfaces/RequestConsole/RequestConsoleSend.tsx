import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';

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
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="envelope-open-text"
                      onClick={() => act('write', { write: dept, priority: 1 })}
                    >
                      Message
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="red"
                      icon="exclamation-triangle"
                      onClick={() => act('write', { write: dept, priority: 2 })}
                    >
                      High Priority
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            />
          )) ||
          null,
      )}
    </LabeledList>
  );
};

export const RequestConsoleSendPass = (props: { lastTab: number }) => {
  const { act } = useBackend();
  const { lastTab } = props;
  return (
    <Section>
      <Box fontSize={2} color="good">
        Message Sent Successfully
      </Box>
      <Box>
        <Button
          icon="arrow-right"
          onClick={() => act('setScreen', { setScreen: lastTab })}
        >
          Continue
        </Button>
      </Box>
    </Section>
  );
};

export const RequestConsoleSendFail = (props: { lastTab: number }) => {
  const { act } = useBackend();
  const { lastTab } = props;
  return (
    <Section>
      <Box fontSize={1.5} bold color="bad">
        An error occured. Message Not Sent.
      </Box>
      <Box>
        <Button
          icon="arrow-right"
          onClick={() => act('setScreen', { setScreen: lastTab })}
        >
          Continue
        </Button>
      </Box>
    </Section>
  );
};
