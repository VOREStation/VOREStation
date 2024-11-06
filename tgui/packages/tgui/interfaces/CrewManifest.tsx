import { decodeHtmlEntities } from 'common/string';
import { useBackend } from 'tgui/backend';
import { COLORS } from 'tgui/constants';
import { Window } from 'tgui/layouts';
import { Box, Section, Table } from 'tgui-core/components';

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

  if (manifest.length === 0) {
    return <Box color="average">No Manifest Data</Box>;
  }

  let crew_count = manifest
    .map((val) => val.elems.length)
    .reduce((a, c) => a + c, 0);
  if (!crew_count) {
    return <Box color="average">No Crew Detected</Box>;
  }

  return (
    <Section>
      <Table>
        {manifest.map(
          (department) =>
            !!department.elems.length && (
              <>
                <Table.Row header>
                  <Table.Cell colSpan={3} textAlign="center" fontSize={1.4}>
                    <Box
                      pt={1}
                      pb={1}
                      mb={-1.2}
                      mt={2}
                      backgroundColor={
                        COLORS.manifest[department.cat.toLowerCase()]
                      }
                    >
                      {department.cat}
                    </Box>
                    {/* This uses style={{ height }} to avoid being turned into REM and causing rounding errors */}
                    <Box
                      backgroundColor="blue"
                      mt={1}
                      style={{ height: '2px' }}
                    >
                      &nbsp;
                    </Box>
                  </Table.Cell>
                </Table.Row>
                <Table.Row header color="white">
                  <Table.Cell>Name</Table.Cell>
                  <Table.Cell>Rank</Table.Cell>
                  <Table.Cell>Active</Table.Cell>
                </Table.Row>
                {department.elems.map((person) => (
                  <Table.Row color="average" key={person.name + person.rank}>
                    <Table.Cell>{decodeHtmlEntities(person.name)}</Table.Cell>
                    <Table.Cell>{person.rank}</Table.Cell>
                    <Table.Cell>{person.active}</Table.Cell>
                  </Table.Row>
                ))}
              </>
            ),
        )}
      </Table>
    </Section>
  );
};
