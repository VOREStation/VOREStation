import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

import type { Data } from './types';

export const CommunicatorNoteTab = (props) => {
  const { act, data } = useBackend<Data>();

  const { note } = data;

  return (
    <Section
      title="Note Keeper"
      height="100%"
      stretchContents
      buttons={
        <Button icon="pen" onClick={() => act('edit')}>
          Edit Notes
        </Button>
      }
    >
      <Section
        color="average"
        width="100%"
        height="100%"
        style={{
          wordBreak: 'break-all',
          overflowY: 'auto',
        }}
      >
        {note}
      </Section>
    </Section>
  );
};
