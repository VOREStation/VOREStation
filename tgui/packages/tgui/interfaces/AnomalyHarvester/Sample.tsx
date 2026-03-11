import { useBackend } from 'tgui/backend';
import { Box, Button, DmIcon, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import type { Data } from './types';

export const SampleDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { samples } = data;

  return (
    <Section
      fill
      scrollable
      title="Generated Anomalous Material"
      buttons={
        <Button.Confirm
          disabled={!samples.length}
          onClick={() => act('release_all')}
        >
          Release All
        </Button.Confirm>
      }
    >
      <Stack vertical fill>
        {samples.length > 0 &&
          samples.map((sample) => {
            return (
              <Stack.Item
                key={sample.ref}
                style={{
                  padding: '0.5rem',
                  border: '1px solid #ccc',
                }}
              >
                <Stack align="center">
                  <Stack.Item>
                    <DmIcon icon={sample.icon} icon_state={sample.icon_state} />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box style={{ paddingLeft: '0.5rem' }}>
                      {capitalize(sample.name)}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      onClick={() =>
                        act('release_sample', {
                          ref: sample.ref,
                        })
                      }
                    >
                      Release
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            );
          })}
      </Stack>
    </Section>
  );
};
