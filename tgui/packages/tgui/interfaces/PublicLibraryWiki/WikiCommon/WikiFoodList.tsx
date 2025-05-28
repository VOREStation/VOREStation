import { Box, LabeledList } from 'tgui-core/components';

import type { RedipeData } from '../types';
import { SupplyEntry } from '../WikiCommon/WikiQuickElements';
import { WikiSpoileredList } from './WikiListElements';

export const RecipeList = (props: { title: string; recipe: RedipeData }) => {
  const { title, recipe } = props;
  const {
    supply_points,
    market_price,
    appliance,
    has_coating,
    coating,
    ingredients,
    fruits,
    reagents,
    catalysts,
  } = recipe;

  return (
    <>
      <LabeledList.Divider />
      <SupplyEntry supply_points={supply_points} market_price={market_price} />
      <LabeledList.Divider />
      <LabeledList.Item label="Appliance">{appliance}</LabeledList.Item>
      <LabeledList.Item label="Coating">
        {getCoating(!!has_coating, coating)}
      </LabeledList.Item>
      {!!ingredients && (
        <WikiSpoileredList
          ourKey={title}
          entries={ingredients}
          title={'Ingredients'}
        />
      )}
      {!!fruits && (
        <WikiSpoileredList ourKey={title} entries={fruits} title={'Fruits'} />
      )}
      {!!reagents && (
        <WikiSpoileredList
          ourKey={title}
          entries={reagents}
          title={'Reagents'}
        />
      )}
      {!!catalysts && (
        <WikiSpoileredList
          ourKey={title}
          entries={catalysts}
          title={'Catalysts'}
        />
      )}
    </>
  );
};

function getCoating(has_coating: boolean, coating: number | string | null) {
  if (!has_coating) {
    return <Box color="label">N/A, no coatable items</Box>;
  }

  if (!coating) {
    return <Box color="red">Must be uncoated</Box>;
  }

  if (coating === -1) {
    return <Box>Optionally, any coating</Box>;
  }

  return <Box>{coating}</Box>;
}
