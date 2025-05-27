import { Window } from 'tgui/layouts';
import { Button, Section } from 'tgui-core/components';

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
