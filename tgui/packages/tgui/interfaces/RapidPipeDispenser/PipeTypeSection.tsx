import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Section, Tabs } from 'tgui-core/components';

import { ICON_BY_CATEGORY_NAME } from './constants';
import type { Data } from './types';

export const PipeTypeSection = (props) => {
  const { act, data } = useBackend<Data>();
  const { categories = [] } = data;
  const [categoryName, setCategoryName] = useState('categoryName');
  const shownCategory =
    categories.find((category) => category.cat_name === categoryName) ||
    categories[0];
  return (
    <Section fill scrollable>
      <Tabs fluid>
        {categories.map((category, i) => (
          <Tabs.Tab
            key={category.cat_name}
            icon={ICON_BY_CATEGORY_NAME[category.cat_name]}
            selected={category.cat_name === shownCategory.cat_name}
            onClick={() => setCategoryName(category.cat_name)}
          >
            {category.cat_name}
          </Tabs.Tab>
        ))}
      </Tabs>
      {shownCategory?.recipes.map((recipe) => (
        <Button.Checkbox
          key={recipe.pipe_index}
          fluid
          ellipsis
          checked={recipe.selected}
          tooltip={recipe.pipe_name}
          onClick={() =>
            act('pipe_type', {
              pipe_type: recipe.pipe_index,
              category: shownCategory.cat_name,
            })
          }
        >
          {recipe.pipe_name}
        </Button.Checkbox>
      ))}
    </Section>
  );
};
