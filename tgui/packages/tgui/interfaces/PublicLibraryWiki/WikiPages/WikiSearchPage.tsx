import { type Dispatch, type SetStateAction, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

export const WikiSearchPage = (props: {
  onUpdateAds: Dispatch<SetStateAction<boolean>>;
  updateAds: boolean;
  title: string;
  searchmode: string;
  body: string;
  search: string[];
  print: string;
}) => {
  const { act } = useBackend();
  const [searchText, setSearchText] = useState('');
  const [activeEntry, setactiveEntry] = useState('');

  const { onUpdateAds, updateAds, title, searchmode, body, search, print } =
    props;

  const customSearch = createSearch(searchText, (search: string) => search);
  const toDisplay = search.filter(customSearch);

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
                    {toDisplay.map((Key) => (
                      <Stack.Item key={Key}>
                        <Button
                          selected={Key === activeEntry}
                          fluid
                          ellipsis
                          onClick={() => {
                            act('search', { data: Key });
                            setactiveEntry(Key);
                          }}
                        >
                          {Key}
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable title={title}>
            {/* eslint-disable-next-line react/no-danger */}
            <div dangerouslySetInnerHTML={{ __html: body }} />
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
