import { ProgressBar, Section, Table } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { damageRange, damages } from './constants';
import { mapTwoByTwo } from './functions';
import type { occupant } from './types';

export const BodyScannerMainDamage = (props: { occupant: occupant }) => {
  const { occupant } = props;
  return (
    <Section title="Damage">
      <Table>
        {mapTwoByTwo(damages, (d1: string[], d2: string[], i: number) => (
          <>
            <Table.Row color="label">
              <Table.Cell>{d1[0]}:</Table.Cell>
              <Table.Cell>{!!d2 && d2[0] + ':'}</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <BodyScannerMainDamageBar
                  value={occupant[d1[1]]}
                  marginBottom={i < damages.length - 2}
                />
              </Table.Cell>
              <Table.Cell>
                {!!d2 && <BodyScannerMainDamageBar value={occupant[d2[1]]} />}
              </Table.Cell>
            </Table.Row>
          </>
        ))}
      </Table>
    </Section>
  );
};

const BodyScannerMainDamageBar = (props: {
  value: number;
  marginBottom?: boolean;
}) => {
  const { value, marginBottom } = props;
  return (
    <ProgressBar
      minValue={0}
      maxValue={1}
      value={value / 100}
      mt="0.5rem"
      mb={!!marginBottom && '0.5rem'}
      ranges={damageRange}
    >
      {toFixed(value)}
    </ProgressBar>
  );
};
