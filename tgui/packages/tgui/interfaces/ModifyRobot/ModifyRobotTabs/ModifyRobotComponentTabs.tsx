import { toFixed } from 'common/math';
import { capitalize } from 'common/string';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Collapsible,
  Dropdown,
  Flex,
  Section,
  Slider,
  Stack,
} from 'tgui/components';

import { Cell, Comp, InstalledCell, Target } from '../types';

export const CellCommp = (props: {
  cell: InstalledCell;
  selectedCell: string;
  cell_options: string[];
  setSelectedCell: (value: any) => void;
  cells: Record<string, Cell>;
}) => {
  const { act } = useBackend();
  const { cell, selectedCell, cell_options, setSelectedCell, cells } = props;
  return (
    <Section>
      Current cell:{' '}
      {cell.name ? (
        capitalize(cell.name)
      ) : (
        <Box inline color="red">
          No cell installed!
        </Box>
      )}
      <Slider
        stepPixelSize={5}
        format={(value) => toFixed(value, 2)}
        disabled={!cell.charge}
        minValue={0}
        maxValue={100}
        value={((cell.charge || 0) / (cell.maxcharge || 1)) * 100}
        onChange={(e, value) =>
          act('adjust_cell_charge', {
            charge: (value / 100) * (cell.maxcharge || 0),
          })
        }
      >
        <Flex>
          <Flex.Item>Current charge</Flex.Item>
          <Flex.Item grow />
          <Flex.Item>{cell.charge}</Flex.Item>
        </Flex>
      </Slider>
      <Dropdown
        width="100%"
        selected={selectedCell}
        options={cell_options}
        onSelected={setSelectedCell}
      />
      <Stack vertical>
        <Stack.Item>
          Charge State: {cells[selectedCell]?.charge} /{' '}
          {cells[selectedCell]?.max_charge}
        </Stack.Item>
        <Stack.Item>
          Charge Rate: {cells[selectedCell]?.charge_amount}
        </Stack.Item>
        <Stack.Item>
          Self Charge: {cells[selectedCell]?.self_charge ? 'Yes' : 'No'}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const CompTab = (props: {
  selectedAct: string;
  act_options: string[];
  setSelectedAct: (value: any) => void;
  acts: Record<string, Comp>;
  selectedRad: string;
  rad_options: string[];
  setSelectedRad: (value: any) => void;
  rads: Record<string, Comp>;
  selectedDiag: string;
  diag_options: string[];
  setSelectedDiag: (value: any) => void;
  diags: Record<string, Comp>;
  selectedCam: string;
  cam_options: string[];
  setSelectedCam: (value: any) => void;
  cams: Record<string, Comp>;
  selectedComm: string;
  comm_options: string[];
  setSelectedComm: (value: any) => void;
  comms: Record<string, Comp>;
  selectedArm: string;
  arm_options: string[];
  setSelectedArm: (value: any) => void;
  arms: Record<string, Comp>;
}) => {
  const {
    selectedAct,
    act_options,
    setSelectedAct,
    acts,
    selectedRad,
    rad_options,
    setSelectedRad,
    rads,
    selectedDiag,
    diag_options,
    setSelectedDiag,
    diags,
    selectedCam,
    cam_options,
    setSelectedCam,
    cams,
    selectedComm,
    comm_options,
    setSelectedComm,
    comms,
    selectedArm,
    arm_options,
    setSelectedArm,
    arms,
  } = props;
  return (
    <Section scrollable fill>
      <Dropdown
        width="100%"
        selected={selectedAct}
        options={act_options}
        onSelected={setSelectedAct}
      />
      <ComponentInfo comps={acts[selectedAct]} />
      <Dropdown
        width="100%"
        selected={selectedRad}
        options={rad_options}
        onSelected={setSelectedRad}
      />
      <ComponentInfo comps={rads[selectedRad]} />
      <Dropdown
        width="100%"
        selected={selectedDiag}
        options={diag_options}
        onSelected={setSelectedDiag}
      />
      <ComponentInfo comps={diags[selectedDiag]} />
      <Dropdown
        width="100%"
        selected={selectedCam}
        options={cam_options}
        onSelected={setSelectedCam}
      />
      <ComponentInfo comps={cams[selectedCam]} />
      <Dropdown
        width="100%"
        selected={selectedComm}
        options={comm_options}
        onSelected={setSelectedComm}
      />
      <ComponentInfo comps={comms[selectedComm]} />
      <Dropdown
        width="100%"
        selected={selectedArm}
        options={arm_options}
        onSelected={setSelectedArm}
      />
      <ComponentInfo comps={arms[selectedArm]} />
    </Section>
  );
};

export const BadminTab = (props: { target: Target }) => {
  const { act } = useBackend();
  const { target } = props;
  return (
    <Section scrollable fill>
      <Collapsible title="Badmin">
        {target.components.map((component, i) => {
          return (
            <Collapsible title={capitalize(component.name)} key={i}>
              <Slider
                color="red"
                disabled={component.installed !== 1}
                minValue={0}
                maxValue={component.max_damage * 5 || 0}
                value={component.brute_damage || 0}
                onChange={(e, value) =>
                  act('adjust_brute', {
                    component: component.ref,
                    damage: value,
                  })
                }
              >
                <Flex>
                  <Flex.Item>Brute damage</Flex.Item>
                  <Flex.Item grow />
                  <Flex.Item>{component.brute_damage}</Flex.Item>
                </Flex>
              </Slider>
              <Slider
                color="orange"
                key={i}
                disabled={component.installed !== 1}
                minValue={0}
                maxValue={component.max_damage * 5 || 0}
                value={component.electronics_damage || 0}
                onChange={(e, value) =>
                  act('adjust_electronics', {
                    component: component.ref,
                    damage: value,
                  })
                }
              >
                <Flex>
                  <Flex.Item>Electronics damage</Flex.Item>
                  <Flex.Item grow />
                  <Flex.Item>{component.electronics_damage}</Flex.Item>
                </Flex>
              </Slider>
            </Collapsible>
          );
        })}
      </Collapsible>
    </Section>
  );
};

const ComponentInfo = (props: { comps: Comp }) => {
  const { comps } = props;
  return (
    <Stack vertical>
      <Stack.Item>Max Damage: {comps?.max_damage}</Stack.Item>
      <Stack.Item>
        <Flex>
          <Flex.Item>Idle Power: {comps?.idle_usage}</Flex.Item>
          <Flex.Item grow />
          <Flex.Item>Active Power: {comps?.active_usage}</Flex.Item>
        </Flex>
      </Stack.Item>
    </Stack>
  );
};
