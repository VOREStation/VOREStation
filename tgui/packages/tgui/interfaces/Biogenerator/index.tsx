import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Stack } from 'tgui-core/components';
import { BiogeneratorItems } from './BiogeneratorItems';
import { BiogeneratorSearch } from './BiogeneratorSearch';
import type { Data } from './types';

export const Biogenerator = (props) => {
  const { act, data } = useBackend<Data>();

  const { processing, points, beaker } = data;

  const [searchText, setSearchText] = useState<string>('');
  const [sortOrder, setSortOrder] = useState<string>('Alphabetical');
  const [descending, setDescending] = useState<boolean>(false);

  return (
    <Window width={520} height={600}>
      <Window.Content className="Layout__content--flexColumn" scrollable>
        {(processing && (
          <Section fill title="Processing">
            The biogenerator is processing reagents!
          </Section>
        )) || (
          <Stack fill vertical>
            <Stack.Item>
              <Section>
                {points} points available.
                <Button ml={1} icon="blender" onClick={() => act('activate')}>
                  Activate
                </Button>
                <Button
                  ml={1}
                  icon="eject"
                  disabled={!beaker}
                  onClick={() => act('detach')}
                >
                  Eject Beaker
                </Button>
              </Section>
            </Stack.Item>
            <Stack.Item>
              <BiogeneratorSearch
                searchText={searchText}
                sortOrder={sortOrder}
                descending={descending}
                onSearchText={setSearchText}
                onSortOrder={setSortOrder}
                onDescending={setDescending}
              />
            </Stack.Item>
            <Stack.Item grow>
              <BiogeneratorItems
                searchText={searchText}
                sortOrder={sortOrder}
                descending={descending}
              />
            </Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};
