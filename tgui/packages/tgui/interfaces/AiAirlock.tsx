import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  power: {
    main: number;
    main_timeleft: number;
    backup: number;
    backup_timeleft: number;
  };
  wires: {
    main_1: BooleanLike;
    main_2: BooleanLike;
    backup_1: BooleanLike;
    backup_2: BooleanLike;
    shock: BooleanLike;
    id_scanner: BooleanLike;
    bolts: BooleanLike;
    lights: BooleanLike;
    safe: BooleanLike;
    timing: BooleanLike;
  };
  shock: number;
  shock_timeleft: number;
  id_scanner: BooleanLike;
  lights: BooleanLike;
  locked: BooleanLike;
  safe: BooleanLike;
  speed: BooleanLike;
  opened: BooleanLike;
  welded: BooleanLike;
};

const dangerMap: Record<number, { color: string; localStatusText: string }> = {
  2: {
    color: 'good',
    localStatusText: 'Optimal',
  },
  1: {
    color: 'average',
    localStatusText: 'Caution',
  },
  0: {
    color: 'bad',
    localStatusText: 'Offline',
  },
};

export const AiAirlock = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    power,
    wires,
    shock,
    shock_timeleft,
    id_scanner,
    lights,
    locked,
    safe,
    speed,
    opened,
    welded,
  } = data;

  const statusMain = dangerMap[power.main] || dangerMap[0];
  const statusBackup = dangerMap[power.backup] || dangerMap[0];
  const statusElectrify = dangerMap[shock] || dangerMap[0];
  return (
    <Window width={500} height={390}>
      <Window.Content>
        <Section title="Power Status">
          <LabeledList>
            <LabeledList.Item
              label="Main"
              color={statusMain.color}
              buttons={
                <Button
                  icon="lightbulb-o"
                  disabled={!power.main}
                  onClick={() => act('disrupt-main')}
                >
                  Disrupt
                </Button>
              }
            >
              {power.main ? 'Online' : 'Offline'}{' '}
              {((!wires.main_1 || !wires.main_2) && '[Wires have been cut!]') ||
                (power.main_timeleft > 0 && `[${power.main_timeleft}s]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Backup"
              color={statusBackup.color}
              buttons={
                <Button
                  icon="lightbulb-o"
                  disabled={!power.backup}
                  onClick={() => act('disrupt-backup')}
                >
                  Disrupt
                </Button>
              }
            >
              {power.backup ? 'Online' : 'Offline'}{' '}
              {((!wires.backup_1 || !wires.backup_2) &&
                '[Wires have been cut!]') ||
                (power.backup_timeleft > 0 && `[${power.backup_timeleft}s]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Electrify"
              color={statusElectrify.color}
              buttons={
                <>
                  <Button
                    icon="wrench"
                    disabled={!(wires.shock && shock === 0)}
                    onClick={() => act('shock-restore')}
                  >
                    Restore
                  </Button>
                  <Button
                    icon="bolt"
                    disabled={!wires.shock}
                    onClick={() => act('shock-temp')}
                  >
                    Temporary
                  </Button>
                  <Button
                    icon="bolt"
                    disabled={!wires.shock}
                    onClick={() => act('shock-perm')}
                  >
                    Permanent
                  </Button>
                </>
              }
            >
              {shock === 2 ? 'Safe' : 'Electrified'}{' '}
              {(!wires.shock && '[Wires have been cut!]') ||
                (shock_timeleft > 0 && `[${shock_timeleft}s]`) ||
                (shock_timeleft === -1 && '[Permanent]')}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Access and Door Control">
          <LabeledList>
            <LabeledList.Item
              label="ID Scan"
              color="bad"
              buttons={
                <Button
                  icon={id_scanner ? 'power-off' : 'times'}
                  selected={id_scanner}
                  disabled={!wires.id_scanner}
                  onClick={() => act('idscan-toggle')}
                >
                  {id_scanner ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!wires.id_scanner && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Door Bolts"
              color="bad"
              buttons={
                <Button
                  icon={locked ? 'lock' : 'unlock'}
                  selected={locked}
                  disabled={!wires.bolts}
                  onClick={() => act('bolt-toggle')}
                >
                  {locked ? 'Lowered' : 'Raised'}
                </Button>
              }
            >
              {!wires.bolts && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Door Bolt Lights"
              color="bad"
              buttons={
                <Button
                  icon={lights ? 'power-off' : 'times'}
                  selected={lights}
                  disabled={!wires.lights}
                  onClick={() => act('light-toggle')}
                >
                  {lights ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!wires.lights && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Door Force Sensors"
              color="bad"
              buttons={
                <Button
                  icon={safe ? 'power-off' : 'times'}
                  selected={safe}
                  disabled={!wires.safe}
                  onClick={() => act('safe-toggle')}
                >
                  {safe ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!wires.safe && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Door Timing Safety"
              color="bad"
              buttons={
                <Button
                  icon={speed ? 'power-off' : 'times'}
                  selected={speed}
                  disabled={!wires.timing}
                  onClick={() => act('speed-toggle')}
                >
                  {speed ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!wires.timing && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Door Control"
              color="bad"
              buttons={
                <Button
                  icon={opened ? 'sign-out-alt' : 'sign-in-alt'}
                  selected={opened}
                  disabled={locked || welded}
                  onClick={() => act('open-close')}
                >
                  {opened ? 'Open' : 'Closed'}
                </Button>
              }
            >
              {!!(locked || welded) && (
                <span>
                  [Door is {locked ? 'bolted' : ''}
                  {locked && welded ? ' and ' : ''}
                  {welded ? 'welded' : ''}!]
                </span>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
