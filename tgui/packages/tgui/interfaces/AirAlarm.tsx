import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';
import { Fragment, useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { getGasColor, getGasLabel } from '../constants';
import { Window } from '../layouts';
import { Scrubber, Vent } from './common/AtmosControls';
import { single_scrubber, single_vent } from './common/CommonTypes';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type Data = {
  locked: BooleanLike;
  siliconUser: BooleanLike;
  remoteUser: BooleanLike;
  environment_data: {
    name: string;
    value: number;
    unit: string;
    danger_level: number;
  }[];
  danger_level: number;
  target_temperature: string;
  rcon: number;
  atmos_alarm: BooleanLike;
  fire_alarm: BooleanLike;
  emagged: BooleanLike; // Seems unused
  mode: number;
  thresholds: thresholds[];
  scrubbers: single_scrubber[];
  vents: single_vent[];
  modes: {
    name: string;
    mode: number;
    selected: BooleanLike;
    danger: BooleanLike;
  }[];
};

type thresholds = {
  name: string;
  settings: {
    env: string;
    val: number;
    selected: {
      oxygen: number[];
      carbon_dioxide: number;
      phoron: number;
      other: number;
      pressure: number;
      temperature: number;
    };
  }[];
};

export const AirAlarm = (props) => {
  const { act, data } = useBackend<Data>();

  const { locked, siliconUser, remoteUser } = data;

  const [screen, setScreen] = useState('');

  function handleSetScreen(value) {
    setScreen(value);
  }

  const is_locked: BooleanLike = locked && !siliconUser && !remoteUser;
  return (
    <Window width={440} height={650}>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox />
        <AirAlarmStatus />
        <AirAlarmUnlockedControl />
        {!is_locked && (
          <AirAlarmControl screen={screen} onScreen={handleSetScreen} />
        )}
      </Window.Content>
    </Window>
  );
};

const AirAlarmStatus = (props) => {
  const { data } = useBackend<Data>();

  const { environment_data, atmos_alarm, fire_alarm, emagged } = data;

  const entries = (environment_data || []).filter(
    (entry) => entry.value >= 0.01,
  );
  const dangerMap: Record<number, { color: string; localStatusText: string }> =
    {
      0: {
        color: 'good',
        localStatusText: 'Optimal',
      },
      1: {
        color: 'average',
        localStatusText: 'Caution',
      },
      2: {
        color: 'bad',
        localStatusText: 'Danger (Internals Required)',
      },
    };
  const localStatus = dangerMap[data.danger_level] || dangerMap[0];
  return (
    <Section title="Air Status">
      <LabeledList>
        {(entries.length > 0 && (
          <>
            {entries.map((entry) => {
              const status = dangerMap[entry.danger_level] || dangerMap[0];
              return (
                <LabeledList.Item
                  key={entry.name}
                  label={getGasLabel(entry.name)}
                  color={status.color}
                >
                  {toFixed(entry.value, 2)}
                  {entry.unit}
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item label="Local status" color={localStatus.color}>
              {localStatus.localStatusText}
            </LabeledList.Item>
            <LabeledList.Item
              label="Area status"
              color={atmos_alarm || fire_alarm ? 'bad' : 'good'}
            >
              {(atmos_alarm && 'Atmosphere Alarm') ||
                (fire_alarm && 'Fire Alarm') ||
                'Nominal'}
            </LabeledList.Item>
          </>
        )) || (
          <LabeledList.Item label="Warning" color="bad">
            Cannot obtain air sample for analysis.
          </LabeledList.Item>
        )}
        {!!emagged && (
          <LabeledList.Item label="Warning" color="bad">
            Safety measures offline. Device may exhibit abnormal behavior.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const AirAlarmUnlockedControl = (props) => {
  const { act, data } = useBackend<Data>();
  const { target_temperature, rcon } = data;
  return (
    <Section title="Comfort Settings">
      <LabeledList>
        <LabeledList.Item label="Remote Control">
          <Button
            selected={rcon === 1}
            onClick={() => act('rcon', { rcon: 1 })}
          >
            Off
          </Button>
          <Button
            selected={rcon === 2}
            onClick={() => act('rcon', { rcon: 2 })}
          >
            Auto
          </Button>
          <Button
            selected={rcon === 3}
            onClick={() => act('rcon', { rcon: 3 })}
          >
            On
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Thermostat">
          <Button onClick={() => act('temperature')}>
            {target_temperature}
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const AIR_ALARM_ROUTES = {
  home: {
    title: 'Air Controls',
    component: () => AirAlarmControlHome,
  },
  vents: {
    title: 'Vent Controls',
    component: () => AirAlarmControlVents,
  },
  scrubbers: {
    title: 'Scrubber Controls',
    component: () => AirAlarmControlScrubbers,
  },
  modes: {
    title: 'Operating Mode',
    component: () => AirAlarmControlModes,
  },
  thresholds: {
    title: 'Alarm Thresholds',
    component: () => AirAlarmControlThresholds,
  },
};

const AirAlarmControl = (props) => {
  const route = AIR_ALARM_ROUTES[props.screen] || AIR_ALARM_ROUTES.home;
  const Component = route.component();
  return (
    <Section
      title={route.title}
      buttons={
        props.screen && (
          <Button icon="arrow-left" onClick={() => props.onScreen()}>
            Back
          </Button>
        )
      }
    >
      <Component onScreen={props.onScreen} />
    </Section>
  );
};

//  Home screen
// --------------------------------------------------------

const AirAlarmControlHome = (props) => {
  const { act, data } = useBackend<Data>();
  const { mode, atmos_alarm } = data;
  return (
    <>
      <Button
        icon={atmos_alarm ? 'exclamation-triangle' : 'exclamation'}
        color={atmos_alarm && 'caution'}
        onClick={() => act(atmos_alarm ? 'reset' : 'alarm')}
      >
        Area Atmosphere Alarm
      </Button>
      <Box mt={1} />
      <Button
        icon={mode === 3 ? 'exclamation-triangle' : 'exclamation'}
        color={mode === 3 && 'danger'}
        onClick={() =>
          act('mode', {
            mode: mode === 3 ? 1 : 3,
          })
        }
      >
        Panic Siphon
      </Button>
      <Box mt={2} />
      <Button icon="sign-out-alt" onClick={() => props.onScreen('vents')}>
        Vent Controls
      </Button>
      <Box mt={1} />
      <Button icon="filter" onClick={() => props.onScreen('scrubbers')}>
        Scrubber Controls
      </Button>
      <Box mt={1} />
      <Button icon="cog" onClick={() => props.onScreen('modes')}>
        Operating Mode
      </Button>
      <Box mt={1} />
      <Button icon="chart-bar" onClick={() => props.onScreen('thresholds')}>
        Alarm Thresholds
      </Button>
    </>
  );
};

//  Vents
// --------------------------------------------------------

const AirAlarmControlVents = (props) => {
  const { data } = useBackend<Data>();
  const { vents } = data;
  if (!vents || vents.length === 0) {
    return 'Nothing to show';
  }
  return vents.map((vent) => <Vent key={vent.id_tag} vent={vent} />);
};

//  Scrubbers
// --------------------------------------------------------

const AirAlarmControlScrubbers = (props) => {
  const { data } = useBackend<Data>();
  const { scrubbers } = data;
  if (!scrubbers || scrubbers.length === 0) {
    return 'Nothing to show';
  }
  return scrubbers.map((scrubber) => (
    <Scrubber key={scrubber.id_tag} scrubber={scrubber} />
  ));
};

//  Modes
// --------------------------------------------------------

const AirAlarmControlModes = (props) => {
  const { act, data } = useBackend<Data>();
  const { modes } = data;
  if (!modes || modes.length === 0) {
    return 'Nothing to show';
  }
  return modes.map((mode) => (
    <Fragment key={mode.mode}>
      <Button
        icon={mode.selected ? 'check-square-o' : 'square-o'}
        selected={mode.selected}
        color={mode.selected && mode.danger && 'danger'}
        onClick={() => act('mode', { mode: mode.mode })}
      >
        {mode.name}
      </Button>
      <Box mt={1} />
    </Fragment>
  ));
};

//  Thresholds
// --------------------------------------------------------

const AirAlarmControlThresholds = (props) => {
  const { act, data } = useBackend<Data>();
  const { thresholds } = data;
  return (
    <table className="LabeledList" style={{ width: '100%' }}>
      <thead>
        <tr>
          <td />
          <td className="color-bad">min2</td>
          <td className="color-average">min1</td>
          <td className="color-average">max1</td>
          <td className="color-bad">max2</td>
        </tr>
      </thead>
      <tbody>
        {thresholds.map((threshold) => (
          <tr key={threshold.name}>
            <td className="LabeledList__label">
              <span className={'color-' + getGasColor(threshold.name)}>
                {getGasLabel(threshold.name)}
              </span>
            </td>
            {threshold.settings.map((setting) => (
              <td key={setting.val}>
                <Button
                  onClick={() =>
                    act('threshold', {
                      env: setting.env,
                      var: setting.val,
                    })
                  }
                >
                  {toFixed(setting.selected, 2)}
                </Button>
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
};
