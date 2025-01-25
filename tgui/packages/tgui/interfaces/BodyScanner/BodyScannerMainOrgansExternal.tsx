import {
  Box,
  Icon,
  ProgressBar,
  Section,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { damageRange } from './constants';
import { germStatus, reduceOrganStatus } from './functions';
import { externalOrgan } from './types';

export const BodyScannerMainOrgansExternal = (props: {
  organs: externalOrgan[];
}) => {
  const { organs } = props;

  if (organs.length === 0) {
    return (
      <Section title="External Organs">
        <Box color="label">N/A</Box>
      </Section>
    );
  }

  return (
    <Section title="External Organs">
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell textAlign="center">Damage</Table.Cell>
          <Table.Cell textAlign="right">Injuries</Table.Cell>
        </Table.Row>
        {organs.map((o, i) => (
          <Table.Row key={i} style={{ textTransform: 'capitalize' }}>
            <Table.Cell width="33%">{o.name}</Table.Cell>
            <Table.Cell textAlign="center">
              <ProgressBar
                minValue={0}
                maxValue={o.maxHealth / 100}
                mt={i > 0 && '0.5rem'}
                value={o.totalLoss / 100}
                ranges={damageRange}
              >
                <Box
                  style={{
                    float: 'left',
                  }}
                  inline
                >
                  {!!o.bruteLoss && (
                    <Tooltip content="Brute damage" position="top">
                      <Icon name="band-aid" />
                      {toFixed(o.bruteLoss)}&nbsp;
                    </Tooltip>
                  )}
                  {!!o.fireLoss && (
                    <Tooltip content="Burn damage" position="top">
                      <Icon name="fire" />
                      {toFixed(o.fireLoss)}
                      <Tooltip position="top" content="Burn damage" />
                    </Tooltip>
                  )}
                </Box>
                <Box inline>{toFixed(o.totalLoss)}</Box>
              </ProgressBar>
            </Table.Cell>
            <Table.Cell textAlign="right" width="33%">
              <Box color="average" inline>
                {reduceOrganStatus([
                  o.internalBleeding && 'Internal bleeding',
                  !!o.status.bleeding && 'External bleeding',
                  o.lungRuptured && 'Ruptured lung',
                  o.status.destroyed && 'Destroyed',
                  !!o.status.broken && o.status.broken,
                  germStatus(o.germ_level),
                  !!o.open && 'Open incision',
                ])}
              </Box>
              <Box inline>
                {reduceOrganStatus([
                  !!o.status.splinted && 'Splinted',
                  !!o.status.robotic && 'Robotic',
                  !!o.status.dead && <Box color="bad">DEAD</Box>,
                ])}
                {reduceOrganStatus(
                  o.implants.map((s) => (s.known ? s.name : 'Unknown object')),
                )}
              </Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
