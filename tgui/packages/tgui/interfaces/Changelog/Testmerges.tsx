import { useBackend } from 'tgui/backend';
import { Box, Collapsible, Section, Stack, Table } from 'tgui-core/components';
import { ChangeRow } from './ChangeRow';
import type { ChangelogData } from './types';

export const Testmerges = (_props) => {
  const {
    data: { testmerges },
  } = useBackend<ChangelogData>();

  if (testmerges.length < 1) {
    return null;
  }

  return (
    <>
      <Section px={1}>
        <h4>
          These are features being actively tested and developed on the server.
          Please report any issues or feedback to the original PR, or on the
          feedback thread on the Discord if there is one.
        </h4>
      </Section>
      <Stack vertical>
        {testmerges.map((testmerge) => {
          const title = (
            <a href={testmerge.link}>
              #{testmerge.number}: &quot;{testmerge.title}&quot; by{' '}
              {testmerge.author}
            </a>
          );
          return (
            <Stack.Item key={testmerge.number}>
              <Section title={title}>
                <Collapsible color="transparent" title="Changelog" open>
                  <Box ml={3}>
                    <Table>
                      {Object.entries(testmerge.changes).map(
                        ([kind, changes]) =>
                          changes.map((desc) => (
                            <ChangeRow
                              key={kind + desc}
                              kind={kind}
                              content={desc}
                            />
                          )),
                      )}
                    </Table>
                  </Box>
                </Collapsible>
              </Section>
            </Stack.Item>
          );
        })}
      </Stack>
    </>
  );
};
