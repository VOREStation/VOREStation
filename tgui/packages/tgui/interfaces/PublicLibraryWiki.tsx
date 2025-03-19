/* eslint react/no-danger: "off" */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';

type Data = {
  errorText: string;
  searchmode: string;
  search: string[];
  title: string;
  body: string;
  ad_string1: string;
  ad_string2: string;
  print: string;
  appliance: string;
};

export const PublicLibraryWiki = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    errorText,
    searchmode,
    search,
    title,
    body,
    ad_string1,
    ad_string2,
    print,
    appliance,
  } = data;

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
              <Button icon="arrow-left" onClick={() => act('closesearch')}>
                Back
              </Button>
              {!!print && (
                <Button icon="print" onClick={() => act('print')}>
                  Print
                </Button>
              )}
              <Section title={title}>
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
                    {ad_string1}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button icon="download" onClick={() => act('crash')}>
                    {ad_string2}
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
