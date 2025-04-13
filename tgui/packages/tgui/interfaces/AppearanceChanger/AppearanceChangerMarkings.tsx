import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  ColorBox,
  ImageButton,
  Input,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { MARKINGS_PER_PAGE } from './constants';
import type { bodyStyle, Data } from './types';

export const AppearanceChangerMarkings = (props) => {
  const { act, data } = useBackend<Data>();

  const { markings, marking_styles } = data;

  const [searchText, setSearchText] = useState<string>('');
  const [tabIndex, setTabIndex] = useState(0);

  const searcher = createSearch(searchText, (style: bodyStyle) => {
    return style.name;
  });

  const filteredStyles = marking_styles.filter(searcher);

  filteredStyles.sort((a, b) =>
    a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
  );
  const styleTabCount = Math.ceil(filteredStyles.length / MARKINGS_PER_PAGE);

  const shownStyles: bodyStyle[][] = [];

  for (let i = 0; i < styleTabCount; i++) {
    shownStyles[i] = filteredStyles.slice(
      i * MARKINGS_PER_PAGE,
      i * MARKINGS_PER_PAGE + MARKINGS_PER_PAGE,
    );
  }

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Input
          fluid
          placeholder={'Search for markings...'}
          value={searchText}
          onChange={(val) => setSearchText(val)}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Markings" fill scrollable>
          <Stack vertical>
            <Stack.Item>
              <LabeledList>
                {markings.map((m) => (
                  <LabeledList.Item key={m.marking_name} label={m.marking_name}>
                    <Stack>
                      <Stack.Item grow />
                      <Stack.Item>
                        <ColorBox color={m.marking_color} mr={1} />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          onClick={() =>
                            act('marking', { todo: 4, name: m.marking_name })
                          }
                        >
                          Change Color
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          onClick={() =>
                            act('marking', { todo: 0, name: m.marking_name })
                          }
                        >
                          -
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          onClick={() =>
                            act('marking', { todo: 3, name: m.marking_name })
                          }
                        >
                          Move down
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          onClick={() =>
                            act('marking', { todo: 2, name: m.marking_name })
                          }
                        >
                          Move up
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <Tabs>
                <Stack wrap="wrap" justify="center">
                  {shownStyles.map((_, i) => (
                    <Stack.Item key={i}>
                      <Tabs.Tab
                        selected={tabIndex === i}
                        onClick={() => setTabIndex(i)}
                      >
                        Page {i + 1}
                      </Tabs.Tab>
                    </Stack.Item>
                  ))}
                </Stack>
              </Tabs>
            </Stack.Item>
            <Stack.Item>
              <Stack wrap="wrap" justify="center">
                {shownStyles[tabIndex]?.map((style) => (
                  <Stack.Item key={style.name}>
                    <ImageButton
                      tooltip={style.name}
                      dmIcon={style.icon}
                      dmIconState={style.icon_state}
                      onClick={() => {
                        act('marking', { todo: 1, name: style.name });
                      }}
                    >
                      {style.name}
                    </ImageButton>
                  </Stack.Item>
                ))}
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
