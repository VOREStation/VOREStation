import { useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, NoticeBox, Section, Stack } from 'tgui-core/components';

import {
  WikiAdColors,
  wikiAds,
  wikiDonatedMessages,
  WikiDonationMessages,
  WikiTippOfTheDay,
} from './constants';
import type { Data } from './types';
import { WikiDonationBanner } from './WikiPages/WIkiDonationbanner';
import { WikiErrorPage } from './WikiPages/WikiErrorPage';
import { WikiLoadingPage } from './WikiPages/WikiLoadingPage';
import { WikiMainPage } from './WikiPages/WikiMainPage';
import { WikiSearchPage } from './WikiPages/WikiSearchPage';

export const PublicLibraryWiki = (props) => {
  const { data } = useBackend<Data>();
  const {
    crash,
    errorText,
    searchmode,
    search,
    print,
    sub_categories,
    food_data,
    drink_data,
    chemistry_data,
    botany_data,
    material_data,
    particle_data,
    catalog_data,
    ore_data,
    has_donated,
    donated,
    goal,
  } = data;
  const tippOfTheDay = useRef(
    WikiTippOfTheDay[Math.floor(Math.random() * WikiTippOfTheDay.length)],
  );

  const [displayedAds, setDisplayedAds] = useState<string[][]>([]);
  const [displayDonation, setDislayDonation] = useState(false);
  const [displayedDonations, setDisplayedDonations] = useState<string>('');
  const [displayedDonated, setDisplayDonated] = useState<string>('');
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
    } else {
      setLoadTime(Math.floor(Math.random() * 2000) + 2000);
    }
  }, [crash]);

  useEffect(() => {
    let shownAds: string[] = [];
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
    const addEntries: string[][] = [];
    shownAds.push(wikiAds[firstEntry]);
    shownAds.push(
      WikiAdColors[Math.floor(Math.random() * WikiAdColors.length)],
    );
    addEntries.push([...shownAds]);
    shownAds = [];
    shownAds.push(wikiAds[secondEntry]);
    shownAds.push(
      WikiAdColors[Math.floor(Math.random() * WikiAdColors.length)],
    );
    addEntries.push([...shownAds]);
    setDisplayedAds(addEntries);

    if (Math.random() < 0.2 && !displayDonation) {
      setDislayDonation(true);
    }
  }, [updateAds]);

  useEffect(() => {
    if (displayDonation && !has_donated) {
      setDisplayedDonations(
        WikiDonationMessages[
          Math.floor(Math.random() * WikiDonationMessages.length)
        ],
      );
    }
  }, [displayDonation]);

  useEffect(() => {
    if (has_donated) {
      setDisplayDonated(
        wikiDonatedMessages[
          Math.floor(Math.random() * wikiDonatedMessages.length)
        ],
      );
      setTimeout(() => {
        setDislayDonation(false);
      }, 5000);
    }
  }, [has_donated]);

  const tabs: React.JSX.Element[] = [];
  tabs[0] = (
    <WikiLoadingPage endTime={loadTime - 500} tipp={tippOfTheDay.current} />
  );
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
          food_data={food_data}
          drink_data={drink_data}
          chemistry_data={chemistry_data}
          botany_data={botany_data}
          ore_data={ore_data}
          material_data={material_data}
          particle_data={particle_data}
          catalog_data={catalog_data}
        />
      ) : (
        <WikiMainPage
          displayedAds={displayedAds}
          donationSuccess={donated >= goal}
        />
      )}
    </Section>
  );

  return (
    <Window width={900} height={600} theme="bingle">
      <Window.Content>
        <Stack vertical fill>
          {!!errorText && (
            <Stack.Item>
              <NoticeBox warning>
                <Box textAlign="center">{errorText}</Box>
              </NoticeBox>
            </Stack.Item>
          )}
          {!crash && displayDonation && !!activeTab && (
            <Stack.Item>
              <WikiDonationBanner
                donated={donated}
                goal={goal}
                displayedMessage={
                  has_donated ? displayedDonated : displayedDonations
                }
                hasDonated={has_donated}
                onDisplayedDonations={setDislayDonation}
              />
            </Stack.Item>
          )}
          <Stack.Item grow />
          {tabs[activeTab]}
        </Stack>
      </Window.Content>
    </Window>
  );
};
