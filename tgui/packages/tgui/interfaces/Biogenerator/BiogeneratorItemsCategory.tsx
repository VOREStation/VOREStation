import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Collapsible,
  Slider,
  Stack,
  Table,
} from 'tgui-core/components';
import { clamp } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { canBuyItem } from './functions';
import type { Data, Sortable } from './types';

export const BiogeneratorItemsCategory = (props: {
  title: string;
  items: Sortable[];
  build_eff: number;
  beaker: BooleanLike;
}) => {
  const { title, items, build_eff, beaker } = props;
  return (
    <Collapsible open title={title} color="transparent">
      <Table>
        {items.map((item) => (
          <BiogeneratorItemsEntry
            key={item.name}
            title={title}
            item={item}
            build_eff={build_eff}
            beaker={beaker}
          />
        ))}
      </Table>
    </Collapsible>
  );
};

const BiogeneratorItemsEntry = (props: {
  title: string;
  item: Sortable;
  build_eff: number;
  beaker: BooleanLike;
}) => {
  const { act, data } = useBackend<Data>();
  const [amount, setAmount] = useState(1);
  const { title, item, build_eff, beaker } = props;
  const { points } = data;

  return (
    <Table.Row className="candystripe" key={item.name}>
      <Table.Cell>{item.name}</Table.Cell>
      <Table.Cell collapsing>
        <Stack>
          {item.max_amount > 1 && (
            <Stack.Item>
              <Slider
                width="50px"
                maxValue={item.max_amount}
                minValue={1}
                value={amount}
                format={(val) => `${val}x`}
                onChange={(_, val) => setAmount(val)}
              />
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Button
              fluid
              width="69px"
              iconPosition="right"
              icon="basket-shopping"
              disabled={
                !canBuyItem(item, beaker) &&
                clamp(item.price / build_eff, 1, 10000) * amount > points
              }
              textAlign="right"
              onClick={() =>
                act('purchase', {
                  cat: title,
                  name: item.name,
                  amount: amount,
                })
              }
            >
              {`${(clamp(item.price / build_eff, 1, 10000) * amount).toFixed()}`}
            </Button>
          </Stack.Item>
        </Stack>
      </Table.Cell>
      <Table.Cell collapsing color="label">
        Price:
      </Table.Cell>
      <Table.Cell collapsing color="label" textAlign="right" width="30px">
        {`${clamp(item.price / build_eff, 1, 10000).toFixed()}`}
      </Table.Cell>
    </Table.Row>
  );
};
