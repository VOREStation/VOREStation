import { Box, Icon, Section, Table } from 'tgui-core/components';

export const WikiBloodTypes = (props) => {
  return (
    <Section fill title="Blood Type Compatibility">
      <Table>
        <Table.Row>
          <Table.Cell colSpan={10}>
            <Box align="center" bold>
              You can receive
            </Box>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell />
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
            <Box bold>y</Box>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>
            <Box bold>o</Box>
          </Table.Cell>
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
            <Box bold>u</Box>
          </Table.Cell>
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
            <Box bold>r</Box>
          </Table.Cell>
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
          <Table.Cell />
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
            <Box bold>t</Box>
          </Table.Cell>
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
            <Box bold>y</Box>
          </Table.Cell>
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
            <Box bold>p</Box>
          </Table.Cell>
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
            <Box bold>e</Box>
          </Table.Cell>
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
    </Section>
  );
};
