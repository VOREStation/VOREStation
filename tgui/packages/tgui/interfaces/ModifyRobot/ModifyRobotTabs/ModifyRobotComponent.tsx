import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

import { NoSpriteWarning } from '../components';
import {
  ACTUATOR,
  ARMOUR,
  CAMERA,
  COMMS,
  DIAGNOSIS,
  POWERCELL,
  RADIO,
} from '../constants';
import { prepareSearch } from '../functions';
import { Cell, Comp, Component, InstalledCell, Lookup, Target } from '../types';
import { BadminTab, CellCommp, CompTab } from './ModifyRobotComponentTabs';

export const ModifyRobotComponent = (props: {
  target: Target;
  cell: InstalledCell;
  cells: Record<string, Cell>;
  cams: Record<string, Comp>;
  rads: Record<string, Comp>;
  acts: Record<string, Comp>;
  diags: Record<string, Comp>;
  comms: Record<string, Comp>;
  arms: Record<string, Comp>;
  gear: Record<string, string>;
}) => {
  const { target, cell, cells, cams, rads, acts, diags, comms, arms, gear } =
    props;
  const [searchComponentReplaceText, setSearchComponentReplaceText] =
    useState<string>('');
  const [searchComponentRemoveText, setSearchComponentRemoveText] =
    useState<string>('');
  const [selectedCell, setSelectedCell] = useState<string>(cell.name || '');
  const [selectedCam, setSelectedCam] = useState<string>(gear[CAMERA] || '');
  const [selectedRad, setSelectedRad] = useState<string>(gear[RADIO] || '');
  const [selectedAct, setSelectedAct] = useState<string>(gear[ACTUATOR] || '');
  const [selectedDiag, setSelectedDiag] = useState<string>(
    gear[DIAGNOSIS] || '',
  );
  const [selectedComm, setSelectedComm] = useState<string>(gear[COMMS] || '');
  const [selectedArm, setSelectedArm] = useState<string>(gear[ARMOUR] || '');
  const [tab, setTab] = useState<number>(0);
  const cell_options = Object.keys(cells) as Array<string>;
  const cam_options = Object.keys(cams) as Array<string>;
  const rad_options = Object.keys(rads) as Array<string>;
  const act_options = Object.keys(acts) as Array<string>;
  const diag_options = Object.keys(diags) as Array<string>;
  const comm_options = Object.keys(comms) as Array<string>;
  const arm_options = Object.keys(arms) as Array<string>;

  const tabs: React.JSX.Element[] = [];

  tabs[0] = (
    <CellCommp
      cell={cell}
      selectedCell={selectedCell}
      cell_options={cell_options}
      onSelectedCell={setSelectedCell}
      cells={cells}
    />
  );
  tabs[1] = (
    <CompTab
      selectedAct={selectedAct}
      act_options={act_options}
      onSelectedAct={setSelectedAct}
      acts={acts}
      selectedRad={selectedRad}
      rad_options={rad_options}
      onSelectedRad={setSelectedRad}
      rads={rads}
      selectedDiag={selectedDiag}
      diag_options={diag_options}
      onSelectedDiag={setSelectedDiag}
      diags={diags}
      selectedCam={selectedCam}
      cam_options={cam_options}
      onSelectedCam={setSelectedCam}
      cams={cams}
      selectedComm={selectedComm}
      comm_options={comm_options}
      onSelectedComm={setSelectedComm}
      comms={comms}
      selectedArm={selectedArm}
      arm_options={arm_options}
      onSelectedArm={setSelectedArm}
      arms={arms}
    />
  );
  tabs[2] = <BadminTab target={target} />;

  const componentLookup: Lookup[] = [];

  componentLookup[ACTUATOR] = {
    path: acts[selectedAct]?.path,
    selected: selectedAct,
    active: gear[ACTUATOR] || undefined,
  };
  componentLookup[RADIO] = {
    path: rads[selectedRad]?.path,
    selected: selectedRad,
    active: gear[RADIO] || undefined,
  };
  componentLookup[POWERCELL] = {
    path: cells[selectedCell]?.path,
    selected: selectedCell,
    active: cell.name || undefined,
  };
  componentLookup[CAMERA] = {
    path: cams[selectedCam]?.path,
    selected: selectedCam,
    active: gear[CAMERA] || undefined,
  };

  componentLookup[DIAGNOSIS] = {
    path: diags[selectedDiag]?.path,
    selected: selectedDiag,
    active: gear[DIAGNOSIS] || undefined,
  };

  componentLookup[COMMS] = {
    path: comms[selectedComm]?.path,
    selected: selectedComm,
    active: gear[COMMS] || undefined,
  };

  componentLookup[ARMOUR] = {
    path: arms[selectedArm]?.path,
    selected: selectedArm,
    active: gear[ARMOUR] || undefined,
  };
  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Stack height={!target.active ? '75%' : '80%'}>
        <Stack.Item width="35%">
          <ComponentSection
            title="Repair Component"
            searchText={searchComponentReplaceText}
            onSearchText={setSearchComponentReplaceText}
            components={target.components}
            action="add_component"
            buttonColor="green"
            buttonIcon="arrows-spin"
            componentLookup={componentLookup}
          />
        </Stack.Item>
        <Stack.Item width="30%">
          <Stack vertical fill>
            <Stack.Item>
              <Stack>
                <Stack.Item grow />
                <Stack.Item>
                  <Box
                    className={classes([
                      target.sprite_size,
                      target.sprite + 'E',
                    ])}
                  />
                </Stack.Item>
                <Stack.Item grow />
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Tabs>
                <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>
                  Power Cell
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
                  Components
                </Tabs.Tab>
                <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
                  Badmin
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            {tabs[tab]}
          </Stack>
        </Stack.Item>
        <Stack.Item width="35%">
          <ComponentSection
            title="Remove Component"
            searchText={searchComponentRemoveText}
            onSearchText={setSearchComponentRemoveText}
            components={target.components}
            action="rem_component"
            buttonColor="red"
            buttonIcon="burst"
          />
        </Stack.Item>
      </Stack>
    </>
  );
};

