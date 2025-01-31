import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Table } from 'tgui-core/components';

// This had a pretty gross backend so this was unfortunately one of the
// best ways of doing it.
export const CfStep1 = (props) => {
  const { act } = useBackend();
  return (
    <Section title="Step 1" minHeight="306px">
      <Box mt={5} bold textAlign="center" fontSize="40px">
        Choose your Device
      </Box>
      <Box mt={3}>
        <Table width="100%">
          <Table.Row>
            <Table.Cell>
              <Button
                fluid
                icon="laptop"
                textAlign="center"
                fontSize="30px"
                lineHeight={2}
                onClick={() =>
                  act('pick_device', {
                    pick: '1',
                  })
                }
              >
                Laptop
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                fluid
                icon="tablet-alt"
                textAlign="center"
                fontSize="30px"
                lineHeight={2}
                onClick={() =>
                  act('pick_device', {
                    pick: '2',
                  })
                }
              >
                Tablet
              </Button>
            </Table.Cell>
          </Table.Row>
        </Table>
      </Box>
    </Section>
  );
};
