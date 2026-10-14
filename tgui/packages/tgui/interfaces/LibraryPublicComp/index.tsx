import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { LibraryMainMenu } from './Menu';
import { MenuArcane } from './MenuArcane';
import { MenuArchiveDownload } from './MenuArchiveDownload';
import { MenuArchiveInventory } from './MenuArchiveInventory';
import { MenuArchiveStation } from './MenuArchiveStation';
import { MenuCheckedOut } from './MenuCheckedOut';
import { MenuCheckingOut } from './MenuCheckingOut';
import { MenuHome } from './MenuHome';
import { MenuPublicDownload } from './MenuPublicDownload';
import { MenuPublicStation } from './MenuPublicStation';
import { MenuUpload } from './MenuUpload';
import type { Data } from './types';

export const LibraryPublicComp = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Window width={710} height={720}>
      <Window.Content>
        <Stack>
          <Stack.Item basis="33%">
            <LibraryMainMenu />
          </Stack.Item>
          <Stack.Item basis="66%">
            <MenuPage />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MenuPage = (props) => {
  const { act, data } = useBackend<Data>();
  const { screenstate } = data;

  const screen_menu = {
    home: <MenuHome />,
    inventory: <MenuArchiveInventory />,
    checkedout: <MenuCheckedOut />,
    checking: <MenuCheckingOut />,
    online: <MenuArchiveDownload />,
    upload: <MenuUpload />,
    arcane: <MenuArcane />,
    archive: <MenuArchiveStation />,
    publicarchive: <MenuPublicStation />,
    publiconline: <MenuPublicDownload />,
  };

  return screen_menu[screenstate] ? screen_menu[screenstate] : <MenuHome />;
};
