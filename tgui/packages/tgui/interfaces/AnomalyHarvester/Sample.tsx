import { useBackend } from 'tgui/backend';
import { Box, Button, DmIcon, Section, Stack } from 'tgui-core/components';
import type { Data } from './types';

export const SampleDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { samples = [] } = data;

  return (
    <Section fill scrollable title="Generated Anomalous Material">
      <Stack fill>
        {samples.length > 0 && (
          <Stack.Item grow>
            {samples.map((sample, index) => {
              return (
                <Box
                  key={index}
                  style={{
                    marginBottom: '0.5rem',
                    padding: '0.5rem',
                    border: '1px solid #ccc',
                  }}
                >
                  <Stack>
                    <Stack.Item>
                      <DmIcon
                        icon={sample.icon}
                        icon_state={sample.icon_state}
                        width={sample.width}
                        height={sample.height}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box style={{ paddingLeft: '0.5rem' }}>{sample.name}</Box>
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
                </Box>
              );
            })}
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};
