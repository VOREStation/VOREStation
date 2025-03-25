import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, NoticeBox, Section, Stack } from 'tgui-core/components';

import { WikiAdColors, wikiAds } from './constants';
import type { Data } from './types';
import { WikiErrorPage } from './WikiPages/WikiErrorPage';
import { WikiLoadingPage } from './WikiPages/WikiLoadingPage';
import { WikiMainPage } from './WikiPages/WikiMainPage';
import { WikiSearchPage } from './WikiPages/WikiSearchPage';

export const PublicLibraryWiki = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    crash,
    errorText,
    searchmode,
    search,
    print,
    sub_categories,
    botany_data,
    material_data,
    particle_data,
    catalog_data,
    ore_data,
  } = data;
  const [displayedAds, setDisplayedAds] = useState<string[]>([]);
  const [updateAds, setUpdateAds] = useState(false);
  const [loadTime, setLoadTime] = useState(
    Math.floor(Math.random() * 2000) + 2000,
  );
  const [activeTab, setactiveTab] = useState(0);

  useEffect(() => {
    if (!crash) {
      setTimeout(() => {
        setactiveTab(1);
      }, loadTime);
    } else {
      setactiveTab(1);
    }
  }, []);

  useEffect(() => {
    if (!crash) {
      setactiveTab(0);
      setTimeout(() => {
        setactiveTab(1);
      }, loadTime);
    }
  }, [crash]);

  useEffect(() => {
    const shownAds: string[] = [];
    const range = wikiAds.length;
    const firstEntry = Math.floor(Math.random() * range);
    let secondEntry = Math.floor(Math.random() * range);
    if (firstEntry === secondEntry) {
      if (secondEntry === range) {
        secondEntry--;
      } else {
        secondEntry++;
      }
    }
    shownAds.push(wikiAds[firstEntry]);
    shownAds.push(wikiAds[secondEntry]);
    shownAds.push(
      WikiAdColors[Math.floor(Math.random() * WikiAdColors.length)],
    );
    shownAds.push(
      WikiAdColors[Math.floor(Math.random() * WikiAdColors.length)],
    );
    setDisplayedAds(shownAds);
  }, [updateAds]);

  const tabs: React.JSX.Element[] = [];
  tabs[0] = <WikiLoadingPage endTime={loadTime - 500} />;
  tabs[1] = crash ? (
    <WikiErrorPage />
  ) : (
    <Section fill title="Bingle Search">
      {searchmode && search ? (
        <WikiSearchPage
          onUpdateAds={setUpdateAds}
          updateAds={updateAds}
          searchmode={searchmode}
          search={search}
          print={print}
          subCats={sub_categories}
          botany_data={botany_data}
          ore_data={ore_data}
          material_data={material_data}
          particle_data={particle_data}
          catalog_data={catalog_data}
        />
      ) : (
        <WikiMainPage displayedAds={displayedAds} />
      )}
    </Section>
  );

  return (
    <Window width={900} height={600} theme="bingle">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            {errorText && (
              <NoticeBox warning>
                <Box verticalAlign="middle">{errorText}</Box>
              </NoticeBox>
            )}
          </Stack.Item>
          <Stack.Item grow />
          {tabs[activeTab]}
        </Stack>
      </Window.Content>
    </Window>
  );
};
