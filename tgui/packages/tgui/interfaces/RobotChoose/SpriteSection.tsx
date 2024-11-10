import { createSearch } from 'common/string';
import { useState } from 'react';
import { Input, Section, Stack } from 'tgui-core/components';

import { SelectorElement } from './SelectorElement';
import { spriteOption } from './types';

export const SpriteSection = (props: {
  title: string;
  sortable?: { sprite: string; belly: boolean }[];
  selected?: string;
}) => {
  const { title, sortable, selected } = props;

  const [searchText, setSearchText] = useState<string>('');

  const searcher = createSearch(searchText, (element: spriteOption) => {
    return element.sprite;
  });

  const filtered = sortable?.filter(searcher);
  return (
    <Section title={title} fill scrollable width="30%">
      <Stack.Item mb={'10px'}>
        <Input
          fluid
          value={searchText}
          placeholder="Search for modules..."
          onInput={(e, value: string) => setSearchText(value)}
        />
      </Stack.Item>
      <Stack.Item>
        <Stack vertical>
          {filtered &&
            filtered.map((filter) => (
              <SelectorElement
                key={filter.sprite}
                option={filter.sprite}
                action="pick_icon"
                selected={selected}
                belly={filter.belly}
              />
            ))}
        </Stack>
      </Stack.Item>
    </Section>
  );
};
