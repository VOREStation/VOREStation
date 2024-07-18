import { BooleanLike } from 'common/react';
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
import { Window } from '../layouts';
import { ComplexModal, modalRegisterBodyOverride } from './common/ComplexModal';
import { modalData } from './MedicalRecords/types';

type Data = {
  syringe_inserted: BooleanLike;
  isolating: BooleanLike;
  pathogen_pool:
    | {
        name: string;
        dna: string;
        unique_id: number;
        reference: string;
        is_in_database: BooleanLike;
        record: string;
      }[]
    | [];
  can_print: BooleanLike;
  database: {
    name: string;
    record: string;
  }[];
  modal: modalData;
};

const virusModalBodyOverride = (modal: modalData) => {
  const { act, data } = useBackend<Data>();
  const { can_print } = data;
  const virus = modal.args;
  return (
    <Section
      m="-1rem"
      title={virus.name || 'Virus'}
      buttons={
        <>
          <Button
            disabled={!can_print}
            icon="print"
            onClick={() =>
              act('print', { type: 'virus_record', vir: virus.record })
            }
          >
            Print
          </Button>
          <Button icon="times" color="red" onClick={() => act('modal_close')} />
        </>
      }
    >
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Spread">
            {virus.spreadtype} Transmission
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
  const { data } = useBackend<Data>();

  const { isolating } = data;

  const [tabIndex, setTabIndex] = useState(0);

  const tab: React.JSX.Element[] = [];
  tab[0] = <PathogenicIsolatorTabHome />;
  tab[1] = <PathogenicIsolatorTabDatabase />;

  modalRegisterBodyOverride('virus', virusModalBodyOverride);
  return (
    <Window height={500} width={520}>
      <ComplexModal maxHeight="100%" maxWidth="95%" />
      <Window.Content scrollable>
        {(isolating && (
          <NoticeBox warning>The Isolator is currently isolating...</NoticeBox>
        )) ||
          ''}
        <Tabs>
          <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
            Home
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
            Database
          </Tabs.Tab>
        </Tabs>
        {tab[tabIndex] || ''}
      </Window.Content>
    </Window>
  );
};

const PathogenicIsolatorTabHome = (props) => {
  const { act, data } = useBackend<Data>();
  const { syringe_inserted, pathogen_pool, can_print } = data;
  return (
    <Section
      title="Pathogens"
      buttons={
        <>
          <Button
            icon="print"
            disabled={!can_print}
            onClick={() => act('print', { type: 'patient_diagnosis' })}
          >
            Print
          </Button>
          <Button
            icon="eject"
            disabled={!syringe_inserted}
            onClick={() => act('eject')}
          >
            Eject Syringe
          </Button>
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
                    onClick={() =>
                      act('isolate', { isolate: pathogen.reference })
                    }
                  >
                    Isolate
                  </Button>
                  <Button
                    icon="search"
                    disabled={!pathogen.is_in_database}
                    onClick={() => act('view_entry', { vir: pathogen.record })}
                  >
                    Database
                  </Button>
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
  const { act, data } = useBackend<Data>();
  const { database, can_print } = data;
  return (
    <Section
      title="Database"
      buttons={
        <Button
          icon="print"
          disabled={!can_print}
          onClick={() => act('print', { type: 'virus_list' })}
        >
          Print
        </Button>
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
