import { useBackend } from '../backend';
import {
  Button,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from '../components';
import { Window } from '../layouts';

type Data = {
  beakerLoaded: boolean;
  beakerContainsBlood: boolean;
  beakerContainsVirus: boolean;
  resistances: string[];
  selectedStrainIndex: number;
  strains: Strain[];
  synthesisCooldown: boolean;
};

type Strain = {
  commonName: string;
  description: string;
  diseaseAgent: string;
  bloodDNA: string;
  bloodType: string;
  possibleTreatments: string;
  transmissionRoute: string;
  isAdvanced: boolean;
  symptoms: Symptom[];
};

type Symptom = {
  name: string;
  stealth: number;
  resistance: number;
  stageSpeed: number;
  transmissibility: number;
};

export const PanDEMIC = () => {
  const { data } = useBackend<Data>();
  const {
    beakerLoaded,
    beakerContainsBlood,
    beakerContainsVirus,
    resistances,
  } = data;

  let emptyPlaceholder: JSX.Element | null = null;
  if (!beakerLoaded) {
    emptyPlaceholder = <>No container loaded.</>;
  } else if (!beakerContainsBlood) {
    emptyPlaceholder = <>No blood sample found in the loaded container.</>;
  } else if (beakerContainsBlood && !beakerContainsVirus) {
    emptyPlaceholder = <>No disease detected in provided blood sample.</>;
  }

  return (
    <Window width={575} height={510}>
      <Window.Content>
        <Stack fill vertical>
          {emptyPlaceholder && !beakerContainsVirus ? (
            <Section
              title="Container Information"
              buttons={<CommonCultureActions />}
            >
              <NoticeBox>{emptyPlaceholder}</NoticeBox>
            </Section>
          ) : (
            <CultureInformationSection />
          )}
          {resistances.length > 0 && <ResistancesSection />}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const CommonCultureActions = () => {
  const { act, data } = useBackend<Data>();
  const { beakerLoaded } = data;
  return (
    <>
      <Button
        icon="eject"
        disabled={!beakerLoaded}
        onClick={() => act('eject_beaker')}
      >
        Eject
      </Button>
      <Button.Confirm
        icon="trash-alt"
        confirmIcon="eraser"
        disabled={!beakerLoaded}
        onClick={() => act('destroy_eject_beaker')}
      >
        Destroy
      </Button.Confirm>
    </>
  );
};

const CultureInformationSection = () => {
  const { act, data } = useBackend<Data>();
  const { selectedStrainIndex, strains, synthesisCooldown } = data;

  if (strains.length === 0) {
    return (
      <Section title="Container Information" buttons={<CommonCultureActions />}>
        <NoticeBox>No disease detected in provided blood sample.</NoticeBox>
      </Section>
    );
  }

  return (
    <Stack.Item grow>
      <Section
        title="Culture Information"
        fill
        buttons={
          <>
            <Button
              icon={synthesisCooldown ? 'spinner' : 'clone'}
              iconSpin={synthesisCooldown}
              disabled={synthesisCooldown}
              onClick={() =>
                act('clone_strain', { strain_index: selectedStrainIndex })
              }
            >
              Clone
            </Button>
            <CommonCultureActions />
          </>
        }
      >
        <Flex fill direction="column">
          <StrainInformationSection
            strains={strains}
            selectedStrainIndex={selectedStrainIndex}
          />
        </Flex>
      </Section>
    </Stack.Item>
  );
};

const StrainInformationSection = ({
  strains,
  selectedStrainIndex,
}: {
  strains: Strain[];
  selectedStrainIndex: number;
}) => {
  const { act } = useBackend<Data>();
  const selectedStrain = strains[selectedStrainIndex - 1];

  return (
    <Flex.Item>
      <Tabs>
        {strains.map((strain, index) => (
          <Tabs.Tab
            key={index}
            icon="virus"
            selected={selectedStrainIndex - 1 === index}
            onClick={() => act('switch_strain', { strain_index: index + 1 })}
          >
            {strain.commonName}
          </Tabs.Tab>
        ))}
      </Tabs>

      <Section title="Strain Information">
        {selectedStrain ? (
          <StrainInformation
            strain={selectedStrain}
            strainIndex={selectedStrainIndex}
          />
        ) : (
          <NoticeBox>No strain information available.</NoticeBox>
        )}
      </Section>

      {selectedStrain && selectedStrain.symptoms.length > 0 && (
        <>
          <StrainSymptomsSection strain={selectedStrain} />
          <TotalStats strain={selectedStrain} />
        </>
      )}
    </Flex.Item>
  );
};

const StrainSymptomsSection = ({ strain }: { strain: Strain }) => {
  const symptoms = strain.symptoms;

  return (
    <Flex.Item grow>
      <Section title="Infection Symptoms" fill>
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Stealth</Table.Cell>
            <Table.Cell>Resistance</Table.Cell>
            <Table.Cell>Stage Speed</Table.Cell>
            <Table.Cell>Transmissibility</Table.Cell>
          </Table.Row>
          {symptoms.map((symptom, index) => (
            <Table.Row key={index}>
              <Table.Cell>{symptom.name}</Table.Cell>
              <Table.Cell>{symptom.stealth}</Table.Cell>
              <Table.Cell>{symptom.resistance}</Table.Cell>
              <Table.Cell>{symptom.stageSpeed}</Table.Cell>
              <Table.Cell>{symptom.transmissibility}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Flex.Item>
  );
};

const TotalStats = ({ strain }: { strain: Strain }) => {
  const symptoms = strain.symptoms;

  const TotalStats = symptoms.reduce(
    (totals, symptom) => ({
      stealth: totals.stealth + symptom.stealth,
      resistance: totals.resistance + symptom.resistance,
      stageSpeed: totals.stageSpeed + symptom.stageSpeed,
      transmissibility: totals.transmissibility + symptom.transmissibility,
    }),
    { stealth: 0, resistance: 0, stageSpeed: 0, transmissibility: 0 },
  );

  return (
    <Section title="Total">
      <Table>
        <Table.Row header>
          <Table.Cell>Stealth</Table.Cell>
          <Table.Cell>Resistance</Table.Cell>
          <Table.Cell>Stage Speed</Table.Cell>
          <Table.Cell>Transmissibility</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>{TotalStats.stealth}</Table.Cell>
          <Table.Cell>{TotalStats.resistance}</Table.Cell>
          <Table.Cell>{TotalStats.stageSpeed}</Table.Cell>
          <Table.Cell>{TotalStats.transmissibility}</Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};

const StrainInformation = ({
  strain,
  strainIndex,
}: {
  strain: Strain;
  strainIndex: number;
}) => {
  const { act } = useBackend<Data>();
  const {
    commonName,
    description,
    diseaseAgent,
    bloodDNA,
    bloodType,
    possibleTreatments,
    transmissionRoute,
    isAdvanced,
  } = strain;

  return (
    <LabeledList>
      <LabeledList.Item label="Common Name">
        <Flex align="center">
          {commonName ?? 'Unknown'}
          {isAdvanced && (
            <>
              <Button
                icon="pen"
                onClick={() =>
                  act('name_strain', { strain_index: strainIndex })
                }
                style={{ marginLeft: 'auto' }}
              >
                Name Disease
              </Button>
              <Button
                icon="print"
                onClick={() =>
                  act('print_release_forms', { strain_index: strainIndex })
                }
              >
                Print
              </Button>
            </>
          )}
        </Flex>
      </LabeledList.Item>
      {description && (
        <LabeledList.Item label="Description">{description}</LabeledList.Item>
      )}
      <LabeledList.Item label="Disease Agent">{diseaseAgent}</LabeledList.Item>
      <LabeledList.Item label="Blood DNA">
        {bloodDNA || 'Undetectable'}
      </LabeledList.Item>
      <LabeledList.Item label="Blood Type">
        {bloodType || 'Undetectable'}
      </LabeledList.Item>
      <LabeledList.Item label="Spread Vector">
        {transmissionRoute || 'None'}
      </LabeledList.Item>
      <LabeledList.Item label="Possible Cures">
        {possibleTreatments || 'None'}
      </LabeledList.Item>
    </LabeledList>
  );
};

const ResistancesSection = () => {
  const { act, data } = useBackend<Data>();
  const { resistances, synthesisCooldown } = data;
  const vaccineIcons = ['flask', 'vial', 'eye-dropper'];

  return (
    <Stack.Item>
      <Section title="Antibodies" fill>
        <Stack direction="row" wrap>
          {resistances.map((resistance, index) => (
            <Stack.Item key={index}>
              <Button
                icon={vaccineIcons[index % vaccineIcons.length]}
                disabled={synthesisCooldown}
                onClick={() =>
                  act('clone_vaccine', { resistance_index: index + 1 })
                }
              />
              {resistance}
            </Stack.Item>
          ))}
        </Stack>
      </Section>
    </Stack.Item>
  );
};
