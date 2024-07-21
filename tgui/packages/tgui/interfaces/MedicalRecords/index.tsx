import { useBackend } from '../../backend';
import { Section } from '../../components';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../../interfaces/common/ComplexModal';
import { Window } from '../../layouts';
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
import { Data } from './types';
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
      <ComplexModal maxHeight="100%" maxWidth="80%" />
      <Window.Content className="Layout__content--flexColumn" scrollable>
        <LoginInfo />
        <TemporaryNotice />
        <MedicalRecordsNavigation />
        <Section height="calc(100% - 5rem)" flexGrow>
          {(screen && body[screen]) || ''}
        </Section>
      </Window.Content>
    </Window>
  );
};

modalRegisterBodyOverride('virus', virusModalBodyOverride);
