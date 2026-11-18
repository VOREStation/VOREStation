import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  last_configurator: string;
  locked: BooleanLike;
  one_access: BooleanLike;
  access: Record<string, AccessData> | undefined;
};

type AccessData = {
  access_num: number;
  enabled: BooleanLike;
};

export const AirlockElectronics = (props) => {
  const { act, data } = useBackend<Data>();
  const { last_configurator, locked, one_access, access } = data;
  return (
    <Window>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section
              title={locked ? 'Board Locked' : 'Board Unlocked'}
              buttons={
                locked ? (
                  <Button icon="unlock" onClick={() => act('login')}>
                    Unlock
                  </Button>
                ) : (
                  <Button icon="lock" onClick={() => act('logout')}>
                    Lock
                  </Button>
                )
              }
            >
              <LabeledList>
                <LabeledList.Item label="Last Operator">
                  {last_configurator}
                </LabeledList.Item>
                <LabeledList.Item label="Requires">
                  <Button
                    disabled={locked}
                    color={one_access ? 'good' : 'bad'}
                    onClick={() => act('one_access')}
                  >
                    {one_access ? 'At Least One' : 'Requires All'}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            {access ? (
              <Section
                title="Access List"
                fill
                scrollable
                buttons={
                  <Button
                    icon="refresh"
                    disabled={locked}
                    onClick={() => act('access', { access: 'all' })}
                  >
                    Clear All
                  </Button>
                }
              >
                <LabeledList>
                  {Object.entries(access).map((kv, _i) => (
                    <LabeledList.Item label={kv[0]} key={kv[0]}>
                      <Button
                        color={kv[1].enabled ? 'good' : 'bad'}
                        icon={kv[1].enabled ? 'lock' : 'unlock'}
                        disabled={locked}
                        onClick={() =>
                          act('access', { access: kv[1].access_num })
                        }
                      >
                        {kv[1].enabled ? 'Enabled' : 'Disabled'}
                      </Button>
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </Section>
            ) : (
              ''
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
