import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

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
        <Stack>
          <Stack.Item>
            <Icon name="circle-radiation" size={2} />
          </Stack.Item>
          <Stack.Item grow>
            {(target.crisis_override ? 'Disable' : 'Enable') +
              ' Crisis Override'}
          </Stack.Item>
        </Stack>
      </Button>
      <Divider />
      <Stack>
        <Stack.Item grow />
        <Stack.Item shrink>
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
                      <Stack>
                        <Stack.Item>
                          {RankIcon({ rank: active_restriction, color: '' })}
                        </Stack.Item>
                        <Stack.Item grow>{active_restriction}</Stack.Item>
                      </Stack>
                    </Button>
                  );
                })}
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item shrink>
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
                      <Stack>
                        <Stack.Item>
                          {RankIcon({ rank: possible_restriction, color: '' })}
                        </Stack.Item>
                        <Stack.Item grow>{possible_restriction}</Stack.Item>
                      </Stack>
                    </Button>
                  );
                })}
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item grow />
      </Stack>
    </>
  );
};
