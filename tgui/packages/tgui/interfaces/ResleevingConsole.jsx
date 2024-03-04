import { round } from 'common/math';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Tabs,
} from '../components';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '../interfaces/common/ComplexModal';
import { Window } from '../layouts';

const MENU_MAIN = 1;
const MENU_BODY = 2;
const MENU_MIND = 3;

const viewMindRecordModalBodyOverride = (modal) => {
  const { act, data } = useBackend();
  const {
    activerecord,
    realname,
    obviously_dead,
    oocnotes,
    can_sleeve_active,
  } = modal.args;
  return (
    <Section
      level={2}
      m="-1rem"
      pb="1rem"
      title={'Mind Record (' + realname + ')'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('modal_close')} />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{realname}</LabeledList.Item>
        <LabeledList.Item label="Status">{obviously_dead}</LabeledList.Item>
        <LabeledList.Item label="Actions">
          <Button
            disabled={!can_sleeve_active}
            icon="user-plus"
            content="Sleeve"
            onClick={() =>
              act('sleeve', {
                ref: activerecord,
                mode: 1,
              })
            }
          />
          <Button
            icon="user-plus"
            content="Card"
            onClick={() =>
              act('sleeve', {
                ref: activerecord,
                mode: 2,
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="OOC Notes">
          <Section
            style={{ 'word-break': 'break-all', height: '100px' }}
            scrollable
          >
            {oocnotes}
          </Section>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const viewBodyRecordModalBodyOverride = (modal) => {
  const { act, data } = useBackend();
  const {
    activerecord,
    realname,
    species,
    sex,
    mind_compat,
    synthetic,
    oocnotes,
    can_grow_active,
  } = modal.args;
  return (
    <Section
      level={2}
      m="-1rem"
      pb="1rem"
      title={'Body Record (' + realname + ')'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('modal_close')} />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{realname}</LabeledList.Item>
        <LabeledList.Item label="Species">{species}</LabeledList.Item>
        <LabeledList.Item label="Bio. Sex">{sex}</LabeledList.Item>
        <LabeledList.Item label="Mind Compat">{mind_compat}</LabeledList.Item>
        <LabeledList.Item label="Synthetic">
          {synthetic ? 'Yes' : 'No'}
        </LabeledList.Item>
        <LabeledList.Item label="OOC Notes">
          <Section
            style={{ 'word-break': 'break-all', height: '100px' }}
            scrollable
          >
            {oocnotes}
          </Section>
        </LabeledList.Item>
        <LabeledList.Item label="Actions">
          <Button
            disabled={!can_grow_active}
            icon="user-plus"
            content={synthetic ? 'Build' : 'Grow'}
            onClick={() =>
              act('create', {
                ref: activerecord,
              })
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const ResleevingConsole = (props) => {
  const { act, data } = useBackend();
  const { menu, coredumped, emergency } = data;
  let body = (
    <>
      <ResleevingConsoleTemp />
      <ResleevingConsoleStatus />
      <ResleevingConsoleNavigation />
      <Section noTopPadding flexGrow="1">
        <ResleevingConsoleBody />
      </Section>
    </>
  );
  if (coredumped) {
    body = <ResleevingConsoleCoreDump />;
  }
  if (emergency) {
    body = <ResleevingConsoleDiskPrep />;
  }
  modalRegisterBodyOverride('view_b_rec', viewBodyRecordModalBodyOverride);
  modalRegisterBodyOverride('view_m_rec', viewMindRecordModalBodyOverride);
  return (
    <Window width={640} height={520}>
      <ComplexModal maxWidth="75%" maxHeight="75%" />
      <Window.Content className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};

const ResleevingConsoleNavigation = (props) => {
  const { act, data } = useBackend();
  const { menu } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={menu === MENU_MAIN}
        icon="home"
        onClick={() =>
          act('menu', {
            num: MENU_MAIN,
          })
        }
      >
        Main
      </Tabs.Tab>
      <Tabs.Tab
        selected={menu === MENU_BODY}
        icon="folder"
        onClick={() =>
          act('menu', {
            num: MENU_BODY,
          })
        }
      >
        Body Records
      </Tabs.Tab>
      <Tabs.Tab
        selected={menu === MENU_MIND}
        icon="folder"
        onClick={() =>
          act('menu', {
            num: MENU_MIND,
          })
        }
      >
        Mind Records
      </Tabs.Tab>
    </Tabs>
  );
};

const ResleevingConsoleBody = (props) => {
  const { data } = useBackend();
  const { menu, bodyrecords, mindrecords } = data;
  let body;
  if (menu === MENU_MAIN) {
    body = <ResleevingConsoleMain />;
  } else if (menu === MENU_BODY) {
    body = (
      <ResleevingConsoleRecords records={bodyrecords} actToDo="view_b_rec" />
    );
  } else if (menu === MENU_MIND) {
    body = (
      <ResleevingConsoleRecords records={mindrecords} actToDo="view_m_rec" />
    );
  }
  return body;
};

const ResleevingConsoleCoreDump = (props) => {
  return (
    <Dimmer>
      <Flex direction="column" justify="space-evenly" align="center">
        <Flex.Item grow={1}>
          <Icon size={12} color="bad" name="exclamation-triangle" />
        </Flex.Item>
        <Flex.Item grow={1} color="bad" mt={5}>
          <h2>TransCore dump completed. Resleeving offline.</h2>
        </Flex.Item>
      </Flex>
    </Dimmer>
  );
};

const ResleevingConsoleDiskPrep = (props) => {
  const { act } = useBackend();
  return (
    <Dimmer textAlign="center">
      <Box color="bad">
        <h1>TRANSCORE DUMP</h1>
      </Box>
      <Box color="bad">
        <h2>!!WARNING!!</h2>
      </Box>
      <Box color="bad">
        This will transfer all minds to the dump disk, and the TransCore will be
        made unusable until post-shift maintenance! This should only be used in
        emergencies!
      </Box>
      <Box mt={4}>
        <Button
          icon="eject"
          content="Eject Disk"
          color="good"
          onClick={() => act('ejectdisk')}
        />
      </Box>
      <Box mt={4}>
        <Button.Confirm
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          content="Core Dump"
          confirmContent="Disable Transcore?"
          color="bad"
          onClick={() => act('coredump')}
        />
      </Box>
    </Dimmer>
  );
};

const ResleevingConsoleMain = (props) => {
  const { act, data } = useBackend();
  const {
    loading,
    scantemp,
    occupant,
    locked,
    can_brainscan,
    scan_mode,
    pods,
    selected_pod,
  } = data;
  const isLocked = locked && !!occupant;
  return (
    <Section title="Pods" level="2">
      <ResleevingConsolePodGrowers />
      <ResleevingConsolePodSpods />
      <ResleevingConsolePodSleevers />
    </Section>
  );
};

const ResleevingConsolePodGrowers = (props) => {
  const { act, data } = useBackend();
  const { pods, spods, selected_pod } = data;

  if (pods && pods.length) {
    return pods.map((pod, i) => {
      let podAction;
      if (pod.status === 'cloning') {
        podAction = (
          <ProgressBar
            min="0"
            max="100"
            value={pod.progress / 100}
            ranges={{
              good: [0.75, Infinity],
              average: [0.25, 0.75],
              bad: [-Infinity, 0.25],
            }}
            mt="0.5rem"
          >
            <Box textAlign="center">{round(pod.progress, 0) + '%'}</Box>
          </ProgressBar>
        );
      } else if (pod.status === 'mess') {
        podAction = (
          <Box bold color="bad" mt="0.5rem">
            ERROR
          </Box>
        );
      } else {
        podAction = (
          <Button
            selected={selected_pod === pod.pod}
            icon={selected_pod === pod.pod && 'check'}
            content="Select"
            mt={spods && spods.length ? '2rem' : '0.5rem'}
            onClick={() =>
              act('selectpod', {
                ref: pod.pod,
              })
            }
          />
        );
      }

      return (
        <Box
          key={i}
          width="64px"
          textAlign="center"
          display="inline-block"
          mr="0.5rem"
        >
          <img
            src={'pod_' + pod.status + '.gif'}
            style={{
              width: '100%',
              '-ms-interpolation-mode': 'nearest-neighbor',
            }}
          />
          <Box color="label">{pod.name}</Box>
          <Box bold color={pod.biomass >= 150 ? 'good' : 'bad'} inline>
            <Icon name={pod.biomass >= 150 ? 'circle' : 'circle-o'} />
            &nbsp;
            {pod.biomass}
          </Box>
          {podAction}
        </Box>
      );
    });
  }

  return null;
};

const ResleevingConsolePodSleevers = (props) => {
  const { act, data } = useBackend();
  const { sleevers, spods, selected_sleever } = data;

  if (sleevers && sleevers.length) {
    return sleevers.map((pod, i) => {
      return (
        <Box
          key={i}
          width="64px"
          textAlign="center"
          display="inline-block"
          mr="0.5rem"
        >
          <img
            src={'sleeve_' + (pod.occupied ? 'occupied' : 'empty') + '.gif'}
            style={{
              width: '100%',
              '-ms-interpolation-mode': 'nearest-neighbor',
            }}
          />
          <Box color={pod.occupied ? 'label' : 'bad'}>{pod.name}</Box>
          <Button
            selected={selected_sleever === pod.sleever}
            icon={selected_sleever === pod.sleever && 'check'}
            content="Select"
            mt={spods && spods.length ? '3rem' : '1.5rem'}
            onClick={() =>
              act('selectsleever', {
                ref: pod.sleever,
              })
            }
          />
        </Box>
      );
    });
  }

  return null;
};

const ResleevingConsolePodSpods = (props) => {
  const { act, data } = useBackend();
  const { spods, selected_printer } = data;

  if (spods && spods.length) {
    return spods.map((pod, i) => {
      let podAction;
      if (pod.status === 'cloning') {
        podAction = (
          <ProgressBar
            min="0"
            max="100"
            value={pod.progress / 100}
            ranges={{
              good: [0.75, Infinity],
              average: [0.25, 0.75],
              bad: [-Infinity, 0.25],
            }}
            mt="0.5rem"
          >
            <Box textAlign="center">{round(pod.progress, 0) + '%'}</Box>
          </ProgressBar>
        );
      } else if (pod.status === 'mess') {
        podAction = (
          <Box bold color="bad" mt="0.5rem">
            ERROR
          </Box>
        );
      } else {
        podAction = (
          <Button
            selected={selected_printer === pod.spod}
            icon={selected_printer === pod.spod && 'check'}
            content="Select"
            mt="0.5rem"
            onClick={() =>
              act('selectprinter', {
                ref: pod.spod,
              })
            }
          />
        );
      }

      return (
        <Box
          key={i}
          width="64px"
          textAlign="center"
          display="inline-block"
          mr="0.5rem"
        >
          <img
            src={'synthprinter' + (pod.busy ? '_working' : '') + '.gif'}
            style={{
              width: '100%',
              '-ms-interpolation-mode': 'nearest-neighbor',
            }}
          />
          <Box color="label">{pod.name}</Box>
          <Box bold color={pod.steel >= 15000 ? 'good' : 'bad'} inline>
            <Icon name={pod.steel >= 15000 ? 'circle' : 'circle-o'} />
            &nbsp;
            {pod.steel}
          </Box>
          <Box bold color={pod.glass >= 15000 ? 'good' : 'bad'} inline>
            <Icon name={pod.glass >= 15000 ? 'circle' : 'circle-o'} />
            &nbsp;
            {pod.glass}
          </Box>
          {podAction}
        </Box>
      );
    });
  }

  return null;
};

const ResleevingConsoleRecords = (props) => {
  const { act } = useBackend();
  const { records, actToDo } = props;
  if (!records.length) {
    return (
      <Flex height="100%" mt="0.5rem">
        <Flex.Item grow="1" align="center" textAlign="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size="5" />
          <br />
          No records found.
        </Flex.Item>
      </Flex>
    );
  }
  return (
    <Box mt="0.5rem">
      {records.map((record, i) => (
        <Button
          key={i}
          icon="user"
          mb="0.5rem"
          content={record.name}
          onClick={() =>
            act(actToDo, {
              ref: record.recref,
            })
          }
        />
      ))}
    </Box>
  );
};

const ResleevingConsoleTemp = (props) => {
  const { act, data } = useBackend();
  const { temp } = data;
  if (!temp || !temp.text || temp.text.length <= 0) {
    return;
  }

  const tempProp = { [temp.style]: true };
  return (
    <NoticeBox {...tempProp}>
      <Box display="inline-block" verticalAlign="middle">
        {temp.text}
      </Box>
      <Button
        icon="times-circle"
        float="right"
        onClick={() => act('cleartemp')}
      />
      <Box clear="both" />
    </NoticeBox>
  );
};

const ResleevingConsoleStatus = (props) => {
  const { act, data } = useBackend();
  const { pods, spods, sleevers, autoallowed, autoprocess, disk } = data;
  return (
    <Section title="Status">
      <LabeledList>
        <LabeledList.Item label="Pods">
          {pods && pods.length ? (
            <Box color="good">{pods.length} connected</Box>
          ) : (
            <Box color="bad">None connected!</Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="SynthFabs">
          {spods && spods.length ? (
            <Box color="good">{spods.length} connected</Box>
          ) : (
            <Box color="bad">None connected!</Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Sleevers">
          {sleevers && sleevers.length ? (
            <Box color="good">{sleevers.length} Connected</Box>
          ) : (
            <Box color="bad">None connected!</Box>
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
