import { useBackend } from 'tgui/backend';
import { Button, Icon, Section, Tabs } from 'tgui-core/components';

import { GeneralRecordsViewGeneral } from './GeneralRecordsViewGeneral';
import { Data } from './types';

export const GeneralRecordsMaintenance = (props) => {
  const { act } = useBackend();
  return (
    <Button.Confirm icon="trash" onClick={() => act('del_all')}>
      Delete All Employment Records
    </Button.Confirm>
  );
};

export const GeneralRecordsView = (props) => {
  const { act, data } = useBackend<Data>();
  const { general, printing } = data;
  return (
    <>
      <Section title="General Data" mt="-6px">
        <GeneralRecordsViewGeneral />
      </Section>
      <Section title="Actions">
        <Button
          icon="upload"
          disabled={!!general!.empty}
          color="good"
          onClick={() => act('sync_r')}
        >
          Sync Employment Record
        </Button>
        <Button.Confirm
          icon="trash"
          disabled={!!general!.empty}
          color="bad"
          onClick={() => act('del_r')}
        >
          Delete Employment Record
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

export const GeneralRecordsNavigation = (props) => {
  const { act, data } = useBackend<Data>();
  const { screen } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={screen === 2}
        onClick={() => act('screen', { screen: 2 })}
      >
        <Icon name="list" />
        List Records
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 3}
        onClick={() => act('screen', { screen: 3 })}
      >
        <Icon name="wrench" />
        Record Maintenance
      </Tabs.Tab>
    </Tabs>
  );
};
