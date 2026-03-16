import { useState } from 'react';
import { Input, Section, Tabs, Tooltip } from 'tgui-core/components';
import { CATEGORY_ALL } from './constants';
import type { CategoryBarProps } from './types';

export const CategoryBar = (props: CategoryBarProps) => {
  const { options, active, setActive } = props;

  const sorted = [...options].sort();
  const [categorySearch, setCategorySearch] = useState('');

  return (
    <Section
      title="Categories"
      buttons={
        <Input
          placeholder="Search"
          value={categorySearch}
          onChange={setCategorySearch}
        />
      }
    >
      <Tabs scrollable>
        <Tabs.Tab selected={active === ''} onClick={() => setActive('')}>
          None
        </Tabs.Tab>
        <Tooltip content="This can be slow!">
          <Tabs.Tab
            icon="warning"
            selected={active === CATEGORY_ALL}
            onClick={() => setActive(CATEGORY_ALL)}
          >
            All
          </Tabs.Tab>
        </Tooltip>
        {sorted
          .filter((cat) =>
            cat.toLowerCase().includes(categorySearch.toLowerCase()),
          )
          .map((category) => (
            <Tabs.Tab
              key={category}
              selected={category === active}
              onClick={() => setActive(category)}
            >
              {category}
            </Tabs.Tab>
          ))}
      </Tabs>
    </Section>
  );
};