const ComponentSection = (props: {
  title: string;
  searchText: string;
  onSearchText: Function;
  components: Component[];
  action: string;
  buttonColor: string;
  buttonIcon: string;
  componentLookup?: Lookup[];
}) => {
  const { act } = useBackend();
  const {
    title,
    searchText,
    onSearchText,
    components,
    action,
    buttonColor,
    buttonIcon,
    componentLookup = [],
  } = props;
  return (
    <Section title={title} fill scrollable>
      <Input
        fluid
        value={searchText}
        placeholder="Search for components..."
        onInput={(e, value: string) => onSearchText(value)}
      />
      <Divider />
      <Stack>
        <Stack.Item width="100%">
          {prepareSearch(components, searchText).map((component, i) => {
            return (
              <Button
                fluid
                key={i}
                tooltip={getComponentTooltip(
                  component,
                  action,
                  componentLookup[component.name]?.selected,
                  componentLookup[component.name]?.active,
                )}
                color={getComponentColor(component, action)}
                disabled={checkDisabled(
                  component,
                  action,
                  componentLookup[component.name]?.selected,
                  componentLookup[component.name]?.active,
                )}
                onClick={() =>
                  act(action, {
                    component: component.ref,
                    new_part: componentLookup[component.name]?.path,
                  })
                }
              >
                <Stack vertical>
                  <Stack.Item>
                    <Stack align="center">
                      <Stack.Item>
                        {capitalize(component.name)}{' '}
                        {action === 'add_component' &&
                          '(' + component.max_damage + ')'}
                      </Stack.Item>
                      <Stack.Item grow />
                      <Stack.Item>
                        <Icon
                          name={buttonIcon}
                          backgroundColor={buttonColor}
                          size={1.5}
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  {action === 'add_component' && (
                    <Stack>
                      <Stack.Item>
                        Idle Power: {component.idle_usage}
                      </Stack.Item>
                      <Stack.Item grow />
                      <Stack.Item>
                        Active Power: {component.active_usage}
                      </Stack.Item>
                    </Stack>
                  )}
                  <Stack.Item />
                  <Stack.Item>
                    {action === 'add_component' &&
                      'Brute Damage: ' + component.brute_damage}
                  </Stack.Item>
                  {action === 'add_component' &&
                    'Electronics Damage: ' + component.electronics_damage}
                  <Stack.Item />
                </Stack>
              </Button>
            );
          })}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

function checkDisabled(
  component: Component,
  action: string,
  selected: string | undefined,
  active: string | undefined,
): boolean {
  switch (action) {
    case 'rem_component':
      return !component.exists;
    case 'add_component':
      if (selected && active && selected !== active) {
        return false;
      }
      return (
        component.installed === 1 &&
        !!component.exists &&
        component.brute_damage === 0 &&
        component.electronics_damage === 0
      );
  }
  return false;
}

function getComponentTooltip(
  component: Component,
  action: string,
  selected: string | undefined,
  active: string | undefined,
): string {
  switch (action) {
    case 'add_component':
      if (component.installed === 0 || !component.exists) {
        return 'Component missing!';
      }
      if (
        component.installed === -1 ||
        component.brute_damage + component.electronics_damage >=
          component.max_damage
      ) {
        return 'Component destroyed!';
      }
      if (checkDisabled(component, action, selected, active)) {
        return 'Disabled due to fully intact component!';
      }
      return '';
    case 'rem_component':
      return component.exists ? '' : 'Disabled due to missing component!';
  }
  return '';
}

function getComponentColor(
  component: Component,
  action: string,
): string | undefined {
  switch (action) {
    case 'add_component':
      if (
        component.brute_damage + component.electronics_damage >=
          component.max_damage ||
        component.installed !== 1 ||
        !component.exists
      ) {
        return 'black';
      }
      if (
        (component.brute_damage + component.electronics_damage) /
          component.max_damage >
        0.66
      ) {
        return 'red';
      }
      if (
        (component.brute_damage + component.electronics_damage) /
          component.max_damage >
        0.33
      ) {
        return 'orange';
      }
      if (
        (component.brute_damage + component.electronics_damage) /
          component.max_damage >
        0
      ) {
        return 'yellow';
      }
      return undefined;
    case 'rem_component':
      return undefined;
  }
  return '';
}
