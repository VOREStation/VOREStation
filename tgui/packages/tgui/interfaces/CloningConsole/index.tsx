import { useBackend } from '../../backend';
import { Box, Section } from '../../components';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../../interfaces/common/ComplexModal';
import { Window } from '../../layouts';
import { viewRecordModalBodyOverride } from './CloningConsoleBodyOverride';
import { CloningConsoleNavigation } from './CloningConsoleNavigation';
import {
  CloningConsoleStatus,
  CloningConsoleTemp,
} from './CloningConsoleStatus';
import {
  CloningConsoleMain,
  CloningConsoleRecords,
} from './CloningConsoleTabs';
import { Data } from './types';

export const CloningConsole = (props) => {
  const { data } = useBackend<Data>();

  const { menu } = data;

  const tab: React.JSX.Element[] = [];

  tab[1] = <CloningConsoleMain />;
  tab[2] = <CloningConsoleRecords />;

  modalRegisterBodyOverride('view_rec', viewRecordModalBodyOverride);
  return (
    <Window>
      <ComplexModal maxWidth="75%" maxHeight="75%" />
      <Window.Content className="Layout__content--flexColumn">
        <CloningConsoleTemp />
        <CloningConsoleStatus />
        <CloningConsoleNavigation />
        <Section noTopPadding flexGrow>
          {tab[menu] || <Box textColor="red">Error</Box>}
        </Section>
      </Window.Content>
    </Window>
  );
};
