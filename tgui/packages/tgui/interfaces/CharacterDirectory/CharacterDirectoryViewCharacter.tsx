import { Box, Button, Section, Table } from 'tgui-core/components';

import { getTagColor } from './constants';
import type { mobEntry } from './types';

export const ViewCharacter = (props: {
  overlay: mobEntry;
  onOverlay: Function;
}) => {
  const { overlay, onOverlay } = props;

  return (
    <Section
      title={overlay.name}
      buttons={
        <Button icon="arrow-left" onClick={() => onOverlay(null)}>
          Back
        </Button>
      }
    >
      <Section title="Species">
        <Box>{overlay.species}</Box>
      </Section>
      <Section title="Vore Tag">
        <Box p={1} backgroundColor={getTagColor(overlay.tag)}>
          {overlay.tag}
        </Box>
      </Section>
      <Section title="Gender">
        <Box>{overlay.gendertag}</Box>
      </Section>
      <Section title="Sexuality">
        <Box>{overlay.sexualitytag}</Box>
      </Section>
      <Section title="ERP Tag">
        <Box>{overlay.erptag}</Box>
      </Section>
      <Section title="Event Pref">
        <Box>{overlay.eventtag}</Box>
      </Section>
      <Section title="Character Ad">
        <Box style={{ wordBreak: 'break-all' }} preserveWhitespace>
          {overlay.character_ad || 'Unset.'}
        </Box>
      </Section>
      <Section title="OOC Notes">
        <Box style={{ wordBreak: 'break-all' }} preserveWhitespace>
          {overlay.ooc_notes || 'Unset.'}
          {overlay.ooc_notes_style &&
          (overlay.ooc_notes_favs ||
            overlay.ooc_notes_likes ||
            overlay.ooc_notes_maybes ||
            overlay.ooc_notes_dislikes) ? (
            <Table>
              <Table.Row bold>
                {overlay.ooc_notes_favs ? (
                  <Table.Cell>FAVOURITES</Table.Cell>
                ) : (
                  ''
                )}
                {overlay.ooc_notes_likes ? <Table.Cell>LIKES</Table.Cell> : ''}
                {overlay.ooc_notes_maybes ? (
                  <Table.Cell>MAYBES</Table.Cell>
                ) : (
                  ''
                )}
                {overlay.ooc_notes_dislikes ? (
                  <Table.Cell>DISLIKES</Table.Cell>
                ) : (
                  ''
                )}
              </Table.Row>
              <Table.Row>
                <Table.Cell>
                  <br />
                </Table.Cell>
              </Table.Row>
              <Table.Row>
                {overlay.ooc_notes_favs ? (
                  <Table.Cell>{overlay.ooc_notes_favs}</Table.Cell>
                ) : (
                  ''
                )}
                {overlay.ooc_notes_likes ? (
                  <Table.Cell>{overlay.ooc_notes_likes}</Table.Cell>
                ) : (
                  ''
                )}
                {overlay.ooc_notes_maybes ? (
                  <Table.Cell>{overlay.ooc_notes_maybes}</Table.Cell>
                ) : (
                  ''
                )}
                {overlay.ooc_notes_dislikes ? (
                  <Table.Cell>{overlay.ooc_notes_dislikes}</Table.Cell>
                ) : (
                  ''
                )}
              </Table.Row>
            </Table>
          ) : (
            ''
          )}
        </Box>
      </Section>
      <Section title="Flavor Text">
        <Box style={{ wordBreak: 'break-all' }} preserveWhitespace>
          {overlay.flavor_text || 'Unset.'}
        </Box>
      </Section>
    </Section>
  );
};
