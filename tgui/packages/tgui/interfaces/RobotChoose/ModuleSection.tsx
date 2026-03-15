import { useState } from 'react';
import { Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { SelectorElement } from './SelectorElement';

export const ModuleSection = (props: {
  title: string;
  sortable?: string[];
  highlighted?: string[];
  selected?: string;
}) => {
  const { title, sortable, highlighted, selected } = props;

  const [searchText, setSearchText] = useState<string>('');

  const searcher = createSearch<string>(searchText, (element) => {
    return element;
  });

  const filtered = sortable?.filter(searcher);

  return (
    <Section title={title} fill>
      <Stack vertical fill>
        <Stack.Item>
          <Input
            fluid
            value={searchText}
            placeholder="Search for modules..."
            onChange={(value: string) => setSearchText(value)}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item grow>
          <Section fill scrollable>
            <Stack vertical fill>
              {!!filtered &&
                filtered.map((filter) => (
                  <SelectorElement
                    key={filter}
                    option={filter}
                    icon={
                      highlighted?.includes(filter)
                        ? 'circle-exclamation'
                        : undefined
                    }
                    iconTooltip={'Module is whitelisted!'}
                    iconColor="red"
                    action="pick_module"
                    selected={selected}
                  />
                ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
