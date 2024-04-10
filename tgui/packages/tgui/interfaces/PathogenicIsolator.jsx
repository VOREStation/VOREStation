import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
  Tabs,
} from '../components';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../interfaces/common/ComplexModal';
import { Window } from '../layouts';

const virusModalBodyOverride = (modal) => {
  const { act, data } = useBackend();
  const { can_print } = data;
  const virus = modal.args;
  return (
    <Section
      level={2}
      m="-1rem"
      title={virus.name || 'Virus'}
      buttons={
        <>
          <Button
            disabled={!can_print}
            icon="print"
            content="Print"
            onClick={() =>
              act('print', { type: 'virus_record', vir: virus.record })
            }
          />
          <Button icon="times" color="red" onClick={() => act('modal_close')} />
        </>
      }
    >
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Spread">
            {virus.spread_text} Transmission
          </LabeledList.Item>
          <LabeledList.Item label="Possible cure">
            {virus.antigen}
          </LabeledList.Item>
          <LabeledList.Item label="Rate of Progression">
            {virus.rate}
          </LabeledList.Item>
          <LabeledList.Item label="Antibiotic Resistance">
            {virus.resistance}%
          </LabeledList.Item>
          <LabeledList.Item label="Species Affected">
            {virus.species}
          </LabeledList.Item>
          <LabeledList.Item label="Symptoms">
            <LabeledList>
              {virus.symptoms.map((s) => (
                <LabeledList.Item key={s.stage} label={s.stage + '. ' + s.name}>
                  <Box inline>
                    <Box inline color="label">
                      Strength:
                    </Box>{' '}
                    {s.strength}&nbsp;
                  </Box>
                  <Box inline>
                    <Box inline color="label">
                      Aggressiveness:
                    </Box>{' '}
                    {s.aggressiveness}
                  </Box>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};

export const PathogenicIsolator = (props) => {
  const { act, data } = useBackend();

  const { isolating } = data;

  const [tabIndex, setTabIndex] = useState(0);

  let tab = null;
  if (tabIndex === 0) {
    tab = <PathogenicIsolatorTabHome />;
  } else if (tabIndex === 1) {
    tab = <PathogenicIsolatorTabDatabase />;
  }

  modalRegisterBodyOverride('virus', virusModalBodyOverride);
  return (
    <Window height={500} width={520}>
      <ComplexModal maxHeight="100%" maxWidth="95%" />
      <Window.Content scrollable>
        {(isolating && (
          <NoticeBox warning>The Isolator is currently isolating...</NoticeBox>
        )) ||
          null}
        <Tabs>
          <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
            Home
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
            Database
          </Tabs.Tab>
        </Tabs>
        {tab}
      </Window.Content>
    </Window>
  );
};

const PathogenicIsolatorTabHome = (props) => {
  const { act, data } = useBackend();
  const { syringe_inserted, pathogen_pool, can_print } = data;
  return (
    <Section
      title="Pathogens"
      buttons={
        <>
          <Button
            icon="print"
            content="Print"
            disabled={!can_print}
            onClick={() => act('print', { type: 'patient_diagnosis' })}
          />
          <Button
            icon="eject"
            content="Eject Syringe"
            disabled={!syringe_inserted}
            onClick={() => act('eject')}
          />
        </>
      }
    >
      {(pathogen_pool.length &&
        pathogen_pool.map((pathogen) => (
          <Section key={pathogen.unique_id}>
            <Box color="label">
              <Flex align="center">
                <Flex.Item grow={1}>
                  <u>Stamm #{pathogen.unique_id}</u>
                  {pathogen.is_in_database ? ' (Analyzed)' : ' (Not Analyzed)'}
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="virus"
                    content="Isolate"
                    onClick={() =>
                      act('isolate', { isolate: pathogen.reference })
                    }
                  />
                  <Button
                    icon="search"
                    content="Database"
                    disabled={!pathogen.is_in_database}
                    onClick={() => act('view_entry', { vir: pathogen.record })}
                  />
                </Flex.Item>
              </Flex>
            </Box>
            <Box>
              <Box color="average" mb={1}>
                {pathogen.name}
              </Box>
              {pathogen.dna}
            </Box>
          </Section>
        ))) ||
        (syringe_inserted ? (
          <Box color="average">No samples detected.</Box>
        ) : (
          <Box color="average">No syringe inserted.</Box>
        ))}
    </Section>
  );
};

const PathogenicIsolatorTabDatabase = (props) => {
  const { act, data } = useBackend();
  const { database, can_print } = data;
  return (
    <Section
      title="Database"
      buttons={
        <Button
          icon="print"
          content="Print"
          disabled={!can_print}
          onClick={() => act('print', { type: 'virus_list' })}
        />
      }
    >
      {(database.length &&
        database.map((entry) => (
          <Button
            key={entry.name}
            fluid
            icon="search"
            onClick={() => act('view_entry', { vir: entry.record })}
          >
            {entry.name}
          </Button>
        ))) || <Box color="average">The viral database is empty.</Box>}
    </Section>
  );
};
