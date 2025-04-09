import {
  ComplexModal,
  modalRegisterBodyOverride,
} from 'tgui/interfaces/common/ComplexModal';
import { Window } from 'tgui/layouts';
import { Section, Stack } from 'tgui-core/components';

import { SupplyConsoleMenu } from './SupplyConsoleMenu';
import { SupplyConsoleShuttleStatus } from './SupplyConsoleShuttleStatus';
import { viewCrateContents } from './viewCrateContents';

export const SupplyConsole = (props) => {
  modalRegisterBodyOverride('view_crate', viewCrateContents);
  return (
    <Window width={700} height={620}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <ComplexModal maxWidth="100%" />
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title="Supply Records">
              <Stack vertical fill>
                <Stack.Item>
                  <SupplyConsoleShuttleStatus />
                </Stack.Item>
                <Stack.Item grow>
                  <SupplyConsoleMenu />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
