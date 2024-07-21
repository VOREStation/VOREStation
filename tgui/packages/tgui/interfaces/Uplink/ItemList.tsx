import { BooleanLike } from 'common/react';
import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Button, Section, Table } from '../../components';
import { formatMoney } from '../../format';
import { item } from './types';

export const ItemList = (props: {
  compactMode: BooleanLike;
  currencyAmount: number;
  currencySymbol: string;
  items: item[];
}) => {
  const { act } = useBackend();

  const { compactMode, currencyAmount, currencySymbol, items } = props;

  if (compactMode) {
    return (
      <Table>
        {items.map((item) => (
          <Table.Row key={item.name} className="candystripe">
            <Table.Cell bold>{decodeHtmlEntities(item.name)}</Table.Cell>
            <Table.Cell collapsing textAlign="right">
              <Button
                fluid
                disabled={currencyAmount < item.cost}
                tooltip={item.desc}
                tooltipPosition="left"
                onClick={() =>
                  act('buy', {
                    ref: item.ref,
                  })
                }
              >
                {formatMoney(item.cost) + ' ' + currencySymbol}
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    );
  }
  return items.map((item) => (
    <Section
      key={item.name}
      title={item.name}
      buttons={
        <Button
          disabled={currencyAmount < item.cost}
          onClick={() =>
            act('buy', {
              ref: item.ref,
            })
          }
        >
          {item.cost + ' ' + currencySymbol}
        </Button>
      }
    >
      {decodeHtmlEntities(item.desc)}
    </Section>
  ));
};
