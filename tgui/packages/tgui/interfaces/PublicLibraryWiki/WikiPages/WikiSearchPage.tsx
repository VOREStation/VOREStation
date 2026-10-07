import { type Dispatch, type SetStateAction, useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import type { PageData } from '../types';
import { WikiSearchList } from '../WikiCommon/WikiSearchList';
import { WikiCatalogPage } from './WikiSubPages/WIkiCatalogPage';
import { WikiBotanyPage } from './WikiSubPages/WikiBotanyPage';
import { WikiChemistryPage } from './WikiSubPages/WikiChemistryPage';
import { WikiFoodPage } from './WikiSubPages/WikiFoodPage';
import { WikiGenePage } from './WikiSubPages/WikiGenePage';
import { WikiMaterialPage } from './WikiSubPages/WikiMaterialPage';
import { WikiNoDataPage } from './WikiSubPages/WikiNoDataPage';
import { WikiOrePage } from './WikiSubPages/WikiOrePage';
import { WikiParticlePage } from './WikiSubPages/WikiParticlePage';
import { WikiVirusPage } from './WikiSubPages/WikiVirusPage';

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
    botany_id,
    ore_id,
    virus_id,
    gene_id,
    food_id,
    drink_id,
    chemistry_id,
    material_id,
    particle_id,
    catalog_id,
    search,
    print,
    subCats,
  } = props;

  // Intentionally bad for the effect
  useEffect(() => {
    if (!search.length && !noData) {
      setNoData(true);
    } else if (search.length) {
      setNoData(false);
    }
  }, [search]);

  function handleActiveEntry(neWEntry: string) {
    if (activeEntry !== neWEntry) {
      setActiveEntry(neWEntry);
      setSubCatActiveEntry('');
    }
  }

  const customSearch = createSearch<string>(searchText, (search) => search);
  const toDisplay = search.filter(customSearch);

  const customSubSearch = createSearch<string>(
    subCatSearchText,
    (search) => search,
  );
  const subToDisplay = subCats?.filter(customSubSearch);

  const tabs: Record<string, React.JSX.Element | false> = {};
  tabs['Food Recipes'] = !!food_id && <WikiFoodPage food={food_id} />;
  tabs['Drink Recipes'] = !!drink_id && <WikiFoodPage food={drink_id} />;
  tabs.Chemistry = !!chemistry_id && (
    <WikiChemistryPage chems={chemistry_id} beakerFill={0.5} />
  );
  tabs.Botany = !!botany_id && <WikiBotanyPage seeds={botany_id} />;
  tabs.Ores = !!ore_id && <WikiOrePage ores={ore_id} />;
  tabs.Viruses = !!virus_id && <WikiVirusPage virus={virus_id} />;
  tabs.Genes = !!gene_id && <WikiGenePage gene={gene_id} />;
  tabs.Materials = !!material_id && (
    <WikiMaterialPage materials={material_id} />
  );
  tabs['Particle Physics'] = !!particle_id && (
    <WikiParticlePage smasher={particle_id} />
  );
  tabs.Catalogs = !!catalog_id && <WikiCatalogPage catalog={catalog_id} />;

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
          onActiveEntry={handleActiveEntry}
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
