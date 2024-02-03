/* eslint react/no-danger: "off" */
import { useBackend } from '../../backend';
import { Box, Button, Section, Table } from '../../components';

export const pda_notekeeper = (props) => {
  const { act, data } = useBackend();

  const { note, notename } = data;

  return (
    <Box>
      <Section>
        {/* Lets just be nice and lazy with this, multinote support!. */}
        <Table>
          <Table.Row header>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note1')}
                content="Note A"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note2')}
                content="Note B"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note3')}
                content="Note C"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note4')}
                content="Note D"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note5')}
                content="Note E"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note6')}
                content="Note F"
              />
            </Table.Cell>
          </Table.Row>
          <Table.Row header>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note7')}
                content="Note G"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note8')}
                content="Note H"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note9')}
                content="Note I"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note10')}
                content="Note J"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note11')}
                content="Note K"
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                icon="sticky-note-o"
                onClick={() => act('Note12')}
                content="Note L"
              />
            </Table.Cell>
          </Table.Row>
        </Table>
      </Section>
      <Section title={notename}>
        <Button icon="pen" onClick={() => act('Edit')} content="Edit Note" />
        <Button
          icon="file-word"
          onClick={() => act('Titleset')}
          content="Edit Title"
        />
        <Button
          icon="sticky-note-o"
          onClick={() => act('Print')}
          content="Print Note"
        />
      </Section>
      <Section>
        {/* As usual with dangerouslySetInnerHTML,
            this notekeeper was designed to use HTML injection.
            Fix when markdown is easier. */}
        <div dangerouslySetInnerHTML={{ __html: note }} />
      </Section>
    </Box>
  );
};
