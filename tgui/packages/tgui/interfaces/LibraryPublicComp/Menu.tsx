import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';

import type { Data } from './types';

export const LibraryMainMenu = (props) => {
  const { act, data } = useBackend<Data>();

  const { is_public } = data;

  const menu_entries_checkout = [
    ['Scanned Inventory', 'inventory'],
    ['Checkout a Book', 'checking'],
    ['Checkout Status', 'checkedout'],
  ];
  const menu_entries_archive = [
    ['Upload New Title to Archive', 'upload'],
    ['Access Station Archive', 'archive'],
    ['Download Books Online', 'online'],
  ];
  const menu_entries_public = [
    ['Search Station Archive', 'publicarchive'],
    ['Search Online Archive', 'publiconline'],
  ];
  let menu_entries_misc = [['Print a Bible', 'bible']];
  if (data.emagged) {
    const arcane_misc = [['Forbidden Lore Vault', 'arcane']];
    menu_entries_misc = [...menu_entries_misc, ...arcane_misc];
  }

  return is_public ? (
    <Section>
      <Section title="Catalog Browser">
        {menu_entries_public.map((entry) => (
          <Box key={entry[0]}>
            <Button
              icon="eye"
              onClick={() => act('switchscreen', { switchscreen: entry[1] })}
            >
              {entry[0]}
            </Button>
          </Box>
        ))}
      </Section>
    </Section>
  ) : (
    <Section>
      <Section title="Checkout System">
        {menu_entries_checkout.map((entry) => (
          <Box key={entry[0]}>
            <Button
              icon="eye"
              onClick={() => act('switchscreen', { switchscreen: entry[1] })}
            >
              {entry[0]}
            </Button>
          </Box>
        ))}
      </Section>
      <Section title="Printable Archive">
        {menu_entries_archive.map((entry) => (
          <Box key={entry[0]}>
            <Button
              icon="eye"
              onClick={() => act('switchscreen', { switchscreen: entry[1] })}
            >
              {entry[0]}
            </Button>
          </Box>
        ))}
      </Section>
      <Section title="Misc">
        {menu_entries_misc.map((entry) => (
          <Box key={entry[0]}>
            <Button
              icon="eye"
              onClick={() => act('switchscreen', { switchscreen: entry[1] })}
            >
              {entry[0]}
            </Button>
          </Box>
        ))}
      </Section>
    </Section>
  );
};
