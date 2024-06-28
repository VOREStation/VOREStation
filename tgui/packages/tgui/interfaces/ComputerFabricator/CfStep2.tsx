import { multiline } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, Section, Table, Tooltip } from '../../components';
import { Data } from './types';

export const CfStep2 = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    totalprice,
    hw_battery,
    hw_disk,
    hw_netcard,
    hw_nanoprint,
    hw_card,
    devtype,
    hw_cpu,
    hw_tesla,
  } = data;

  return (
    <Section
      title="Step 2: Customize your device"
      minHeight="282px"
      buttons={
        <Box bold color="good">
          {totalprice}₮
        </Box>
      }
    >
      <Table>
        <Table.Row>
          <Table.Cell bold position="relative">
            Battery:
            <Tooltip
              content={multiline`
                Allows your device to operate without external utility power
                source. Advanced batteries increase battery life.
              `}
              position="right"
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_battery === 1}
              onClick={() =>
                act('hw_battery', {
                  battery: '1',
                })
              }
            >
              Standard
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_battery === 2}
              onClick={() =>
                act('hw_battery', {
                  battery: '2',
                })
              }
            >
              Upgraded
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_battery === 3}
              onClick={() =>
                act('hw_battery', {
                  battery: '3',
                })
              }
            >
              Advanced
            </Button>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell bold position="relative">
            Hard Drive:
            <Tooltip
              content={multiline`
                Stores file on your device. Advanced drives can store more
                files, but use more power, shortening battery life.
              `}
              position="right"
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_disk === 1}
              onClick={() =>
                act('hw_disk', {
                  disk: '1',
                })
              }
            >
              Standard
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_disk === 2}
              onClick={() =>
                act('hw_disk', {
                  disk: '2',
                })
              }
            >
              Upgraded
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_disk === 3}
              onClick={() =>
                act('hw_disk', {
                  disk: '3',
                })
              }
            >
              Advanced
            </Button>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell bold position="relative">
            Network Card:
            <Tooltip
              content={multiline`
                Allows your device to wirelessly connect to stationwide NTNet
                network. Basic cards are limited to on-station use, while
                advanced cards can operate anywhere near the station, which
                includes asteroid outposts
              `}
              position="right"
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_netcard === 0}
              onClick={() =>
                act('hw_netcard', {
                  netcard: '0',
                })
              }
            >
              None
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_netcard === 1}
              onClick={() =>
                act('hw_netcard', {
                  netcard: '1',
                })
              }
            >
              Standard
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_netcard === 2}
              onClick={() =>
                act('hw_netcard', {
                  netcard: '2',
                })
              }
            >
              Advanced
            </Button>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell bold position="relative">
            Nano Printer:
            <Tooltip
              content={multiline`
                A device that allows for various paperwork manipulations,
                such as, scanning of documents or printing new ones.
                This device was certified EcoFriendlyPlus and is capable of
                recycling existing paper for printing purposes.
              `}
              position="right"
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_nanoprint === 0}
              onClick={() =>
                act('hw_nanoprint', {
                  print: '0',
                })
              }
            >
              None
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_nanoprint === 1}
              onClick={() =>
                act('hw_nanoprint', {
                  print: '1',
                })
              }
            >
              Standard
            </Button>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell bold position="relative">
            Secondary Card Reader:
            <Tooltip
              content={multiline`
                Adds a secondary RFID card reader, for manipulating or
                reading from a second standard RFID card.
                Please note that a primary card reader is necessary to
                allow the device to read your identification, but one
                is included in the base price.
              `}
              position="right"
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_card === 0}
              onClick={() =>
                act('hw_card', {
                  card: '0',
                })
              }
            >
              None
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_card === 1}
              onClick={() =>
                act('hw_card', {
                  card: '1',
                })
              }
            >
              Standard
            </Button>
          </Table.Cell>
        </Table.Row>
        {devtype !== 2 && (
          <Table.Row>
            <Table.Cell bold position="relative">
              Processor Unit:
              <Tooltip
                content={multiline`
                  A component critical for your device's functionality.
                  It allows you to run programs from your hard drive.
                  Advanced CPUs use more power, but allow you to run
                  more programs on background at once.
                `}
                position="right"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                selected={hw_cpu === 1}
                onClick={() =>
                  act('hw_cpu', {
                    cpu: '1',
                  })
                }
              >
                Standard
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                selected={hw_cpu === 2}
                onClick={() =>
                  act('hw_cpu', {
                    cpu: '2',
                  })
                }
              >
                Advanced
              </Button>
            </Table.Cell>
          </Table.Row>
        )}
        <Table.Row>
          <Table.Cell bold position="relative">
            Tesla Relay:
            <Tooltip
              content={multiline`
                    An advanced wireless power relay that allows your device
                    to connect to nearby area power controller to provide
                    alternative power source. This component is currently
                    unavailable on tablet computers due to size restrictions.
                  `}
              position="right"
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_tesla === 0}
              onClick={() =>
                act('hw_tesla', {
                  tesla: '0',
                })
              }
            >
              None
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              selected={hw_tesla === 1}
              onClick={() =>
                act('hw_tesla', {
                  tesla: '1',
                })
              }
            >
              Standard
            </Button>
          </Table.Cell>
        </Table.Row>
      </Table>
      <Button
        fluid
        mt={3}
        color="good"
        textAlign="center"
        fontSize="18px"
        lineHeight={2}
        onClick={() => act('confirm_order')}
      >
        Confirm Order
      </Button>
    </Section>
  );
};
