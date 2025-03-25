import { type Dispatch, type SetStateAction, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { groupList } from '../constants';
import type { PageData } from '../types';
import { WikiSearchList } from '../WikiCommon/WikiSearchList';
import { WikiCatalogPage } from '../WikiSubPages/WIkiCatalogPage';
import { WikiMaterialPage } from '../WikiSubPages/WikiMaterialPage';

export const WikiSearchPage = (
  props: {
    onUpdateAds: Dispatch<SetStateAction<boolean>>;
    updateAds: boolean;
    searchmode: string;
    search: string[];
    print: string;
    subCats: string[] | null;
  } & Partial<PageData>,
) => {
  const { act } = useBackend();
  const [subCatSearchText, setSubCatSearchText] = useState('');
  const [subCatActiveEntry, setSubCatActiveEntry] = useState('');
  const [searchText, setSearchText] = useState('');
  const [activeEntry, setactiveEntry] = useState('');
  const [hideGroup, setHideGroup] = useState(0);
  const {
    onUpdateAds,
    updateAds,
    searchmode,
    material_data,
    catalog_data,
    search,
    print,
    subCats,
  } = props;

  const customSearch = createSearch(searchText, (search: string) => search);
  const toDisplay = search.filter(customSearch);

  const tabs: React.JSX.Element[] = [];
  tabs['Food Recipes'] = null;
  tabs['Drink Recipes'] = null;
  tabs['Chemistry'] = null;
  tabs['Botany'] = null;
  tabs['Catalogs'] = !!catalog_data && (
    <WikiCatalogPage catalog={catalog_data} />
  );
  tabs['Particle Physics'] = null;
  tabs['Materials'] = !!material_data && (
    <WikiMaterialPage materials={material_data} />
  );
  tabs['Ores'] = null;

  return (
    <Section fill>
      <Button
        icon="arrow-left"
        onClick={() => {
          act('closesearch');
          onUpdateAds(!updateAds);
        }}
      >
        Back
      </Button>
      {!!print && (
        <Button icon="print" onClick={() => act('print')}>
          Print
        </Button>
      )}
      <Divider />
      <Stack fill>
        {!!subCats && (
          <WikiSearchList
            title="Group"
            searchText={subCatSearchText}
            onSearchText={setSubCatSearchText}
            onActiveEntry={setSubCatActiveEntry}
            listEntries={subCats}
            activeEntry={subCatActiveEntry}
            basis={groupList[hideGroup]}
            action="setsubcat"
            button={
              <Button
                icon={hideGroup === 0 ? 'arrow-left' : 'arrow-right'}
                onClick={() => setHideGroup(hideGroup > 0 ? 0 : 1)}
              />
            }
          />
        )}
        <WikiSearchList
          title={searchmode}
          searchText={searchText}
          onSearchText={setSearchText}
          onActiveEntry={setactiveEntry}
          listEntries={toDisplay}
          activeEntry={activeEntry}
          basis="30%"
          action="search"
        />
        <Stack.Item grow>{tabs[searchmode]}</Stack.Item>
      </Stack>
    </Section>
  );
};
