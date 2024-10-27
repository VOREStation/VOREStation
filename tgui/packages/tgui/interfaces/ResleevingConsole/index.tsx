import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Dimmer, Section, Stack } from 'tgui-core/components';

import { BodyRecordModal } from './BodyRecordModal';
import { MindRecordModal } from './MindRecordModal';
import {
  ResleevingConsoleCoreDump,
  ResleevingConsoleDiskPrep,
} from './ResleevingConsoleCoreDump';
import {
  ResleevingConsoleBody,
  ResleevingConsoleNavigation,
  ResleevingConsoleTemp,
} from './ResleevingConsoleElements';
import { ResleevingConsoleStatus } from './ResleevingConsoleStatus';
import { Data } from './types';

export const ResleevingConsole = (props) => {
  const { data } = useBackend<Data>();
  const { coredumped, emergency } = data;
  let body: React.JSX.Element = (
    <Stack fill vertical>
      <ResleevingConsoleTemp />
      <Stack.Item>
        <ResleevingConsoleStatus />
      </Stack.Item>
      <Stack.Item>
        <ResleevingConsoleNavigation />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill>
          <ResleevingConsoleBody />
        </Section>
      </Stack.Item>
    </Stack>
  );
  if (coredumped) {
    body = <ResleevingConsoleCoreDump />;
  }
  if (emergency) {
    body = <ResleevingConsoleDiskPrep />;
  }
  return (
    <Window width={640} height={520}>
      {data.active_b_rec && (
        <Dimmer>
          <BodyRecordModal data={data.active_b_rec} />
        </Dimmer>
      )}
      {data.active_m_rec && (
        <Dimmer>
          <MindRecordModal data={data.active_m_rec} />
        </Dimmer>
      )}
      <Window.Content>{body}</Window.Content>
    </Window>
  );
};
