import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Flex,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from 'tgui/components';

import { RankIcon } from '../common/RankIcon';
import { Target } from './types';

export const ModifyRobotNoModule = (props: { target: Target }) => {
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
        tooltip={
          (target.crisis_override ? 'Disables' : 'Enables') +
          ' combat module option for this unit!'
        }
      >
        <Flex>
          <Flex.Item>
            <Icon name="circle-radiation" size={2} />
          </Flex.Item>
          <Flex.Item grow={1}>
            {(target.crisis_override ? 'Disable' : 'Enable') +
              ' Crisis Override'}
          </Flex.Item>
        </Flex>
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
                      <Flex>
                        <Flex.Item>
                          {RankIcon({ rank: active_restriction, color: '' })}
                        </Flex.Item>
                        <Flex.Item grow={1}>{active_restriction}</Flex.Item>
                      </Flex>
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
                      <Flex>
                        <Flex.Item>
                          {RankIcon({ rank: possible_restriction, color: '' })}
                        </Flex.Item>
                        <Flex.Item grow={1}>{possible_restriction}</Flex.Item>
                      </Flex>
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
