import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Dropdown,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { FilterEntry } from './FilterEntry';
import type { Data } from './typtes';

export const Filteriffic = (props) => {
  const { act, data } = useBackend<Data>();
  const name = data.target_name || 'Unknown Object';
  const filters = data.target_filter_data || {};
  const hasFilters = Object.keys(filters).length !== 0;
  const filterDefaults = data['filter_info'];
  const [massApplyPath, setMassApplyPath] = useState('');
  const [hiddenSecret, setHiddenSecret] = useState(false);

  return (
    <Window title="Filteriffic" width={500} height={500}>
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item>
            <NoticeBox danger>
              DO NOT MESS WITH EXISTING FILTERS IF YOU DO NOT KNOW THE
              CONSEQUENCES. YOU HAVE BEEN WARNED.
            </NoticeBox>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              title={
                hiddenSecret ? (
                  <>
                    <Box mr={0.5} inline>
                      MASS EDIT:
                    </Box>
                    <Input
                      value={massApplyPath}
                      width="100px"
                      onChange={setMassApplyPath}
                    />
                    <Button.Confirm
                      confirmContent="ARE YOU SURE?"
                      onClick={() => act('mass_apply', { path: massApplyPath })}
                    >
                      Apply
                    </Button.Confirm>
                  </>
                ) : (
                  <Box inline onDoubleClick={() => setHiddenSecret(true)}>
                    {name}
                  </Box>
                )
              }
              buttons={
                <Dropdown
                  selected={undefined}
                  icon="plus"
                  displayText="Add Filter"
                  noChevron
                  options={Object.keys(filterDefaults)}
                  onSelected={(value) =>
                    act('add_filter', {
                      name: 'default',
                      priority: 10,
                      type: value,
                    })
                  }
                />
              }
            >
              {!hasFilters ? (
                <Box>No filters</Box>
              ) : (
                Object.entries(filters).map(([name, filterData]) => (
                  <FilterEntry
                    filterDataEntry={filterData}
                    name={name}
                    key={name}
                  />
                ))
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
