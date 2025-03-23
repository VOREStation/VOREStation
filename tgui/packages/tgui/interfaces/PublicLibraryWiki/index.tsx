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
  const { errorText, searchmode, search, title, body, print, appliance } = data;
  const [displayedAds, setDisplayedAds] = useState<string[]>([]);
  const [updateAds, setUpdateAds] = useState(false);
  const [loadTime, setLoadTime] = useState(
    Math.floor(Math.random() * 2000) + 2000,
  );
  const [activeTab, setactiveTab] = useState(0);

  useEffect(() => {
    setTimeout(() => {
      setactiveTab(1);
    }, loadTime);
  }, []);

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
  tabs[1] = !search ? (
    <WikiErrorPage />
  ) : (
    <Section fill title="Bingle Search">
      {searchmode && search ? (
        <WikiSearchPage
          onUpdateAds={setUpdateAds}
          updateAds={updateAds}
          title={title}
          searchmode={searchmode}
          body={body}
          search={search}
          print={print}
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
