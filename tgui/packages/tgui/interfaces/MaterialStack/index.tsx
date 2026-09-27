import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Input, Section, Stack } from 'tgui-core/components';
import { RecipeList } from './RecipeList';
import type { Data } from './types';

export const MaterialStack = (props) => {
  const { data } = useBackend<Data>();

  const { amount, recipes } = data;
  const [searchText, setSearchText] = useState('');

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <Section title={`Amount: ${amount}`}>
          <Stack vertical>
            <Stack.Item>
              <Input
                fluid
                placeholder="Search for recipe..."
                value={searchText}
                onChange={(val) => setSearchText(val)}
              />
            </Stack.Item>
            <Stack.Item>
              <RecipeList recipes={recipes} searchText={searchText} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
