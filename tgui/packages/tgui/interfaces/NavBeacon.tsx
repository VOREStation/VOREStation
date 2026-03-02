import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Divider,
  LabeledList,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type Data = {
  siliconUser: BooleanLike;
  locked: BooleanLike;
  open: BooleanLike;
  location: string;
  codes: Record<string, string>;
};

export const NavBeacon = (props) => {
  const { act, data } = useBackend<Data>();
  const { locked, open, location, codes } = data;
  const [newKey, setNewKey] = useState('');
  const [newVal, setNewVal] = useState('');

  return (
    <Window width={350} height={300}>
      <Window.Content>
        <Section fill scrollable>
          <Stack fill vertical>
            <Stack.Item>
              <InterfaceLockNoticeBox />
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Location">
                  <UserAccessButton
                    icon="pen"
                    accessible={!locked && open}
                    value={location}
                    onCommit={(value) => act('loc_edit', { new_loc: value })}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Transponder Codes">
                  <Table>
                    <Table.Row>
                      <Table.Cell color="label">Code Key</Table.Cell>
                      <Table.Cell color="label">Code Value</Table.Cell>
                    </Table.Row>
                    {Object.keys(codes).map((code) => (
                      <Table.Row key={code}>
                        <Table.Cell>
                          <UserAccessButton
                            icon="pen"
                            accessible={!locked && open}
                            value={code}
                            onCommit={(value) =>
                              act('trans_edit_key', {
                                code: code,
                                new_key: value,
                              })
                            }
                          />
                        </Table.Cell>
                        <Table.Cell>
                          <Stack>
                            <Stack.Item grow>
                              <UserAccessButton
                                icon="pen"
                                accessible={!locked && open}
                                value={codes[code]}
                                onCommit={(value) =>
                                  act('trans_edit_code', {
                                    code: code,
                                    new_val: value,
                                  })
                                }
                              />
                            </Stack.Item>
                            {!locked && open && (
                              <Stack.Item>
                                <Button.Confirm
                                  color="red"
                                  onClick={() =>
                                    act('trans_del', { code: code })
                                  }
                                  icon="trash"
                                />
                              </Stack.Item>
                            )}
                          </Stack>
                        </Table.Cell>
                      </Table.Row>
                    ))}
                    {!locked && open && (
                      <>
                        <Divider />
                        <Table.Row>
                          <Table.Cell>
                            <Button.Input
                              fluid
                              color={codes[newKey] ? 'red' : undefined}
                              disabled={locked || !open}
                              value={newKey}
                              buttonText={newKey ?? '(new val)'}
                              onCommit={setNewKey}
                            />
                          </Table.Cell>
                          <Table.Cell>
                            <Stack>
                              <Stack.Item grow>
                                <Button.Input
                                  fluid
                                  disabled={locked || !open}
                                  value={newVal}
                                  buttonText={newVal ?? '(new val)'}
                                  onCommit={setNewVal}
                                />
                              </Stack.Item>
                              <Stack.Item>
                                <Button
                                  disabled={
                                    !newVal ||
                                    !newKey ||
                                    !!codes[newKey] ||
                                    locked ||
                                    !open
                                  }
                                  color={
                                    newVal && newKey && !codes[newKey]
                                      ? 'green'
                                      : 'red'
                                  }
                                  onClick={() => {
                                    act('trans_add_code', {
                                      new_key: newKey,
                                      new_val: newVal,
                                    });
                                    setNewKey('');
                                    setNewVal('');
                                  }}
                                >
                                  +
                                </Button>
                              </Stack.Item>
                            </Stack>
                          </Table.Cell>
                        </Table.Row>
                      </>
                    )}
                  </Table>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const UserAccessButton = (props: {
  accessible: BooleanLike;
  value: string;
  onCommit: ((value: string) => void) | undefined;
  icon?: string;
}) => {
  const { accessible, value, onCommit, icon } = props;

  return accessible ? (
    <Button.Input
      fluid
      icon={icon}
      disabled={!accessible}
      buttonText={value ?? '(unset)'}
      value={value}
      onCommit={onCommit}
    />
  ) : (
    (value ?? '(unset)')
  );
};
