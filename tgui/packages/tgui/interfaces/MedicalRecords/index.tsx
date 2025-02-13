import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Section, Stack } from 'tgui-core/components';

import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../common/ComplexModal';
import { LoginInfo } from '../common/LoginInfo';
import { LoginScreen } from '../common/LoginScreen';
import { TemporaryNotice } from '../common/TemporaryNotice';
import { MedicalRecordsList } from './MedicalRecordsList';
import { MedicalRecordsMedbots } from './MedicalRecordsMedbots';
import {
  MedicalRecordsMaintenance,
  MedicalRecordsNavigation,
  MedicalRecordsView,
} from './MedicalRecordsOptions';
import { MedicalRecordsViruses } from './MedicalRecordsViruses';
import type { Data } from './types';
import { virusModalBodyOverride } from './virusModalBodyOverride';

export const MedicalRecords = (props) => {
  const { data } = useBackend<Data>();
  const { authenticated, screen } = data;
  if (!authenticated) {
    return (
      <Window width={800} height={380}>
        <Window.Content>
          <LoginScreen />
        </Window.Content>
      </Window>
    );
  }

  const body: React.JSX.Element[] = [];
  // List Records
  body[2] = <MedicalRecordsList />;
  // Record Maintenance
  body[3] = <MedicalRecordsMaintenance />;
  // View Records
  body[4] = <MedicalRecordsView />;
  // Virus Database
  body[5] = <MedicalRecordsViruses />;
  // Medbot Tracking
  body[6] = <MedicalRecordsMedbots />;

  return (
    <Window width={800} height={380}>
      <Window.Content>
        <ComplexModal maxHeight="100%" maxWidth="80%" />
        <Stack fill vertical>
          <Stack.Item>
            <LoginInfo />
          </Stack.Item>
          {!!data.temp && (
            <Stack.Item>
              <TemporaryNotice />
            </Stack.Item>
          )}
          <Stack.Item>
            <MedicalRecordsNavigation />
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              {(screen && body[screen]) || ''}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

modalRegisterBodyOverride('virus', virusModalBodyOverride);
