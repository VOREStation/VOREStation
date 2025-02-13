import { Box, Section, Table } from 'tgui-core/components';

import type { occupant } from './types';

export const BodyScannerMainReagents = (props: { occupant: occupant }) => {
  const { occupant } = props;

  return (
    <>
      <Section title="Blood Reagents">
        {occupant.reagents ? (
          <Table>
            <Table.Row header>
              <Table.Cell>Reagent</Table.Cell>
              <Table.Cell textAlign="right">Amount</Table.Cell>
            </Table.Row>
            {occupant.reagents.map((reagent) => (
              <Table.Row key={reagent.name}>
                <Table.Cell>{reagent.name}</Table.Cell>
                <Table.Cell textAlign="right">
                  {reagent.amount} Units{' '}
                  {reagent.overdose ? <Box color="bad">OVERDOSING</Box> : null}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        ) : (
          <Box color="good">No Blood Reagents Detected</Box>
        )}
      </Section>
      <Section title="Stomach Reagents">
        {occupant.ingested ? (
          <Table>
            <Table.Row header>
              <Table.Cell>Reagent</Table.Cell>
              <Table.Cell textAlign="right">Amount</Table.Cell>
            </Table.Row>
            {occupant.ingested.map((reagent) => (
              <Table.Row key={reagent.name}>
                <Table.Cell>{reagent.name}</Table.Cell>
                <Table.Cell textAlign="right">
                  {reagent.amount} Units{' '}
                  {reagent.overdose ? <Box color="bad">OVERDOSING</Box> : null}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        ) : (
          <Box color="good">No Stomach Reagents Detected</Box>
        )}
      </Section>
    </>
  );
};
