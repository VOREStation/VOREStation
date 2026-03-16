import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { ChangeLingSearchableList } from './ChangelingPowerList';
import type { Data } from './types';

export const ChangelingPanel = (props) => {
  const { data } = useBackend<Data>();

  const { available_points, power_list } = data;

  const purchasedPowers = power_list.filter((entry) => entry.power_purchased);
  const unpurchasedPowers = power_list.filter(
    (entry) => !entry.power_purchased,
  );

  return (
    <Window width={600} height={700}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            Current evolution points left to evolve with: {available_points}
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <ChangeLingSearchableList
                title="Purchasable Powers"
                powerData={unpurchasedPowers}
                points={available_points}
              />
              <ChangeLingSearchableList
                title="Purchased Powers"
                powerData={purchasedPowers}
                points={available_points}
              />
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
