import { useState } from 'react';
import { Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { SelectorElement } from './SelectorElement';

export const ModuleSection = (props: {
  title: string;
  sortable?: string[];
  selected?: string;
}) => {
  const { title, sortable, selected } = props;

  const [searchText, setSearchText] = useState<string>('');

  const searcher = createSearch(searchText, (element: string) => {
    return element;
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
        <Stack vertical fill>
          {!!filtered &&
            filtered.map((filter) => (
              <SelectorElement
                key={filter}
                option={filter}
                action="pick_module"
                selected={selected}
              />
            ))}
        </Stack>
      </Stack.Item>
    </Section>
  );
};
