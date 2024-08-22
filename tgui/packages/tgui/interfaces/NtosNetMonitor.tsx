import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
} from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  ntnetstatus: BooleanLike;
  ntnetrelays: number;
  idsstatus: BooleanLike;
  idsalarm: BooleanLike;
  config_softwaredownload: BooleanLike;
  config_peertopeer: BooleanLike;
  config_communication: BooleanLike;
  config_systemcontrol: BooleanLike;
  ntnetlogs: { entry: string }[] | [];
  minlogs: number;
  maxlogs: number;
  banned_nids: number[];
  ntnetmaxlogs: number;
};

export const NtosNetMonitor = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    ntnetrelays,
    ntnetstatus,
    config_softwaredownload,
    config_peertopeer,
    config_communication,
    config_systemcontrol,
    idsalarm,
    idsstatus,
    ntnetmaxlogs,
    maxlogs,
    minlogs,
    banned_nids,
    ntnetlogs = [],
  } = data;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <NoticeBox>
          WARNING: Disabling wireless transmitters when using a wireless device
          may prevent you from reenabling them!
        </NoticeBox>
        <Section
          title="Wireless Connectivity"
          buttons={
            <Button.Confirm
              icon={ntnetstatus ? 'power-off' : 'times'}
              selected={ntnetstatus}
              onClick={() => act('toggleWireless')}
            >
              {ntnetstatus ? 'ENABLED' : 'DISABLED'}
            </Button.Confirm>
          }
        >
          {ntnetrelays ? (
            <LabeledList>
              <LabeledList.Item label="Active NTNet Relays">
                {ntnetrelays}
              </LabeledList.Item>
            </LabeledList>
          ) : (
            'No Relays Connected'
          )}
        </Section>
        <Section title="Firewall Configuration">
          <LabeledList>
            <LabeledList.Item
              label="Software Downloads"
              buttons={
                <Button
                  icon={config_softwaredownload ? 'power-off' : 'times'}
                  selected={config_softwaredownload}
                  onClick={() => act('toggle_function', { id: '1' })}
                >
                  {config_softwaredownload ? 'ENABLED' : 'DISABLED'}
                </Button>
              }
            />
            <LabeledList.Item
              label="Peer to Peer Traffic"
              buttons={
                <Button
                  icon={config_peertopeer ? 'power-off' : 'times'}
                  selected={config_peertopeer}
                  onClick={() => act('toggle_function', { id: '2' })}
                >
                  {config_peertopeer ? 'ENABLED' : 'DISABLED'}
                </Button>
              }
            />
            <LabeledList.Item
              label="Communication Systems"
              buttons={
                <Button
                  icon={config_communication ? 'power-off' : 'times'}
                  selected={config_communication}
                  onClick={() => act('toggle_function', { id: '3' })}
                >
                  {config_communication ? 'ENABLED' : 'DISABLED'}
                </Button>
              }
            />
            <LabeledList.Item
              label="Remote System Control"
              buttons={
                <Button
                  icon={config_systemcontrol ? 'power-off' : 'times'}
                  selected={config_systemcontrol}
                  onClick={() => act('toggle_function', { id: '4' })}
                >
                  {config_systemcontrol ? 'ENABLED' : 'DISABLED'}
                </Button>
              }
            />
          </LabeledList>
        </Section>
        <Section title="Security Systems">
          {!!idsalarm && (
            <>
              <NoticeBox>NETWORK INCURSION DETECTED</NoticeBox>
              <Box italic>
                Abnormal activity has been detected in the network. Check system
                logs for more information
              </Box>
            </>
          )}
          <LabeledList>
            <LabeledList.Item
              label="Banned NIDs"
              buttons={
                <>
                  <Button icon="ban" onClick={() => act('ban_nid')}>
                    Ban NID
                  </Button>
                  <Button icon="balance-scale" onClick={() => act('unban_nid')}>
                    Unban NID
                  </Button>
                </>
              }
            >
              {banned_nids.join(', ') || 'None'}
            </LabeledList.Item>
            <LabeledList.Item
              label="IDS Status"
              buttons={
                <>
                  <Button
                    icon={idsstatus ? 'power-off' : 'times'}
                    selected={idsstatus}
                    onClick={() => act('toggleIDS')}
                  >
                    {idsstatus ? 'ENABLED' : 'DISABLED'}
                  </Button>
                  <Button
                    icon="sync"
                    color="bad"
                    onClick={() => act('resetIDS')}
                  >
                    Reset
                  </Button>
                </>
              }
            />
            <LabeledList.Item
              label="Max Log Count"
              buttons={
                <NumberInput
                  step={1}
                  value={ntnetmaxlogs}
                  minValue={minlogs}
                  maxValue={maxlogs}
                  width="39px"
                  onChange={(value: number) =>
                    act('updatemaxlogs', {
                      new_number: value,
                    })
                  }
                />
              }
            />
          </LabeledList>
          <Section
            title="System Log"
            buttons={
              <Button.Confirm icon="trash" onClick={() => act('purgelogs')}>
                Clear Logs
              </Button.Confirm>
            }
          >
            {ntnetlogs.map((log) => (
              <Box key={log.entry} className="candystripe">
                {log.entry}
              </Box>
            ))}
          </Section>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
