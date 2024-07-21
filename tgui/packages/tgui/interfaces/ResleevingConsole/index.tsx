import { useBackend } from '../../backend';
import { Section } from '../../components';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../../interfaces/common/ComplexModal';
import { Window } from '../../layouts';
import {
  ResleevingConsoleBody,
  ResleevingConsoleNavigation,
  ResleevingConsoleTemp,
} from './ResleevingConsoleElements';
import { ResleevingConsoleStatus } from './ResleevingConsoleStatus';
import {
  ResleevingConsoleCoreDump,
  ResleevingConsoleDiskPrep,
} from './ResleevingConsoleTexts';
import { Data } from './types';
import { viewBodyRecordModalBodyOverride } from './viewBodyRecordModalBodyOverride';
import { viewMindRecordModalBodyOverride } from './viewMindRecordModalBodyOverride';

export const ResleevingConsole = (props) => {
  const { data } = useBackend<Data>();
  const { coredumped, emergency } = data;
  let body: React.JSX.Element = (
    <>
      <ResleevingConsoleTemp />
      <ResleevingConsoleStatus />
      <ResleevingConsoleNavigation />
      <Section noTopPadding flexGrow>
        <ResleevingConsoleBody />
      </Section>
    </>
  );
  if (coredumped) {
    body = <ResleevingConsoleCoreDump />;
  }
  if (emergency) {
    body = <ResleevingConsoleDiskPrep />;
  }
  modalRegisterBodyOverride('view_b_rec', viewBodyRecordModalBodyOverride);
  modalRegisterBodyOverride('view_m_rec', viewMindRecordModalBodyOverride);
  return (
    <Window width={640} height={520}>
      <ComplexModal maxWidth="75%" maxHeight="75%" />
      <Window.Content className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};
