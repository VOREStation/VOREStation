import { Box, ProgressBar, Section, Table } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { damageRange } from './constants';
import { germStatus, reduceOrganStatus } from './functions';
import type { internalOrgan } from './types';

export const BodyScannerMainOrgansInternal = (props: {
  organs: internalOrgan[];
}) => {
  const { organs } = props;

  if (organs.length === 0) {
    return (
      <Section title="Internal Organs">
        <Box color="label">N/A</Box>
      </Section>
    );
  }

  return (
    <Section title="Internal Organs">
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
              {!o.missing && (
                <ProgressBar
                  minValue={0}
                  maxValue={o.maxHealth ? o.maxHealth / 100 : 0}
                  value={o.damage ? o.damage / 100 : 0}
                  mt={i > 0 && '0.5rem'}
                  ranges={damageRange}
                >
                  {!!o.damage && toFixed(o.damage)}
                </ProgressBar>
              )}
            </Table.Cell>
            <Table.Cell textAlign="right" width="33%">
              <Box color="average" inline>
                {reduceOrganStatus([
                  !!o.germ_level && germStatus(o.germ_level),
                  !!o.inflamed && 'Appendicitis detected.',
                ])}
              </Box>
              <Box inline>
                {reduceOrganStatus([
                  o.robotic === 1 && 'Robotic',
                  o.robotic === 2 && 'Assisted',
                  !!o.dead && <Box color="bad">DEAD</Box>,
                  !!o.missing && <Box color="bad">MISSING</Box>,
                ])}
              </Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
