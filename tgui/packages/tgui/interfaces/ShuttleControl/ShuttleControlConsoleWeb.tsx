import { toTitleCase } from 'common/string';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../../components';
import { getDockingStatus } from './functions';
import { Data } from './types';

/* Ugh. Just ugh. */
export const ShuttleControlConsoleWeb = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    autopilot,
    can_rename,
    shuttle_state,
    is_moving,
    skip_docking,
    docking_status,
    docking_override,
    shuttle_location,
    can_cloak,
    cloaked,
    can_autopilot,
    routes,
    is_in_transit,
    travel_progress,
    time_left,
    doors,
    sensors,
  } = data;

  return (
    <>
      {(autopilot && (
        <Section title="AI PILOT (CLASS D) ACTIVE">
          <Box inline italic>
            This vessel will start and stop automatically. Ensure that all
            non-cycling capable hatches and doors are closed, as the automated
            system may not be able to control them. Docking and flight controls
            are locked. To unlock, disable the automated flight system.
          </Box>
        </Section>
      )) ||
        ''}
      <Section
        title="Shuttle Status"
        buttons={
          (can_rename && (
            <Button icon="pen" onClick={() => act('rename_command')}>
              Rename
            </Button>
          )) ||
          ''
        }
      >
        <LabeledList>
          <LabeledList.Item label="Engines">
            {(shuttle_state === 'idle' && (
              <Box color="#676767" bold>
                IDLE
              </Box>
            )) ||
              (shuttle_state === 'warmup' && (
                <Box color="#336699">SPINNING UP</Box>
              )) ||
              (shuttle_state === 'in_transit' && (
                <Box color="#336699">ENGAGED</Box>
              )) || <Box color="bad">ERROR</Box>}
          </LabeledList.Item>
          {(!is_moving && (
            <>
              <LabeledList.Item label="Current Location">
                {toTitleCase(shuttle_location!)}
              </LabeledList.Item>
              {(!skip_docking && (
                <LabeledList.Item
                  label="Docking Status"
                  buttons={
                    <>
                      <Button
                        selected={docking_status === 'docked'}
                        disabled={
                          docking_status !== 'undocked' &&
                          docking_status !== 'docked'
                        }
                        onClick={() => act('dock_command')}
                      >
                        Dock
                      </Button>
                      <Button
                        selected={docking_status === 'undocked'}
                        disabled={
                          docking_status !== 'docked' &&
                          docking_status !== 'undocked'
                        }
                        onClick={() => act('undock_command')}
                      >
                        Undock
                      </Button>
                    </>
                  }
                >
                  <Box bold inline>
                    {getDockingStatus(docking_status, docking_override)}
                  </Box>
                </LabeledList.Item>
              )) ||
                ''}
              {(can_cloak && (
                <LabeledList.Item label="Cloaking">
                  <Button
                    selected={cloaked}
                    icon={cloaked ? 'eye' : 'eye-o'}
                    onClick={() => act('toggle_cloaked')}
                  >
                    {cloaked ? 'Enabled' : 'Disabled'}
                  </Button>
                </LabeledList.Item>
              )) ||
                ''}
              {(can_autopilot && (
                <LabeledList.Item label="Autopilot">
                  <Button
                    selected={autopilot}
                    icon={autopilot ? 'eye' : 'eye-o'}
                    onClick={() => act('toggle_autopilot')}
                  >
                    {autopilot ? 'Enabled' : 'Disabled'}
                  </Button>
                </LabeledList.Item>
              )) ||
                ''}
            </>
          )) ||
            ''}
        </LabeledList>
        {(!is_moving && (
          <Section title="Available Destinations">
            <LabeledList>
              {(routes!.length &&
                routes!.map((route) => (
                  <LabeledList.Item label={route.name} key={route.name}>
                    <Button
                      icon="rocket"
                      onClick={() => act('traverse', { traverse: route.index })}
                    >
                      {route.travel_time}
                    </Button>
                  </LabeledList.Item>
                ))) || (
                <LabeledList.Item label="Error" color="bad">
                  No routes found.
                </LabeledList.Item>
              )}
            </LabeledList>
          </Section>
        )) ||
          ''}
      </Section>
      {(is_in_transit && (
        <Section title="Transit ETA">
          <LabeledList>
            <LabeledList.Item label="Distance from target">
              <ProgressBar
                color="good"
                minValue={0}
                maxValue={100}
                value={travel_progress!}
              >
                {time_left}s
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )) ||
        ''}
      {(Object.keys(doors!).length && (
        <Section title="Hatch Status">
          <LabeledList>
            {Object.keys(doors!).map((key) => {
              const door = doors![key];
              return (
                <LabeledList.Item label={key} key={key}>
                  {(door.open && (
                    <Box inline color="bad">
                      Open
                    </Box>
                  )) || (
                    <Box inline color="good">
                      Closed
                    </Box>
                  )}
                  &nbsp;-&nbsp;
                  {(door.bolted && (
                    <Box inline color="good">
                      Bolted
                    </Box>
                  )) || (
                    <Box inline color="bad">
                      Unbolted
                    </Box>
                  )}
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      )) ||
        ''}
      {(Object.keys(sensors!).length && (
        <Section title="Sensors">
          <LabeledList>
            {Object.keys(sensors!).map((key, index) => {
              const sensor = sensors![key];
              if (!sensor.reading) {
                return (
                  <LabeledList.Item key={index} label={key} color="bad">
                    Unable to get sensor air reading.
                  </LabeledList.Item>
                );
              }
              return (
                <LabeledList.Item label={key} key={key}>
                  <LabeledList>
                    <LabeledList.Item label="Pressure">
                      {sensor.pressure}kPa
                    </LabeledList.Item>
                    <LabeledList.Item label="Temperature">
                      {sensor.temp}&deg;C
                    </LabeledList.Item>
                    <LabeledList.Item label="Oxygen">
                      {sensor.oxygen}%
                    </LabeledList.Item>
                    <LabeledList.Item label="Nitrogen">
                      {sensor.nitrogen}%
                    </LabeledList.Item>
                    <LabeledList.Item label="Carbon Dioxide">
                      {sensor.carbon_dioxide}%
                    </LabeledList.Item>
                    <LabeledList.Item label="Phoron">
                      {sensor.phoron}%
                    </LabeledList.Item>
                    {(sensor.other && (
                      <LabeledList.Item label="Other">
                        {sensor.other}%
                      </LabeledList.Item>
                    )) ||
                      ''}
                  </LabeledList>
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      )) ||
        ''}
    </>
  );
};
