import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

import { NetworkGraph } from './networkGraph';
import { type GraphNodeData } from './types';

type Data = {
  theme: string;
  userName: string;
};

// --- NetworkGraph.js-style config ---
const networkConfig = [
  {
    name: 'test',
    subs: [
      {
        name: 'LocalStorage',
        glitch: true,
        distortion: 0.1,
        latency: 12444,
      },
      { name: 'NetworkMnger', glitch: true, distortion: 0.1, latency: 90 },
    ],
  },
  {
    name: 'Network1',
    parent: 'Network With Subnetwork',
    glitch: true,
    distortion: 0.6,
    latency: 1,
    subs: ['A1', 'A2'],
  },
  {
    name: 'Network With Subnetwork',
    parent: 'test',
    subs: [
      { name: 'ExplosionNode', glitch: true, distortion: 0.1, latency: 250 },
      { name: 'WomanSensor', glitch: false, distortion: 0, latency: 250 },
    ],
  },
  {
    name: 'Random Robot',
    parent: 'test',
    subs: [
      { name: 'fsdfsd', glitch: false, distortion: 0, latency: 250 },
      { name: 'fsdfsd', glitch: false, distortion: 0, latency: 250 },
    ],
  },
];

// --- Layout nodes ---
import { Box, Section, Stack, TextArea } from 'tgui-core/components';

import { layoutNetwork } from './util'; // Ensure layoutNetwork is exported from './util'
const nodes: (GraphNodeData & { id: string })[] = layoutNetwork(
  networkConfig,
  'test',
  0,
  0,
  50,
).map((node, idx) => ({
  ...node,
  id: String(idx),
}));
export type LogData = {};

export const CommandlineTerminal = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={1200} height={700}>
      <Stack fill>
        <Stack.Item>
          <Section fill>probably put buttons here</Section>
        </Stack.Item>
        <Stack.Item grow>
          <Stack fill vertical>
            <Stack.Item grow>
              <Section fill>
                <Window.Content>
                  testing this is where outputs will go or something. Not
                  scrollable because the uhhhh network thing will be in here and
                  it&apos;ll be epic and have cool animations and stuff and um
                  yeah epic but also there&apos;ll be padding & it&apos;ll be
                  semitransparent
                </Window.Content>
              </Section>
            </Stack.Item>
            <Stack.Item>
              <TextArea fluid maxLength={1000} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack fill vertical reverse>
            <Stack.Item />
            <Box width={'300px'} height={'350px'}>
              <NetworkGraph nodes={nodes} theme={data.theme} />
            </Box>
            <Stack.Item />
            <Stack.Item grow>
              <TextArea fluid height="100%" maxLength={1000} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Window>
  );
};
