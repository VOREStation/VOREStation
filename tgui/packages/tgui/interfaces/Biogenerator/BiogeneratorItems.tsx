import { useBackend } from 'tgui/backend';
import { Section } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import { BiogeneratorItemsCategory } from './BiogeneratorItemsCategory';
import { sortTypes } from './constants';
import type { Data, Sortable } from './types';

export const BiogeneratorItems = (props: {
  searchText: string;
  sortOrder: string;
  descending: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { points, items = [], build_eff, beaker } = data;
  // Search thingies
  const searcher = createSearch<[string, Sortable]>(
    props.searchText,
    (item) => {
      return item[0];
    },
  );

  const contents = Object.entries(items).map((kv) => {
    let items_in_cat = Object.entries(kv[1])
      .filter(searcher)
      .map((kv2) => {
        kv2[1].affordable = +(points >= kv2[1].price / build_eff);
        return kv2[1];
      })
      .sort(sortTypes[props.sortOrder]);
    if (items_in_cat.length === 0) {
      return undefined;
    }
    if (props.descending) {
      items_in_cat = items_in_cat.reverse();
    }

    return (
      <BiogeneratorItemsCategory
        key={kv[0]}
        title={kv[0]}
        items={items_in_cat}
        build_eff={build_eff}
        beaker={beaker}
      />
    );
  });
  return <Section fill>{contents}</Section>;
};
