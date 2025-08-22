import { useState } from 'react';
import { Button, Input, Section, Stack } from 'tgui-core/components';
import { CATEGORY_ALL } from './constants';
import type { CategoryBarProps } from './types';

export const CategoryBar = (props: CategoryBarProps) => {
  const sorted = [...props.options].sort();
  const [categorySearch, setCategorySearch] = useState('');

  return (
    <Section
      title="Categories"
      scrollableHorizontal
      buttons={
        <Input
          placeholder="Search"
          value={categorySearch}
          onChange={setCategorySearch}
        />
      }
    >
      <Stack>
        <Stack.Item>
          <Button
            selected={props.active === ''}
            onClick={() => props.setActive('')}
          >
            None
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            tooltip="This can be slow!"
            selected={props.active === CATEGORY_ALL}
            onClick={() => props.setActive(CATEGORY_ALL)}
          >
            All
          </Button>
        </Stack.Item>
        {sorted
          .filter((cat) =>
            cat.toLowerCase().includes(categorySearch.toLowerCase()),
          )
          .map((category) => (
            <Stack.Item key={category}>
              <Button
                selected={category === props.active}
                onClick={() => props.setActive(category)}
              >
                {category}
              </Button>
            </Stack.Item>
          ))}
      </Stack>
    </Section>
  );
};
