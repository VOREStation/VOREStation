import { Section } from '../../components';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../../interfaces/common/ComplexModal';
import { Window } from '../../layouts';
import { SupplyConsoleMenu } from './SupplyConsoleMenu';
import { SupplyConsoleShuttleStatus } from './SupplyConsoleShuttleStatus';
import { viewCrateContents } from './viewCrateContents';

export const SupplyConsole = (props) => {
  modalRegisterBodyOverride('view_crate', viewCrateContents);
  return (
    <Window width={700} height={620}>
      <Window.Content>
        <ComplexModal maxWidth="100%" />
        <Section title="Supply Records">
          <SupplyConsoleShuttleStatus />
          <SupplyConsoleMenu />
        </Section>
      </Window.Content>
    </Window>
  );
};
