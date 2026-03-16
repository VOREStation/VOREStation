import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { BanningSection } from './Elements/BanningSection';
import { BanSearchResults } from './Elements/BanSearchResults';
import { SearchSection } from './Elements/SearchSection';
import type { Data } from './types';

export const BanPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    player_ckey,
    admin_ckey,
    player_ip,
    player_cid,
    bantype,
    min_search,
    possible_jobs,
    database_records,
  } = data;

  return (
    <Window width={1200} height={800} theme="admin">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item basis="30%">
            <BanningSection possibleJobs={possible_jobs} />
          </Stack.Item>
          <Stack.Item>
            <SearchSection
              searchedCkey={player_ckey || ''}
              searchedAdminCkey={admin_ckey || ''}
              searchedIp={player_ip || ''}
              searchedCid={player_cid || ''}
              searchedBanType={bantype || ''}
              minimumMatch={!!min_search}
            />
          </Stack.Item>
          <Stack.Item grow>
            <BanSearchResults database_records={database_records} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
