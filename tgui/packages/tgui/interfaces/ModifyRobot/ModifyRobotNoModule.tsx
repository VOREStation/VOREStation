import { useBackend } from '../../backend';
import {
  Button,
  Divider,
  Flex,
  NoticeBox,
  Section,
  Stack,
} from '../../components';
import { Target } from './types';

export const ModifyTobotNoModule = (props: { target: Target }) => {
  const { target } = props;
  const { act } = useBackend();

  return (
    <>
      <NoticeBox warning>
        Target has no active module. Limited options available.
      </NoticeBox>
      <Divider />
      <Button
        fluid
        color={target.crisis_override ? 'red' : 'green'}
        onClick={() => act('toggle_crisis')}
      >
        {(target.crisis_override ? 'Disable' : 'Enable') + ' Crisis Override'}
      </Button>
      <Divider />
      <Flex>
        <Flex.Item grow />
        <Flex.Item shrink>
          <Section title="Active Restrictions">
            <Stack fill>
              <Stack.Item fillPositionedParent>
                {target.active_restrictions.map((active_restriction, i) => {
                  return (
                    <Button
                      fluid
                      color="red"
                      key={i}
                      onClick={() =>
                        act('remove_restriction', {
                          rem_restriction: active_restriction,
                        })
                      }
                    >
                      {active_restriction}
                    </Button>
                  );
                })}
              </Stack.Item>
            </Stack>
          </Section>
        </Flex.Item>
        <Flex.Item shrink>
          <Section title="Possible Restrictions">
            <Stack fill>
              <Stack.Item fillPositionedParent>
                {target.possible_restrictions.map((possible_restriction, i) => {
                  return (
                    <Button
                      fluid
                      color="green"
                      key={i}
                      onClick={() =>
                        act('add_restriction', {
                          new_restriction: possible_restriction,
                        })
                      }
                    >
                      {possible_restriction}
                    </Button>
                  );
                })}
              </Stack.Item>
            </Stack>
          </Section>
        </Flex.Item>
        <Flex.Item grow />
      </Flex>
    </>
  );
};
