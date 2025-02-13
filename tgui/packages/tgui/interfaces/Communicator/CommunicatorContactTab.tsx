import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Table } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { MESSSUBTAB, PHONTAB } from './constants';
import type { ContactsTabData } from './types';

export const CommunicatorContactTab = (props) => {
  const { act, data } = useBackend<ContactsTabData>();

  const { knownDevices } = data;

  return (
    <Section title="Known Devices">
      {(knownDevices.length && (
        <Table>
          {knownDevices.map((device) => (
            <Table.Row key={device.address}>
              <Table.Cell
                color="label"
                style={{
                  wordBreak: 'break-all',
                }}
              >
                {decodeHtmlEntities(device.name)}
              </Table.Cell>
              <Table.Cell>
                <Box>{device.address}</Box>
                <Box>
                  <Button
                    icon="pen"
                    onClick={() => {
                      act('copy', { copy: device.address });
                      act('switch_tab', { switch_tab: PHONTAB });
                    }}
                  >
                    Copy
                  </Button>
                  <Button
                    icon="phone"
                    onClick={() => {
                      act('dial', { dial: device.address });
                      act('copy', { copy: device.address });
                      act('switch_tab', { switch_tab: PHONTAB });
                    }}
                  >
                    Call
                  </Button>
                  <Button
                    icon="comment-alt"
                    onClick={() => {
                      act('copy', { copy: device.address });
                      act('copy_name', { copy_name: device.name });
                      act('switch_tab', { switch_tab: MESSSUBTAB });
                    }}
                  >
                    Msg
                  </Button>
                </Box>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )) || <Box>No devices detected on your local NTNet region.</Box>}
    </Section>
  );
};
