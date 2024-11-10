import { useState } from 'react';
import { Button, Input, Section, Stack } from 'tgui-core/components';

import { robotSpriteSearcher } from './functions';
import { SelectorElement } from './SelectorElement';
import { spriteOption } from './types';

export const SpriteSection = (props: {
  title: string;
  sortable?: spriteOption[];
  selected?: string;
}) => {
  const { title, sortable, selected } = props;

  const [searchText, setSearchText] = useState<string>('');
  const [includeDefault, setIncludeDefault] = useState<boolean>(true);
  const [includeDog, setInclideDog] = useState<boolean>(true);
  const [includeTall, setIncludeTall] = useState<boolean>(true);

  const filtered = robotSpriteSearcher(
    searchText,
    includeDefault,
    includeDog,
    includeTall,
    sortable,
  );
  return (
    <Section
      title={title}
      fill
      scrollable
      width="30%"
      buttons={
        <>
          <Button.Checkbox
            checked={includeDefault}
            onClick={() => setIncludeDefault(!includeDefault)}
          >
            Def
          </Button.Checkbox>
          <Button.Checkbox
            checked={includeDog}
            onClick={() => setInclideDog(!includeDog)}
          >
            Wide
          </Button.Checkbox>
          <Button.Checkbox
            checked={includeTall}
            onClick={() => setIncludeTall(!includeTall)}
          >
            Tall
          </Button.Checkbox>
        </>
      }
    >
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
