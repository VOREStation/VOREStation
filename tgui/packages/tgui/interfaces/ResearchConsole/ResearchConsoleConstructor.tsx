import { useBackend } from '../../backend';
import {
  Box,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
  Tabs,
} from '../../components';
import {
  ResearchConsoleConstructorChems,
  ResearchConsoleConstructorMats,
  ResearchConsoleConstructorMenue,
  ResearchConsoleConstructorQueue,
} from './ResearchConsoleConstructorTabs';
import { Data, design, mat, modularDevice } from './types';

/* Lathe + Circuit Imprinter all in one */
export const ResearchConsoleConstructor = (props: {
  name: string;
  linked: modularDevice;
  designs: design[];
  protoTab: number;
  matsStates: mat[];
  onProtoTab: Function;
  onMatsState: Function;
}) => {
  const { act, data } = useBackend<Data>();

  const {
    name,
    matsStates,
    onMatsState,
    protoTab,
    onProtoTab,
    linked,
    designs,
  } = props;

  if (!linked || !linked.present) {
    return <Section title={name}>No {name} found.</Section>;
  }

  const {
    total_materials,
    max_materials,
    total_volume,
    max_volume,
    busy,
    mats,
    reagents,
    queue,
  } = linked;

  let queueColor: string = 'transparent';
  let queueSpin: boolean = false;
  let queueIcon: string = 'layer-group';
  if (busy) {
    queueIcon = 'hammer';
    queueColor = 'average';
    queueSpin = true;
  } else if (queue && queue.length) {
    queueIcon = 'sync';
    queueColor = 'green';
    queueSpin = true;
  }

  const tab: React.JSX.Element[] = [];

  tab[0] = (
    <ResearchConsoleConstructorMenue
      name={name}
      linked={linked}
      designs={designs}
    />
  );
  tab[1] = (
    <ResearchConsoleConstructorQueue name={name} busy={busy} queue={queue} />
  );
  tab[2] = (
    <ResearchConsoleConstructorMats
      name={name}
      mats={mats}
      matsStates={matsStates}
      onMatsState={onMatsState}
    />
  );
  tab[3] = <ResearchConsoleConstructorChems name={name} reagents={reagents} />;

  return (
    <Section title={name} buttons={(busy && <Icon name="sync" spin />) || null}>
      <LabeledList>
        <LabeledList.Item label="Materials">
          <ProgressBar value={total_materials} maxValue={max_materials}>
            {total_materials} cm&sup3; / {max_materials} cm&sup3;
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Chemicals">
          <ProgressBar value={total_volume} maxValue={max_volume}>
            {total_volume}u / {max_volume}u
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
      <Tabs mt={1}>
        <Tabs.Tab
          icon="wrench"
          selected={protoTab === 0}
          onClick={() => onProtoTab(0)}
        >
          Build
        </Tabs.Tab>
        <Tabs.Tab
          icon={queueIcon}
          iconSpin={queueSpin}
          color={queueColor}
          selected={protoTab === 1}
          onClick={() => onProtoTab(1)}
        >
          Queue
        </Tabs.Tab>
        <Tabs.Tab
          icon="cookie-bite"
          selected={protoTab === 2}
          onClick={() => onProtoTab(2)}
        >
          Mat Storage
        </Tabs.Tab>
        <Tabs.Tab
          icon="flask"
          selected={protoTab === 3}
          onClick={() => onProtoTab(3)}
        >
          Chem Storage
        </Tabs.Tab>
      </Tabs>
      {tab[protoTab] || <Box textColor="red">Error</Box>}
    </Section>
  );
};
