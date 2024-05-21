import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const dangerMap = {
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
  const { act, data } = useBackend();
  const statusMain = dangerMap[data.power.main] || dangerMap[0];
  const statusBackup = dangerMap[data.power.backup] || dangerMap[0];
  const statusElectrify = dangerMap[data.shock] || dangerMap[0];
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
                  disabled={!data.power.main}
                  onClick={() => act('disrupt-main')}
                >
                  Disrupt
                </Button>
              }
            >
              {data.power.main ? 'Online' : 'Offline'}{' '}
              {((!data.wires.main_1 || !data.wires.main_2) &&
                '[Wires have been cut!]') ||
                (data.power.main_timeleft > 0 &&
                  `[${data.power.main_timeleft}s]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Backup"
              color={statusBackup.color}
              buttons={
                <Button
                  icon="lightbulb-o"
                  disabled={!data.power.backup}
                  onClick={() => act('disrupt-backup')}
                >
                  Disrupt
                </Button>
              }
            >
              {data.power.backup ? 'Online' : 'Offline'}{' '}
              {((!data.wires.backup_1 || !data.wires.backup_2) &&
                '[Wires have been cut!]') ||
                (data.power.backup_timeleft > 0 &&
                  `[${data.power.backup_timeleft}s]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Electrify"
              color={statusElectrify.color}
              buttons={
                <>
                  <Button
                    icon="wrench"
                    disabled={!(data.wires.shock && data.shock === 0)}
                    onClick={() => act('shock-restore')}
                  >
                    Restore
                  </Button>
                  <Button
                    icon="bolt"
                    disabled={!data.wires.shock}
                    onClick={() => act('shock-temp')}
                  >
                    Temporary
                  </Button>
                  <Button
                    icon="bolt"
                    disabled={!data.wires.shock}
                    onClick={() => act('shock-perm')}
                  >
                    Permanent
                  </Button>
                </>
              }
            >
              {data.shock === 2 ? 'Safe' : 'Electrified'}{' '}
              {(!data.wires.shock && '[Wires have been cut!]') ||
                (data.shock_timeleft > 0 && `[${data.shock_timeleft}s]`) ||
                (data.shock_timeleft === -1 && '[Permanent]')}
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
                  icon={data.id_scanner ? 'power-off' : 'times'}
                  selected={data.id_scanner}
                  disabled={!data.wires.id_scanner}
                  onClick={() => act('idscan-toggle')}
                >
                  {data.id_scanner ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!data.wires.id_scanner && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Door Bolts"
              color="bad"
              buttons={
                <Button
                  icon={data.locked ? 'lock' : 'unlock'}
                  selected={data.locked}
                  disabled={!data.wires.bolts}
                  onClick={() => act('bolt-toggle')}
                >
                  {data.locked ? 'Lowered' : 'Raised'}
                </Button>
              }
            >
              {!data.wires.bolts && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Door Bolt Lights"
              color="bad"
              buttons={
                <Button
                  icon={data.lights ? 'power-off' : 'times'}
                  selected={data.lights}
                  disabled={!data.wires.lights}
                  onClick={() => act('light-toggle')}
                >
                  {data.lights ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!data.wires.lights && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Door Force Sensors"
              color="bad"
              buttons={
                <Button
                  icon={data.safe ? 'power-off' : 'times'}
                  selected={data.safe}
                  disabled={!data.wires.safe}
                  onClick={() => act('safe-toggle')}
                >
                  {data.safe ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!data.wires.safe && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Door Timing Safety"
              color="bad"
              buttons={
                <Button
                  icon={data.speed ? 'power-off' : 'times'}
                  selected={data.speed}
                  disabled={!data.wires.timing}
                  onClick={() => act('speed-toggle')}
                >
                  {data.speed ? 'Enabled' : 'Disabled'}
                </Button>
              }
            >
              {!data.wires.timing && '[Wires have been cut!]'}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Door Control"
              color="bad"
              buttons={
                <Button
                  icon={data.opened ? 'sign-out-alt' : 'sign-in-alt'}
                  selected={data.opened}
                  disabled={data.locked || data.welded}
                  onClick={() => act('open-close')}
                >
                  {data.opened ? 'Open' : 'Closed'}
                </Button>
              }
            >
              {!!(data.locked || data.welded) && (
                <span>
                  [Door is {data.locked ? 'bolted' : ''}
                  {data.locked && data.welded ? ' and ' : ''}
                  {data.welded ? 'welded' : ''}!]
                </span>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
