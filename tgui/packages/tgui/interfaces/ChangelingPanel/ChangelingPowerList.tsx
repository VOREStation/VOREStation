import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { getButtonColor } from './functions';
import type { powerData } from './types';

export const ChangeLingSearchableList = (props: {
  title: string;
  powerData: powerData[];
  points: number;
}) => {
  const { act } = useBackend();

  const { title, powerData, points } = props;

  const [searchText, setSearchText] = useState('');

  const searcher = createSearch(searchText, (power: powerData) => {
    return power.power_name;
  });

  const shownPowers = powerData.filter(searcher);

  return (
    <Stack.Item basis="49%" grow>
      <Section fill title={title}>
        <Stack vertical fill>
          <Stack.Item>
            <Input
              mr="10px"
              fluid
              value={searchText}
              placeholder={'Search for ' + title + '...'}
              onChange={(value: string) => setSearchText(value)}
            />
          </Stack.Item>
          <Divider />
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack vertical fill>
                {shownPowers
                  .sort((a, b) => a.power_name.localeCompare(b.power_name))
                  .map((entry) => (
                    <Stack.Item key={entry.power_name}>
                      <Button
                        fluid
                        tooltipPosition={
                          entry.power_purchased ? 'left' : 'right'
                        }
                        disabled={
                          points < entry.power_cost || entry.power_purchased
                        }
                        color={getButtonColor(entry, points)}
                        tooltip={entry.power_desc}
                        onClick={() =>
                          act('evolve_power', { val: entry.power_name })
                        }
                      >
                        <Stack>
                          <Stack.Item grow>{entry.power_name}</Stack.Item>
                          <Stack.Item>({entry.power_cost})</Stack.Item>
                        </Stack>
                      </Button>
                    </Stack.Item>
                  ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};
