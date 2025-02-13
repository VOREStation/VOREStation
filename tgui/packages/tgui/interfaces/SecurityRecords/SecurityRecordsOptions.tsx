import { useBackend } from 'tgui/backend';
import { Button, Section, Tabs } from 'tgui-core/components';

import { SecurityRecordsViewGeneral } from './SecurityRecordsViewGeneral';
import { SecurityRecordsViewSecurity } from './SecurityRecordsViewSecurity';
import type { Data } from './types';

export const SecurityRecordsMaintenance = (props) => {
  const { act } = useBackend();
  return (
    <>
      <Button icon="download" disabled>
        Backup to Disk
      </Button>
      <br />
      <Button icon="upload" my="0.5rem" disabled>
        Upload from Disk
      </Button>
      <br />
      <Button.Confirm icon="trash" onClick={() => act('del_all')}>
        Delete All Security Records
      </Button.Confirm>
    </>
  );
};

export const SecurityRecordsView = (props) => {
  const { act, data } = useBackend<Data>();
  const { security, printing } = data;
  return (
    <>
      <Section title="General Data" mt="-6px">
        <SecurityRecordsViewGeneral />
      </Section>
      <Section title="Security Data">
        <SecurityRecordsViewSecurity />
      </Section>
      <Section title="Actions">
        <Button
          icon="upload"
          disabled={!!security!.empty}
          color="good"
          onClick={() => act('sync_r')}
        >
          Sync Security Record
        </Button>
        <Button.Confirm
          icon="trash"
          disabled={!!security!.empty}
          color="bad"
          onClick={() => act('del_r')}
        >
          Delete Security Record
        </Button.Confirm>
        <Button.Confirm
          icon="trash"
          disabled={!!security!.empty}
          color="bad"
          onClick={() => act('del_r_2')}
        >
          Delete Record (All)
        </Button.Confirm>
        <Button
          icon={printing ? 'spinner' : 'print'}
          disabled={printing}
          iconSpin={!!printing}
          ml="0.5rem"
          onClick={() => act('print_p')}
        >
          Print Entry
        </Button>
        <br />
        <Button
          icon="arrow-left"
          mt="0.5rem"
          onClick={() => act('screen', { screen: 2 })}
        >
          Back
        </Button>
      </Section>
    </>
  );
};

export const SecurityRecordsNavigation = (props) => {
  const { act, data } = useBackend<Data>();
  const { screen } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={screen === 2}
        icon="list"
        onClick={() => act('screen', { screen: 2 })}
      >
        List Records
      </Tabs.Tab>
      <Tabs.Tab
        icon="wrench"
        selected={screen === 3}
        onClick={() => act('screen', { screen: 3 })}
      >
        Record Maintenance
      </Tabs.Tab>
    </Tabs>
  );
};
