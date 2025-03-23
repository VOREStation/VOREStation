import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';

import { wikiAds } from './constants';
import type { Data } from './types';

export const PublicLibraryWiki = (props) => {
  const { act, data } = useBackend<Data>();
  const { errorText, searchmode, search, title, body, print, appliance } = data;
  const [displayedAds, setDisplayedAds] = useState<string[]>([]);
  const [updateAds, setUpdateAds] = useState(false);

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
    setDisplayedAds(shownAds);
  }, [updateAds]);

  return (
    <Window width={900} height={600}>
      <Window.Content>
        {errorText && (
          <NoticeBox warning>
            <Box verticalAlign="middle">{errorText}</Box>
          </NoticeBox>
        )}
        <Section title="Bingle Search">
          {(!!searchmode && (
            <Section>
              <Button
                icon="arrow-left"
                onClick={() => {
                  act('closesearch');
                  setUpdateAds(!updateAds);
                }}
              >
                Back
              </Button>
              {!!print && (
                <Button icon="print" onClick={() => act('print')}>
                  Print
                </Button>
              )}
              <Section title={title}>
                {/* eslint-disable-next-line react/no-danger */}
                <div dangerouslySetInnerHTML={{ __html: body }} />
              </Section>
              <Section title={searchmode}>
                {search.map((Key) => (
                  <Button
                    key={Key}
                    onClick={() => act('search', { data: Key })}
                  >
                    {Key}
                  </Button>
                ))}
              </Section>
            </Section>
          )) || (
            <Section>
              <h2>The galaxys 18th most tollerated* infocore dispenser!</h2>
              <LabeledList>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('foodsearch')}>
                    Food Recipes
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('drinksearch')}>
                    Drink Recipes
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('chemsearch')}>
                    Chemistry
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('botsearch')}>
                    Botany
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('oresearch')}>
                    Ores
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('matsearch')}>
                    Materials
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('smashsearch')}>
                    Particle Physics
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="search" onClick={() => act('catalogsearch')}>
                    Catalogs
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item />
                <LabeledList.Item>
                  <Button icon="download" onClick={() => act('crash')}>
                    {displayedAds[0]}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="download" onClick={() => act('crash')}>
                    {displayedAds[1]}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
