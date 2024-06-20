import { toTitleCase } from 'common/string';
import { Fragment, useEffect, useState } from 'react';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Icon,
  Input,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Table,
  Tabs,
} from '../components';
import { Window } from '../layouts';

const ResearchConsoleViewResearch = (props) => {
  const { act, data } = useBackend();

  const { tech } = data;

  return (
    <Section
      title="Current Research Levels"
      buttons={
        <Button icon="print" onClick={() => act('print', { print: 1 })}>
          Print This Page
        </Button>
      }
    >
      <Table>
        {tech.map((thing) => (
          <Table.Row key={thing.name}>
            <Table.Cell>
              <Box color="label">{thing.name}</Box>
              <Box> - Level {thing.level}</Box>
            </Table.Cell>
            <Table.Cell>
              <Box color="label">{thing.desc}</Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const PaginationTitle = (props) => {
  const { data } = useBackend();

  const { title, target } = props;

  let page = data[target];
  if (typeof page === 'number') {
    return title + ' - Page ' + (page + 1);
  }

  return title;
};

const PaginationChevrons = (props) => {
  const { act } = useBackend();

  const { target } = props;

  return (
    <>
      <Button icon="undo" onClick={() => act(target, { reset: true })} />
      <Button
        icon="chevron-left"
        onClick={() => act(target, { reverse: -1 })}
      />
      <Button
        icon="chevron-right"
        onClick={() => act(target, { reverse: 1 })}
      />
    </>
  );
};

const ResearchConsoleViewDesigns = (props) => {
  const { act, data } = useBackend();

  const { designs } = data;

  return (
    <Section
      title={
        <PaginationTitle
          title="Researched Technologies & Designs"
          target="design_page"
        />
      }
      buttons={
        <>
          <Button icon="print" onClick={() => act('print', { print: 2 })}>
            Print This Page
          </Button>
          {<PaginationChevrons target={'design_page'} /> || null}
        </>
      }
    >
      <Input
        fluid
        placeholder="Search for..."
        value={data.search}
        onInput={(e, v) => act('search', { search: v })}
        mb={1}
      />
      {(designs && designs.length && (
        <LabeledList>
          {designs.map((design) => (
            <LabeledList.Item label={design.name} key={design.name}>
              {design.desc}
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || <Box color="warning">No designs found.</Box>}
    </Section>
  );
};

const TechDisk = (props) => {
  const { act, data } = useBackend();

  const { tech } = data;

  const { disk } = props;

  if (!disk || !disk.present) {
    return null;
  }

  if (props.saveDialog) {
    return (
      <Section
        title="Load Technology to Disk"
        buttons={
          <Button icon="arrow-left" onClick={() => props.onSaveDialog(false)}>
            Back
          </Button>
        }
      >
        <LabeledList>
          {tech.map((level) => (
            <LabeledList.Item label={level.name} key={level.name}>
              <Button
                icon="save"
                onClick={() => {
                  props.onSaveDialog(false);
                  act('copy_tech', { copy_tech_ID: level.id });
                }}
              >
                Copy To Disk
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    );
  }

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Disk Contents">
          (Technology Data Disk)
        </LabeledList.Item>
      </LabeledList>
      {(disk.stored && (
        <Box mt={2}>
          <Box>{disk.name}</Box>
          <Box>Level: {disk.level}</Box>
          <Box>Description: {disk.desc}</Box>
          <Box mt={1}>
            <Button icon="save" onClick={() => act('updt_tech')}>
              Upload to Database
            </Button>
            <Button icon="trash" onClick={() => act('clear_tech')}>
              Clear Disk
            </Button>
            <Button icon="eject" onClick={() => act('eject_tech')}>
              Eject Disk
            </Button>
          </Box>
        </Box>
      )) || (
        <Box>
          <Box>This disk has no data stored on it.</Box>
          <Button icon="save" onClick={() => props.onSaveDialog(true)}>
            Load Tech To Disk
          </Button>
          <Button icon="eject" onClick={() => act('eject_tech')}>
            Eject Disk
          </Button>
        </Box>
      )}
    </Box>
  );
};

const DataDisk = (props) => {
  const { act, data } = useBackend();

  const { designs } = data;

  const { disk } = props;

  if (!disk || !disk.present) {
    return null;
  }

  if (props.saveDialog) {
    return (
      <Section
        title={
          <PaginationTitle title="Load Design to Disk" target="design_page" />
        }
        buttons={
          <>
            <Button icon="arrow-left" onClick={() => props.onSaveDialog(false)}>
              Back
            </Button>
            {<PaginationChevrons target={'design_page'} /> || null}
          </>
        }
      >
        <Input
          fluid
          placeholder="Search for..."
          value={data.search}
          onInput={(e, v) => act('search', { search: v })}
          mb={1}
        />
        {(designs && designs.length && (
          <LabeledList>
            {designs.map((item) => (
              <LabeledList.Item label={item.name} key={item.name}>
                <Button
                  icon="save"
                  onClick={() => {
                    props.onSaveDialog(false);
                    act('copy_design', { copy_design_ID: item.id });
                  }}
                >
                  Copy To Disk
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        )) || <Box color="warning">No designs found.</Box>}
      </Section>
    );
  }

  return (
    <Box>
      {(disk.stored && (
        <Box>
          <LabeledList>
            <LabeledList.Item label="Name">{disk.name}</LabeledList.Item>
            <LabeledList.Item label="Lathe Type">
              {disk.build_type}
            </LabeledList.Item>
            <LabeledList.Item label="Required Materials">
              {Object.keys(disk.materials).map((mat) => (
                <Box key={mat}>
                  {mat} x {disk.materials[mat]}
                </Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>
            <Button icon="save" onClick={() => act('updt_design')}>
              Upload to Database
            </Button>
            <Button icon="trash" onClick={() => act('clear_design')}>
              Clear Disk
            </Button>
            <Button icon="eject" onClick={() => act('eject_design')}>
              Eject Disk
            </Button>
          </Box>
        </Box>
      )) || (
        <Box>
          <Box mb={0.5}>This disk has no data stored on it.</Box>
          <Button icon="save" onClick={() => props.onSaveDialog(true)}>
            Load Design To Disk
          </Button>
          <Button icon="eject" onClick={() => act('eject_design')}>
            Eject Disk
          </Button>
        </Box>
      )}
    </Box>
  );
};

const ResearchConsoleDisk = (props) => {
  const { act, data } = useBackend();

  const { d_disk, t_disk } = data.info;

  if (!d_disk.present && !t_disk.present) {
    return <Section title="Disk Operations">No disk inserted.</Section>;
  }

  return (
    <Section title="Disk Operations">
      <TechDisk
        disk={t_disk}
        saveDialog={props.saveDialogTech}
        onSaveDialog={props.onSaveDialogTech}
      />
      <DataDisk
        disk={d_disk}
        saveDialog={props.saveDialogDesign}
        onSaveDialog={props.onSaveDialogDesign}
      />
    </Section>
  );
};

const ResearchConsoleDestructiveAnalyzer = (props) => {
  const { act, data } = useBackend();

  const { linked_destroy } = data.info;

  if (!linked_destroy.present) {
    return (
      <Section title="Destructive Analyzer">
        No destructive analyzer found.
      </Section>
    );
  }

  const { loaded_item, origin_tech } = linked_destroy;

  return (
    <Section title="Destructive Analyzer">
      {(loaded_item && (
        <Box>
          <LabeledList>
            <LabeledList.Item label="Name">{loaded_item}</LabeledList.Item>
            <LabeledList.Item label="Origin Tech">
              <LabeledList>
                {(origin_tech.length &&
                  origin_tech.map((tech) => (
                    <LabeledList.Item label={tech.name} key={tech.name}>
                      {tech.level}&nbsp;&nbsp;
                      {tech.current && '(Current: ' + tech.current + ')'}
                    </LabeledList.Item>
                  ))) || (
                  <LabeledList.Item label="Error">
                    No origin tech found.
                  </LabeledList.Item>
                )}
              </LabeledList>
            </LabeledList.Item>
          </LabeledList>
          <Button
            mt={1}
            color="red"
            icon="eraser"
            onClick={() => act('deconstruct')}
          >
            Deconstruct Item
          </Button>
          <Button icon="eject" onClick={() => act('eject_item')}>
            Eject Item
          </Button>
        </Box>
      )) || <Box>No Item Loaded. Standing-by...</Box>}
    </Section>
  );
};

const ResearchConsoleBuildMenu = (props) => {
  const { act, data } = useBackend();

  const { target, designs, buildName, buildFiveName } = props;

  if (!target) {
    return <Box color="bad">Error</Box>;
  }

  return (
    <Section
      title={<PaginationTitle target="builder_page" title="Designs" />}
      buttons={<PaginationChevrons target={'builder_page'} />}
    >
      <Input
        fluid
        placeholder="Search for..."
        value={data.search}
        onInput={(e, v) => act('search', { search: v })}
        mb={1}
      />
      {designs && designs.length ? (
        designs.map((design) => (
          <Fragment key={design.id}>
            <Flex width="100%" justify="space-between">
              <Flex.Item width="40%" style={{ 'word-wrap': 'break-all' }}>
                {design.name}
              </Flex.Item>
              <Flex.Item width="15%" textAlign="center">
                <Button
                  mb={-1}
                  icon="wrench"
                  onClick={() =>
                    act(buildName, { build: design.id, imprint: design.id })
                  }
                >
                  Build
                </Button>
                {buildFiveName && (
                  <Button
                    mb={-1}
                    onClick={() =>
                      act(buildFiveName, {
                        build: design.id,
                        imprint: design.id,
                      })
                    }
                  >
                    x5
                  </Button>
                )}
              </Flex.Item>
              <Flex.Item width="45%" style={{ 'word-wrap': 'break-all' }}>
                <Box inline color="label">
                  {design.mat_list.join(' ')}
                </Box>
                <Box inline color="average" ml={1}>
                  {design.chem_list.join(' ')}
                </Box>
              </Flex.Item>
            </Flex>
            <Divider />
          </Fragment>
        ))
      ) : (
        <Box>
          No items could be found matching the parameters (page or search).
        </Box>
      )}
    </Section>
  );
};

/* Lathe + Circuit Imprinter all in one */
const ResearchConsoleConstructor = (props) => {
  const { act, data } = useBackend();

  const { name } = props;

  let linked = null;
  let designs = null;

  if (name === 'Protolathe') {
    linked = data.info.linked_lathe;
    designs = data.lathe_designs;
  } else {
    linked = data.info.linked_imprinter;
    designs = data.imprinter_designs;
  }

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

  let queueColor = 'transparent';
  let queueSpin = false;
  let queueIcon = 'layer-group';
  if (busy) {
    queueIcon = 'hammer';
    queueColor = 'average';
    queueSpin = true;
  } else if (queue && queue.length) {
    queueIcon = 'sync';
    queueColor = 'green';
    queueSpin = true;
  }

  // Proto vs Circuit differences
  let removeQueueAction = name === 'Protolathe' ? 'removeP' : 'removeI';
  let ejectSheetAction =
    name === 'Protolathe' ? 'lathe_ejectsheet' : 'imprinter_ejectsheet';
  let ejectChemAction = name === 'Protolathe' ? 'disposeP' : 'disposeI';
  let ejectAllChemAction =
    name === 'Protolathe' ? 'disposeallP' : 'disposeallI';

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
          selected={props.protoTab === 0}
          onClick={() => props.onProtoTab(0)}
        >
          Build
        </Tabs.Tab>
        <Tabs.Tab
          icon={queueIcon}
          iconSpin={queueSpin}
          color={queueColor}
          selected={props.protoTab === 1}
          onClick={() => props.onProtoTab(1)}
        >
          Queue
        </Tabs.Tab>
        <Tabs.Tab
          icon="cookie-bite"
          selected={props.protoTab === 2}
          onClick={() => props.onProtoTab(2)}
        >
          Mat Storage
        </Tabs.Tab>
        <Tabs.Tab
          icon="flask"
          selected={props.protoTab === 3}
          onClick={() => props.onProtoTab(3)}
        >
          Chem Storage
        </Tabs.Tab>
      </Tabs>
      {(props.protoTab === 0 && (
        <ResearchConsoleBuildMenu
          target={linked}
          designs={designs}
          buildName={name === 'Protolathe' ? 'build' : 'imprint'}
          buildFiveName={name === 'Protolathe' ? 'buildfive' : null}
        />
      )) ||
        (props.protoTab === 1 && (
          <LabeledList>
            {(queue.length &&
              queue.map((item, index) => {
                if (item.index === 1) {
                  return (
                    <LabeledList.Item
                      key={index}
                      label={item.name}
                      labelColor="bad"
                    >
                      {!busy ? (
                        <Box>
                          (Awaiting Materials)
                          <Button
                            ml={1}
                            icon="trash"
                            onClick={() =>
                              act(removeQueueAction, {
                                [removeQueueAction]: item.index,
                              })
                            }
                          >
                            Remove
                          </Button>
                        </Box>
                      ) : (
                        <Button disabled icon="trash">
                          Remove
                        </Button>
                      )}
                    </LabeledList.Item>
                  );
                }
                return (
                  <LabeledList.Item label={item.name} key={item.name}>
                    <Button
                      icon="trash"
                      onClick={() =>
                        act(removeQueueAction, {
                          [removeQueueAction]: item.index,
                        })
                      }
                    >
                      Remove
                    </Button>
                  </LabeledList.Item>
                );
              })) || <Box m={1}>Queue Empty.</Box>}
          </LabeledList>
        )) ||
        (props.protoTab === 2 && (
          <LabeledList>
            {mats.map((mat) => {
              return (
                <LabeledList.Item
                  label={toTitleCase(mat.name)}
                  key={mat.name}
                  buttons={
                    <>
                      <NumberInput
                        minValue={0}
                        width="100px"
                        value={props.matsStates[mat.name] || 0}
                        maxValue={mat.sheets}
                        onDrag={(e, val) =>
                          props.onMatsState({
                            ...props.matsStates,
                            [mat.name]: val,
                          })
                        }
                      />
                      <Button
                        icon="eject"
                        disabled={!mat.removable}
                        onClick={() => {
                          props.onMatsState({
                            ...props.matsStates,
                            [mat.name]: 0,
                          });
                          act(ejectSheetAction, {
                            [ejectSheetAction]: mat.name,
                            amount: props.matsStates[mat.name] || 0,
                          });
                        }}
                      >
                        Num
                      </Button>
                      <Button
                        icon="eject"
                        disabled={!mat.removable}
                        onClick={() =>
                          act(ejectSheetAction, {
                            [ejectSheetAction]: mat.name,
                            amount: 50,
                          })
                        }
                      >
                        All
                      </Button>
                    </>
                  }
                >
                  {mat.amount} cm&sup3;
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        )) ||
        (props.protoTab === 3 && (
          <Box>
            <LabeledList>
              {(reagents.length &&
                reagents.map((chem) => (
                  <LabeledList.Item label={chem.name} key={chem.name}>
                    {chem.volume}u
                    <Button
                      ml={1}
                      icon="eject"
                      onClick={() => act(ejectChemAction, { dispose: chem.id })}
                    >
                      Purge
                    </Button>
                  </LabeledList.Item>
                ))) || (
                <LabeledList.Item label="Empty">
                  No chems detected
                </LabeledList.Item>
              )}
            </LabeledList>
            <Button mt={1} icon="trash" onClick={() => act(ejectAllChemAction)}>
              Disposal All Chemicals In Storage
            </Button>
          </Box>
        )) || <Box>Error</Box>}
    </Section>
  );
};

const ResearchConsoleSettings = (props) => {
  const { act, data } = useBackend();

  const { is_public, sync, linked_destroy, linked_imprinter, linked_lathe } =
    data.info;

  return (
    <Section title="Settings">
      <Tabs>
        <Tabs.Tab
          icon="cogs"
          onClick={() => props.onSettingsTab(0)}
          selected={props.settingsTab === 0}
        >
          General
        </Tabs.Tab>
        <Tabs.Tab
          icon="link"
          onClick={() => props.onSettingsTab(1)}
          selected={props.settingsTab === 1}
        >
          Device Linkages
        </Tabs.Tab>
      </Tabs>
      {(props.settingsTab === 0 && (
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
      )) ||
        (props.settingsTab === 1 && (
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
                    onClick={() =>
                      act('disconnect', { disconnect: 'imprinter' })
                    }
                  >
                    Disconnect
                  </Button>
                </LabeledList.Item>
              )) ||
                null}
            </LabeledList>
          </Box>
        )) || <Box>Error</Box>}
    </Section>
  );
};

const menus = [
  {
    name: 'Protolathe',
    icon: 'wrench',
  },
  {
    name: 'Circuit Imprinter',
    icon: 'digital-tachograph',
  },
  {
    name: 'Destructive Analyzer',
    icon: 'eraser',
  },
  {
    name: 'Settings',
    icon: 'cog',
  },
  {
    name: 'Research List',
    icon: 'flask',
  },
  {
    name: 'Design List',
    icon: 'file',
  },
  { name: 'Disk Operations', icon: 'save' },
];

export const ResearchConsole = (props) => {
  const { act, data } = useBackend();

  const { busy_msg, locked } = data;

  const [menu, setMenu] = useSharedState('rdmenu', 0);
  const [protoTab, setProtoTab] = useSharedState('protoTab', 0);
  const [settingsTab, setSettingsTab] = useSharedState('settingsTab', 0);
  const [saveDialogTech, setSaveDialogTech] = useSharedState(
    'saveDialogTech',
    false,
  );
  const [saveDialogDesign, setSaveDialogDesign] = useSharedState(
    'saveDialogData',
    false,
  );

  const [matsStates, setMatsState] = useState({});

  useEffect(() => {
    setMatsState({});
  }, [menu]);

  let allTabsDisabled = false;
  if (busy_msg || locked) {
    allTabsDisabled = true;
  }

  return (
    <Window width={850} height={630}>
      <Window.Content scrollable>
        <Tabs>
          {menus.map((obj, i) => (
            <Tabs.Tab
              key={i}
              icon={obj.icon}
              selected={menu === i}
              settingsTab={settingsTab}
              onClick={() => setMenu(i)}
            >
              {obj.name}
            </Tabs.Tab>
          ))}
        </Tabs>
        {(busy_msg && <Section title="Processing...">{busy_msg}</Section>) ||
          (locked && (
            <Section title="Console Locked">
              <Button onClick={() => act('lock')} icon="lock-open">
                Unlock
              </Button>
            </Section>
          )) ||
          (menu === 0 ? (
            <ResearchConsoleConstructor
              name="Protolathe"
              protoTab={protoTab}
              matsStates={matsStates}
              onProtoTab={setProtoTab}
              onMatsState={setMatsState}
            />
          ) : (
            ''
          )) ||
          (menu === 1 && (
            <ResearchConsoleConstructor
              name="Circuit Imprinter"
              protoTab={protoTab}
              matsStates={matsStates}
              onProtoTab={setProtoTab}
              onMatsState={setMatsState}
            />
          )) ||
          (menu === 2 && (
            <ResearchConsoleDestructiveAnalyzer name="Circuit Imprinter" />
          )) ||
          (menu === 3 && (
            <ResearchConsoleSettings
              settingsTab={settingsTab}
              onSettingsTab={setSettingsTab}
            />
          )) ||
          (menu === 4 && <ResearchConsoleViewResearch />) ||
          (menu === 5 && <ResearchConsoleViewDesigns />) ||
          (menu === 6 && (
            <ResearchConsoleDisk
              saveDialogTech={saveDialogTech}
              saveDialogDesign={saveDialogDesign}
              onSaveDialogTech={setSaveDialogTech}
              onSaveDialogDesign={setSaveDialogDesign}
            />
          ))}
      </Window.Content>
    </Window>
  );
};
