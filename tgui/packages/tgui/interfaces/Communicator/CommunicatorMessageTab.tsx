import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, Section, Table } from '../../components';
import { CONTTAB, MESSSUBTAB } from './constants';
import { Data } from './types';

export const CommunicatorMessageTab = (props) => {
  const { act, data } = useBackend<Data>();

  const { imContacts } = data;

  return (
    <Section title="Messaging">
      {(imContacts.length && (
        <Table>
          {imContacts.map((device) => (
            <Table.Row key={device.address}>
              <Table.Cell
                color="label"
                style={{
                  'word-break': 'break-all',
                }}
              >
                {decodeHtmlEntities(device.name)}:
              </Table.Cell>
              <Table.Cell>
                <Box>{device.address}</Box>
                <Box>
                  <Button
                    icon="comment"
                    onClick={() => {
                      act('copy', { copy: device.address });
                      act('copy_name', {
                        copy_name: device.name,
                      });
                      act('switch_tab', {
                        switch_tab: MESSSUBTAB,
                      });
                    }}
                  >
                    View Conversation
                  </Button>
                </Box>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )) || (
        <Box>
          You haven&apos;t sent any messages yet.
          <Button
            fluid
            icon="user"
            onClick={() => act('switch_tab', { switch_tab: CONTTAB })}
          >
            Contacts
          </Button>
        </Box>
      )}
    </Section>
  );
};
