import { useBackend } from 'tgui/backend';
import { Box, Button, Divider, Section } from 'tgui-core/components';

import { MenuPageChanger } from './MenuParts';
import type { Data } from './types';

export const MenuArchiveStation = (props) => {
  const { act, data } = useBackend<Data>();

  const { inventory } = data;

  return (
    <Section title="Station Archive">
      {inventory.length > 0 ? (
        inventory.map((book) => (
          <Section
            title={book.deleted ? `DELETED - ${book.title}` : book.title}
            key={book.id}
          >
            {book.author} - {book.category}
            <br />
            <Button
              icon="eye"
              disabled={book.deleted}
              onClick={() =>
                act('import_external', { import_external: book.id })
              }
            >
              Print
            </Button>
            <Button.Confirm
              icon="eye"
              color="red"
              disabled={book.protected || book.deleted}
              onClick={() =>
                act('delete_external', { delete_external: book.id })
              }
            >
              {book.protected ? 'Protected' : 'Delete'}
            </Button.Confirm>
            {data.admin_mode ? (
              <Button
                icon="eye"
                color="green"
                onClick={() =>
                  act('protect_external', { protect_external: book.id })
                }
              >
                {book.deleted
                  ? 'Restore'
                  : book.protected
                    ? 'Unprotect'
                    : 'Protect'}
              </Button>
            ) : (
              ''
            )}
            <Divider />
          </Section>
        ))
      ) : (
        <Box>
          <br />
          <center>
            <h2>ARCHIVE EMPTY</h2>
          </center>
          <br />
          <center>Use linked scanner to upload new titles.</center>
        </Box>
      )}
      <Divider />
      <MenuPageChanger />
    </Section>
  );
};
