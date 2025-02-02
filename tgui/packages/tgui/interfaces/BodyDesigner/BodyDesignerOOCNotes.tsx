import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

import { activeBodyRecord } from './types';

export const BodyDesignerOOCNotes = (props: {
  activeBodyRecord: activeBodyRecord;
}) => {
  const { act } = useBackend();
  const { activeBodyRecord } = props;
  return (
    <Section
      title="Body OOC Notes (This is OOC!)"
      height="100%"
      scrollable
      buttons={
        <Button
          icon="arrow-left"
          onClick={() => act('menu', { menu: 'Specific Record' })}
        >
          Back
        </Button>
      }
      style={{ wordBreak: 'break-all' }}
    >
      {(activeBodyRecord && activeBodyRecord.booc) ||
        'ERROR: Body record not found!'}
    </Section>
  );
};
