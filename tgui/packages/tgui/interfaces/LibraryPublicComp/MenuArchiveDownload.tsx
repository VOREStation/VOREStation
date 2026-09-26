import { useBackend } from 'tgui/backend';
import { Box, Button, Divider, Section } from 'tgui-core/components';

import type { Data } from './types';

export const MenuArchiveDownload = (props) => {
  const { act, data } = useBackend<Data>();

  const { inventory } = data;

  return (
    <Section title="Browsing Exonet">
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
              onClick={() => act('hardprint', { hardprint: book.type })}
            >
              Print
            </Button>
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
          <center>Exonet archive could not be reached.</center>
        </Box>
      )}
      <Divider />
      <Box>
        <center>
          <Button icon="eye" onClick={() => act('inv_page')}>
            Prev
          </Button>
          <Button icon="eye" onClick={() => act('inv_page')}>
            Next
          </Button>
        </center>
      </Box>
    </Section>
  );
};
