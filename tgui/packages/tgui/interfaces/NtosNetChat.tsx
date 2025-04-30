import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import { Box, Button, Icon, Input, Section, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  can_admin: BooleanLike;
  all_channels: {
    chan: string;
    id: number | null;
  }[];
  active_channel: number | null;
  username: string;
  adminmode: BooleanLike;
  title: string | undefined;
  authed: BooleanLike;
  clients: { name: string }[] | [];
  messages: { msg: string }[] | [];
  is_operator: BooleanLike;
};

export const NtosNetChat = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    can_admin,
    adminmode,
    authed,
    username,
    active_channel,
    is_operator,
    all_channels = [],
    clients = [],
    messages = [],
  } = data;
  const in_channel: boolean = active_channel !== null;
  const authorized: BooleanLike = authed || adminmode;
  return (
    <NtosWindow width={900} height={675}>
      <NtosWindow.Content>
        <Section height="600px">
          <Table height="580px">
            <Table.Row>
              <Table.Cell
                verticalAlign="top"
                style={{
                  width: '200px',
                }}
              >
                <Box height="560px" overflowY="scroll">
                  <Button.Input
                    fluid
                    buttonText="New Channel..."
                    onCommit={(value) =>
                      act('PRG_newchannel', {
                        new_channel_name: value,
                      })
                    }
                  />
                  {all_channels.map((channel) => (
                    <Button
                      fluid
                      key={channel.chan}
                      selected={channel.id === active_channel}
                      color="transparent"
                      onClick={() =>
                        act('PRG_joinchannel', {
                          id: channel.id,
                        })
                      }
                    >
                      {channel.chan}
                    </Button>
                  ))}
                </Box>
                <Button.Input
                  fluid
                  mt={1}
                  buttonText={username + '...'}
                  value={username}
                  onCommit={(value) =>
                    act('PRG_changename', {
                      new_name: value,
                    })
                  }
                />
                {!!can_admin && (
                  <Button
                    fluid
                    bold
                    color={adminmode ? 'bad' : 'good'}
                    onClick={() => act('PRG_toggleadmin')}
                  >
                    {'ADMIN MODE: ' + (adminmode ? 'ON' : 'OFF')}
                  </Button>
                )}
              </Table.Cell>
              <Table.Cell>
                <Box height="560px" overflowY="scroll">
                  {in_channel &&
                    (authorized ? (
                      messages.map((message) => (
                        <Box key={message.msg}>{message.msg}</Box>
                      ))
                    ) : (
                      <Box textAlign="center">
                        <Icon
                          name="exclamation-triangle"
                          mt={4}
                          fontSize="40px"
                        />
                        <Box mt={1} bold fontSize="18px">
                          THIS CHANNEL IS PASSWORD PROTECTED
                        </Box>
                        <Box mt={1}>INPUT PASSWORD TO ACCESS</Box>
                      </Box>
                    ))}
                </Box>
                <Input
                  fluid
                  selfClear
                  mt={1}
                  onEnter={(value) =>
                    act('PRG_speak', {
                      message: value,
                    })
                  }
                />
              </Table.Cell>
              <Table.Cell
                verticalAlign="top"
                style={{
                  width: '150px',
                }}
              >
                <Box height="465px" overflowY="scroll">
                  {clients.map((client) => (
                    <Box key={client.name}>{client.name}</Box>
                  ))}
                </Box>
                {in_channel && authorized && (
                  <>
                    <Button.Input
                      fluid
                      buttonText="Save log..."
                      value="new_log"
                      onCommit={(value) =>
                        act('PRG_savelog', {
                          log_name: value,
                        })
                      }
                    />
                    <Button.Confirm
                      fluid
                      onClick={() => act('PRG_leavechannel')}
                    >
                      Leave Channel
                    </Button.Confirm>
                  </>
                )}
                {!!is_operator && authed && (
                  <>
                    <Button.Confirm
                      fluid
                      onClick={() => act('PRG_deletechannel')}
                    >
                      Delete Channel
                    </Button.Confirm>
                    <Button.Input
                      fluid
                      buttonText="Rename Channel..."
                      onCommit={(value) =>
                        act('PRG_renamechannel', {
                          new_name: value,
                        })
                      }
                    />
                    <Button.Input
                      fluid
                      buttonText="Set Password..."
                      onCommit={(value) =>
                        act('PRG_setpassword', {
                          new_password: value,
                        })
                      }
                    />
                  </>
                )}
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
