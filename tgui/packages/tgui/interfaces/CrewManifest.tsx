import { useBackend } from '../backend';
import { Box, Section, Table } from '../components';
import { Window } from '../layouts';
import { COLORS } from '../constants';
import { decodeHtmlEntities } from 'common/string';

/*
 * Shared by the following templates (and used individually too)
 * - Communicator.js
 * - IdentificationComputer.js
 * - pda/pda_manifest.js
 * In order to fuel this UI, you must use the following code in your ui_data (or static data, doesn't really matter)
 * ```dm
if(data_core)
    data_core.get_manifest_list()
data["manifest"] = PDA_Manifest
 * ```
 */

export const CrewManifest = () => {
  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <CrewManifestContent />
      </Window.Content>
    </Window>
  );
};

type Data = {
  manifest: {
    elems: { name: string; rank: string; active: string }[];
    cat: string;
  }[];
};

export const CrewManifestContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { manifest } = data;

  return (
    <Section title="Crew Manifest" noTopPadding>
      {manifest.map(
        (cat) =>
          !!cat.elems.length && (
            <Section
              title={
                <Box
                  backgroundColor={COLORS.manifest[cat.cat.toLowerCase()]}
                  m={-1}
                  pt={1}
                  pb={1}>
                  <Box ml={1} textAlign="center" fontSize={1.4}>
                    {cat.cat}
                  </Box>
                </Box>
              }
              key={cat.cat}>
              <Table>
                <Table.Row header color="white">
                  <Table.Cell>Name</Table.Cell>
                  <Table.Cell>Rank</Table.Cell>
                  <Table.Cell>Active</Table.Cell>
                </Table.Row>
                {cat.elems.map((person) => (
                  <Table.Row color="average" key={person.name + person.rank}>
                    <Table.Cell>{decodeHtmlEntities(person.name)}</Table.Cell>
                    <Table.Cell>{person.rank}</Table.Cell>
                    <Table.Cell>{person.active}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          )
      )}
    </Section>
  );
};
