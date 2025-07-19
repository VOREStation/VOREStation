import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

import { NetworkGraph } from './networkGraph';
import { type GraphNodeData, type NodeInstance } from './types';
import { type Log } from './types';

type Data = {
  theme: string;
  userName: string;
  networkTree: NodeInstance[];
  logs: Log[];
  macros: Record<string, string>; // key is name/alias, value is command
  homeNode: string; // The node the user is currently on if it exists.
};

// --- Layout nodes ---
import { useState } from 'react';
import { Box, Input, Section, Stack, TextArea } from 'tgui-core/components';

import { HelpBox } from './helpBox';
import { LogContainer } from './LogContainer';
import { MacroBox } from './macroBox';
import { layoutNetwork } from './util';
export type LogData = {};

export const CommandlineTerminal = () => {
  const { act, data } = useBackend<Data>();
  const [defaultCommand, setDefaultCommand] = useState('>');
  const nodes: (GraphNodeData & { id: string })[] = layoutNetwork(
    data.networkTree,
    0,
    0,
    80,
  ).map((node, idx) => ({
    ...node,
    id: String(idx),
  }));
  return (
    <Window width={1200} height={700} theme="cyberpunk">
      <Stack fill>
        <Stack.Item>
          <Section fill>
            <HelpBox />
            <MacroBox macros={data.macros} />
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Stack fill vertical>
            <Stack.Item grow>
              <Section fill>
                <LogContainer logs={data.logs} source={data.homeNode} />
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Input
                width="100%"
                height="100%"
                fontSize="20px"
                monospace
                value={defaultCommand}
                onChange={setDefaultCommand}
                onEnter={(value: string) => {
                  act('sendCommand', { command: value });
                  setDefaultCommand('>');
                }}
              />
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
