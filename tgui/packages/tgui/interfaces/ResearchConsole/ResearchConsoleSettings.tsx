import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section, Tabs } from '../../components';
import { Data, destroyer, modularDevice } from './types';

export const ResearchConsoleSettings = (props: {
  settingsTab: number;
  onSettingsTab: Function;
}) => {
  const { act, data } = useBackend<Data>();

  const { is_public, sync, linked_destroy, linked_imprinter, linked_lathe } =
    data.info;

  const { settingsTab, onSettingsTab } = props;

  const tab: React.JSX.Element[] = [];

  tab[0] = <ResearchConsoleSettingsSync is_public={is_public} sync={sync} />;
  tab[1] = (
    <ResearchConsoleSettingsLink
      linked_destroy={linked_destroy}
      linked_imprinter={linked_imprinter}
      linked_lathe={linked_lathe}
    />
  );

  return (
    <Section title="Settings">
      <Tabs>
        <Tabs.Tab
          icon="cogs"
          onClick={() => onSettingsTab(0)}
          selected={settingsTab === 0}
        >
          General
        </Tabs.Tab>
        <Tabs.Tab
          icon="link"
          onClick={() => onSettingsTab(1)}
          selected={settingsTab === 1}
        >
          Device Linkages
        </Tabs.Tab>
      </Tabs>
      {tab[settingsTab] || <Box>Error</Box>}
    </Section>
  );
};

const ResearchConsoleSettingsSync = (props: {
  is_public: BooleanLike;
  sync: BooleanLike;
}) => {
  const { act } = useBackend<Data>();

  const { sync, is_public } = props;

  return (
    <Box>
      {!is_public &&
        ((sync && (
          <>
            <Button fluid icon="sync" onClick={() => act('sync')}>
              Sync Database with Network
            </Button>
            <Button fluid icon="unlink" onClick={() => act('togglesync')}>
              Disconnect from Research Network
            </Button>
          </>
        )) || (
          <Button fluid icon="link" onClick={() => act('togglesync')}>
            Connect to Research Network
          </Button>
        ))}
      <Button fluid icon="lock" onClick={() => act('lock')}>
        Lock Console
      </Button>
      <Button fluid color="red" icon="trash" onClick={() => act('reset')}>
        Reset R&D Database
      </Button>
    </Box>
  );
};

const ResearchConsoleSettingsLink = (props: {
  linked_destroy: destroyer;
  linked_lathe: modularDevice;
  linked_imprinter: modularDevice;
}) => {
  const { act } = useBackend<Data>();

  const { linked_destroy, linked_lathe, linked_imprinter } = props;

  return (
    <Box>
      <Button fluid icon="sync" mb={1} onClick={() => act('find_device')}>
        Re-sync with Nearby Devices
      </Button>
      <LabeledList>
        {(linked_destroy.present && (
          <LabeledList.Item label="Destructive Analyzer">
            <Button
              icon="unlink"
              onClick={() => act('disconnect', { disconnect: 'destroy' })}
            >
              Disconnect
            </Button>
          </LabeledList.Item>
        )) ||
          null}
        {(linked_lathe.present && (
          <LabeledList.Item label="Protolathe">
            <Button
              icon="unlink"
              onClick={() => act('disconnect', { disconnect: 'lathe' })}
            >
              Disconnect
            </Button>
          </LabeledList.Item>
        )) ||
          null}
        {(linked_imprinter.present && (
          <LabeledList.Item label="Circuit Imprinter">
            <Button
              icon="unlink"
              onClick={() => act('disconnect', { disconnect: 'imprinter' })}
            >
              Disconnect
            </Button>
          </LabeledList.Item>
        )) ||
          null}
      </LabeledList>
    </Box>
  );
};
