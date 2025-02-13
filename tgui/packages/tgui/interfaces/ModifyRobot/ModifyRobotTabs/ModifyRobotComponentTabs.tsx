import { useBackend } from 'tgui/backend';
import {
  Box,
  Collapsible,
  Dropdown,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { capitalize } from 'tgui-core/string';

import type { Cell, Comp, InstalledCell, Target } from '../types';

export const CellCommp = (props: {
  cell: InstalledCell;
  selectedCell: string;
  cell_options: string[];
  onSelectedCell: (value: any) => void;
  cells: Record<string, Cell>;
}) => {
  const { act } = useBackend();
  const { cell, selectedCell, cell_options, onSelectedCell, cells } = props;
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
        <Stack>
          <Stack.Item>Current charge</Stack.Item>
          <Stack.Item grow />
          <Stack.Item>{cell.charge}</Stack.Item>
        </Stack>
      </Slider>
      <Dropdown
        width="100%"
        selected={selectedCell}
        options={cell_options}
        onSelected={onSelectedCell}
      />
      <Stack vertical>
        <Stack.Item>Max Damage: {cells[selectedCell]?.max_damage}</Stack.Item>
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
  onSelectedAct: (value: any) => void;
  acts: Record<string, Comp>;
  selectedRad: string;
  rad_options: string[];
  onSelectedRad: (value: any) => void;
  rads: Record<string, Comp>;
  selectedDiag: string;
  diag_options: string[];
  onSelectedDiag: (value: any) => void;
  diags: Record<string, Comp>;
  selectedCam: string;
  cam_options: string[];
  onSelectedCam: (value: any) => void;
  cams: Record<string, Comp>;
  selectedComm: string;
  comm_options: string[];
  onSelectedComm: (value: any) => void;
  comms: Record<string, Comp>;
  selectedArm: string;
  arm_options: string[];
  onSelectedArm: (value: any) => void;
  arms: Record<string, Comp>;
}) => {
  const {
    selectedAct,
    act_options,
    onSelectedAct,
    acts,
    selectedRad,
    rad_options,
    onSelectedRad,
    rads,
    selectedDiag,
    diag_options,
    onSelectedDiag,
    diags,
    selectedCam,
    cam_options,
    onSelectedCam,
    cams,
    selectedComm,
    comm_options,
    onSelectedComm,
    comms,
    selectedArm,
    arm_options,
    onSelectedArm,
    arms,
  } = props;
  return (
    <Section scrollable fill>
      <Dropdown
        width="100%"
        selected={selectedAct}
        options={act_options}
        onSelected={onSelectedAct}
      />
      <ComponentInfo comps={acts[selectedAct]} />
      <Dropdown
        width="100%"
        selected={selectedRad}
        options={rad_options}
        onSelected={onSelectedRad}
      />
      <ComponentInfo comps={rads[selectedRad]} />
      <Dropdown
        width="100%"
        selected={selectedDiag}
        options={diag_options}
        onSelected={onSelectedDiag}
      />
      <ComponentInfo comps={diags[selectedDiag]} />
      <Dropdown
        width="100%"
        selected={selectedCam}
        options={cam_options}
        onSelected={onSelectedCam}
      />
      <ComponentInfo comps={cams[selectedCam]} />
      <Dropdown
        width="100%"
        selected={selectedComm}
        options={comm_options}
        onSelected={onSelectedComm}
      />
      <ComponentInfo comps={comms[selectedComm]} />
      <Dropdown
        width="100%"
        selected={selectedArm}
        options={arm_options}
        onSelected={onSelectedArm}
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
                <Stack>
                  <Stack.Item>Brute damage</Stack.Item>
                  <Stack.Item grow />
                  <Stack.Item>{component.brute_damage}</Stack.Item>
                </Stack>
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
                <Stack>
                  <Stack.Item>Electronics damage</Stack.Item>
                  <Stack.Item grow />
                  <Stack.Item>{component.electronics_damage}</Stack.Item>
                </Stack>
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
        <Stack>
          <Stack.Item>Idle Power: {comps?.idle_usage}</Stack.Item>
          <Stack.Item grow />
          <Stack.Item>Active Power: {comps?.active_usage}</Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
