import { useBackend } from '../../backend';
import { Section } from '../../components';
import { ComplexModal } from '../../interfaces/common/ComplexModal';
import { Window } from '../../layouts';
import { LoginInfo } from '../common/LoginInfo';
import { LoginScreen } from '../common/LoginScreen';
import { TemporaryNotice } from '../common/TemporaryNotice';
import { SecurityRecordsList } from './SecurityRecordsList';
import {
  SecurityRecordsMaintenance,
  SecurityRecordsNavigation,
  SecurityRecordsView,
} from './SecurityRecordsOptions';
import { Data } from './types';

export const SecurityRecords = (props) => {
  const { data } = useBackend<Data>();
  const { authenticated, screen } = data;
  if (!authenticated) {
    return (
      <Window width={700} height={680}>
        <Window.Content>
          <LoginScreen />
        </Window.Content>
      </Window>
    );
  }

  const body: React.JSX.Element[] = [];
  // List Records
  body[2] = <SecurityRecordsList />;
  // Record Maintenance
  body[3] = <SecurityRecordsMaintenance />;
  // View Records
  body[4] = <SecurityRecordsView />;

  return (
    <Window width={700} height={680}>
      <ComplexModal maxHeight="100%" maxWidth="400px" />
      <Window.Content scrollable>
        <LoginInfo />
        <TemporaryNotice />
        <SecurityRecordsNavigation />
        <Section flexGrow>{(screen && body[screen]) || ''}</Section>
      </Window.Content>
    </Window>
  );
};
