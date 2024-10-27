import { useBackend } from 'tgui/backend';
import { Button, Section, Tabs } from 'tgui-core/components';

import { MedicalRecordsViewGeneral } from './MedicalRecordsViewGeneral';
import { MedicalRecordsViewMedical } from './MedicalRecordsViewMedical';
import { Data } from './types';

export const MedicalRecordsMaintenance = (props) => {
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
        Delete All Medical Records
      </Button.Confirm>
    </>
  );
};

export const MedicalRecordsView = (props) => {
  const { act, data } = useBackend<Data>();
  const { medical, printing } = data;
  return (
    <>
      <Section title="General Data" mt="-6px">
        <MedicalRecordsViewGeneral />
      </Section>
      <Section title="Medical Data">
        <MedicalRecordsViewMedical />
      </Section>
      <Section title="Actions">
        <Button.Confirm
          icon="trash"
          disabled={!!medical!.empty}
          color="bad"
          onClick={() => act('del_r')}
        >
          Delete Medical Record
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

export const MedicalRecordsNavigation = (props) => {
  const { act, data } = useBackend<Data>();
  const { screen } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={screen === 2}
        onClick={() => act('screen', { screen: 2 })}
        icon="list"
      >
        List Records
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 5}
        onClick={() => act('screen', { screen: 5 })}
        icon="database"
      >
        Virus Database
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 6}
        onClick={() => act('screen', { screen: 6 })}
        icon="plus-square"
      >
        Medbot Tracking
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 3}
        onClick={() => act('screen', { screen: 3 })}
        icon="wrench"
      >
        Record Maintenance
      </Tabs.Tab>
    </Tabs>
  );
};
