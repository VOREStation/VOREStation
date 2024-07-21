import { useBackend } from '../../backend';
import { Button, Section } from '../../components';
import { Window } from '../../layouts';
import { Data } from './types';
import { downloadPrefs } from './VorePanelExportDownload';

export const VorePanelExport = () => {
  return (
    <Window width={790} height={560} theme="abstract">
      <Window.Content>
        <VorePanelExportContent />
      </Window.Content>
    </Window>
  );
};

const VorePanelExportContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { bellies } = data;

  return (
    <Section title="Vore Export Panel">
      <Section title="Export">
        <Button fluid icon="file-alt" onClick={() => downloadPrefs('.html')}>
          Export (HTML)
        </Button>
        <Button fluid icon="file-alt" onClick={() => downloadPrefs('.vrdb')}>
          Export (VRDB)
        </Button>
      </Section>
    </Section>
  );
};
