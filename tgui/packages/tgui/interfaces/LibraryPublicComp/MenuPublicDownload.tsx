import { useBackend } from 'tgui/backend';
import { Box, Divider, Section } from 'tgui-core/components';

import { MenuPageChanger } from './MenuParts';
import type { Data } from './types';

export const MenuPublicDownload = (props) => {
  const { act, data } = useBackend<Data>();

  const { inventory } = data;

  return (
    <Section title="Exonet Catalog">
      {inventory.length > 0 ? (
        inventory.map((book) => (
          <Section
            title={book.deleted ? `DELETED - ${book.title}` : book.title}
            key={book.id}
          >
            {book.author} - {book.category}
            <Divider />
          </Section>
        ))
      ) : (
        <Box>
          <br />
          <center>
            <h2>CANNOT CONNECT</h2>
          </center>
          <br />
          <center>Contact a librarian for support.</center>
        </Box>
      )}
      <Divider />
      <MenuPageChanger />
    </Section>
  );
};
