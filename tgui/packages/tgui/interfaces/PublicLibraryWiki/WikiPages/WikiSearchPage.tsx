import { type Dispatch, type SetStateAction, useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import type { PageData } from '../types';
import { WikiSearchList } from '../WikiCommon/WikiSearchList';
import { WikiBotanyPage } from './WikiSubPages/WikiBotanyPage';
import { WikiCatalogPage } from './WikiSubPages/WIkiCatalogPage';
import { WikiChemistryPage } from './WikiSubPages/WikiChemistryPage';
import { WikiFoodPage } from './WikiSubPages/WikiFoodPage';
import { WikiMaterialPage } from './WikiSubPages/WikiMaterialPage';
import { WikiNoDataPage } from './WikiSubPages/WikiNoDataPage';
import { WikiOrePage } from './WikiSubPages/WikiOrePage';
import { WikiParticlePage } from './WikiSubPages/WikiParticlePage';

export const WikiSearchPage = (
  props: {
    onUpdateAds: Dispatch<SetStateAction<boolean>>;
    updateAds: boolean;
    searchmode: string;
    search: string[];
    print: string;
    subCats: string[] | null;
  } & Required<PageData>,
) => {
  const { act } = useBackend();
  const [subCatSearchText, setSubCatSearchText] = useState('');
  const [subCatActiveEntry, setSubCatActiveEntry] = useState('');
  const [searchText, setSearchText] = useState('');
  const [activeEntry, setActiveEntry] = useState('');
  const [hideGroup, setHideGroup] = useState(false);
  const [noData, setNoData] = useState(false);
  const {
    onUpdateAds,
    updateAds,
    searchmode,
    botany_data,
    ore_data,
    food_data,
    drink_data,
    chemistry_data,
    material_data,
    particle_data,
    catalog_data,
    search,
    print,
    subCats,
  } = props;

  // Intentionally bad for the effect
  useEffect(() => {
    setNoData(false);
    if (!search.length) {
      setTimeout(() => {
        if (!search.length && subCatActiveEntry && !noData) {
          setNoData(true);
        }
      }, 200);
    }
  }, [search || subCatActiveEntry]);

  const customSearch = createSearch(searchText, (search: string) => search);
  const toDisplay = search.filter(customSearch);

  const customSubSearch = createSearch(
    subCatSearchText,
    (search: string) => search,
  );
  const subToDisplay = subCats?.filter(customSubSearch);

  const tabs: React.JSX.Element[] = [];
  tabs['Food Recipes'] = !!food_data && <WikiFoodPage food={food_data} />;
  tabs['Drink Recipes'] = !!drink_data && <WikiFoodPage food={drink_data} />;
  tabs['Chemistry'] = !!chemistry_data && (
    <WikiChemistryPage chems={chemistry_data} beakerFill={0.5} />
  );
  tabs['Botany'] = !!botany_data && <WikiBotanyPage seeds={botany_data} />;
  tabs['Ores'] = !!ore_data && <WikiOrePage ores={ore_data} />;
  tabs['Materials'] = !!material_data && (
    <WikiMaterialPage materials={material_data} />
  );
  tabs['Particle Physics'] = !!particle_data && (
    <WikiParticlePage smasher={particle_data} />
  );
  tabs['Catalogs'] = !!catalog_data && (
    <WikiCatalogPage catalog={catalog_data} />
  );

  return (
    <Section fill>
      <Button
        icon="arrow-left"
        onClick={() => {
          act('closesearch');
          onUpdateAds(!updateAds);
        }}
        tooltip="Return to main menu"
      >
        Back
      </Button>
      {!!print && (
        <Button
          icon="print"
          onClick={() => act('print')}
          tooltip="Print current page"
        >
          Print
        </Button>
      )}
      <Divider />
      <Stack fill>
        {!!subToDisplay &&
          (hideGroup ? (
            <Stack.Item>
              <Button
                icon="arrow-right"
                onClick={() => setHideGroup(!hideGroup)}
                tooltip="Show group categories"
              />
            </Stack.Item>
          ) : (
            <WikiSearchList
              title="Group"
              searchText={subCatSearchText}
              onSearchText={setSubCatSearchText}
              onActiveEntry={setSubCatActiveEntry}
              listEntries={subToDisplay}
              activeEntry={subCatActiveEntry}
              basis="15%"
              action="setsubcat"
              button={
                <Button
                  icon="arrow-left"
                  onClick={() => setHideGroup(!hideGroup)}
                  tooltip="Hide group categories"
                />
              }
            />
          ))}
        <WikiSearchList
          title={searchmode}
          searchText={searchText}
          onSearchText={setSearchText}
          onActiveEntry={setActiveEntry}
          listEntries={toDisplay}
          activeEntry={activeEntry}
          basis="30%"
          action="search"
        />
        <Stack.Item grow>
          {noData ? <WikiNoDataPage /> : tabs[searchmode]}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
