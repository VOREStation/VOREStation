import { Box, Icon, Section, Stack, Table } from 'tgui-core/components';

export const WikiBloodTypes = (props) => {
  return (
    <Section fill title="Blood Type Compatibility">
      <Stack>
        <Stack.Item>
          <Stack fill vertical g={0}>
            <Stack.Item grow />
            <Stack.Item>
              <Box bold>y</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>o</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>u</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>r</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>&nbsp;</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>t</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>y</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>p</Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>e</Box>
            </Stack.Item>
            <Stack.Item grow />
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Table>
            <Table.Row>
              <Table.Cell colSpan={9}>
                <Box align="center" bold>
                  You can receive
                </Box>
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell />
              <Table.Cell>
                <Box bold>O+</Box>
              </Table.Cell>
              <Table.Cell>
                <Box bold>O-</Box>
              </Table.Cell>
              <Table.Cell>
                <Box bold>A+</Box>
              </Table.Cell>
              <Table.Cell>
                <Box bold>A-</Box>
              </Table.Cell>
              <Table.Cell>
                <Box bold>B+</Box>
              </Table.Cell>
              <Table.Cell>
                <Box bold>B-</Box>
              </Table.Cell>
              <Table.Cell>
                <Box bold>AB+</Box>
              </Table.Cell>
              <Table.Cell>
                <Box bold>AB-</Box>
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>O+</Box>
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>O-</Box>
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>A+</Box>
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>A-</Box>
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>B+</Box>
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>B-</Box>
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>AB+</Box>
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box bold>AB-</Box>
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell>
                <Icon name="droplet" color="red" />
              </Table.Cell>
            </Table.Row>
          </Table>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
