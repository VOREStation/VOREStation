import { type Dispatch, type SetStateAction, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Input, Section, Stack } from 'tgui-core/components';
import { capitalize, createSearch } from 'tgui-core/string';

import { PageData } from '../types';
import { WikiMaterialPage } from '../WikiSubPages/WikiMaterialPage';

export const WikiSearchPage = (
  props: {
    onUpdateAds: Dispatch<SetStateAction<boolean>>;
    updateAds: boolean;
    searchmode: string;
    search: string[];
    print: string;
  } & Partial<PageData>,
) => {
  const { act } = useBackend();
  const [searchText, setSearchText] = useState('');
  const [activeEntry, setactiveEntry] = useState('');

  const { onUpdateAds, updateAds, searchmode, material_data, search, print } =
    props;

  const customSearch = createSearch(searchText, (search: string) => search);
  const toDisplay = search.filter(customSearch);

  const tabs: React.JSX.Element[] = [];
  tabs['Food Recipes'] = null;
  tabs['Drink Recipes'] = null;
  tabs['Chemistry'] = null;
  tabs['Botany'] = null;
  tabs['Catalogs'] = null;
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
        <Stack.Item basis="30%">
          <Section fill title={searchmode}>
            <Stack vertical fill>
              <Stack.Item>
                <Input
                  mr="10px"
                  fluid
                  value={searchText}
                  placeholder={'Search for ' + searchmode + '...'}
                  onInput={(e, value: string) => setSearchText(value)}
                />
              </Stack.Item>
              <Divider />
              <Stack.Item grow>
                <Section fill scrollable>
                  <Stack vertical fill>
                    {toDisplay.map((entry) => (
                      <Stack.Item key={entry}>
                        <Button
                          selected={entry === activeEntry}
                          fluid
                          ellipsis
                          onClick={() => {
                            act('search', { data: entry });
                            setactiveEntry(entry);
                          }}
                        >
                          {capitalize(entry)}
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item grow>{tabs[searchmode]}</Stack.Item>
      </Stack>
    </Section>
  );
};
