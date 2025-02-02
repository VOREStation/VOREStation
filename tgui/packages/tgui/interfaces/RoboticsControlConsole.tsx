import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  auth: BooleanLike;
  can_hack: BooleanLike;
  cyborgs: cyborg[];
  safety: BooleanLike;
  show_detonate_all: BooleanLike;
};

type cyborg = {
  name: string;
  ref: string;
  locked_down: BooleanLike;
  locstring: string;
  status: number;
  health: number;
  charge: number | null;
  cell_capacity: number | null;
  module: string;
  synchronization: BooleanLike;
  is_hacked: BooleanLike;
  emagged: BooleanLike;
  hackable: BooleanLike;
};

export const RoboticsControlConsole = (props) => {
  const { act, data } = useBackend<Data>();
  const { can_hack, safety, show_detonate_all, cyborgs = [], auth } = data;
  return (
    <Window width={500} height={460}>
      <Window.Content scrollable>
        {!!show_detonate_all && (
          <Section title="Emergency Self Destruct">
            <Button icon={safety ? 'lock' : 'unlock'} selected={safety}>
              {safety ? 'Disable Safety' : 'Enable Safety'}
            </Button>
            <Button
              icon="bomb"
              disabled={safety}
              color="bad"
              onClick={() => act('nuke', {})}
            >
              Destroy ALL Cyborgs
            </Button>
          </Section>
        )}
        <Cyborgs cyborgs={cyborgs} can_hack={can_hack} auth={auth} />
      </Window.Content>
    </Window>
  );
};

const Cyborgs = (props: {
  cyborgs: cyborg[];
  can_hack: BooleanLike;
  auth: BooleanLike;
}) => {
  const { cyborgs, can_hack, auth } = props;
  const { act } = useBackend();
  if (!cyborgs.length) {
    return (
      <NoticeBox>No cyborg units detected within access parameters.</NoticeBox>
    );
  }
  return cyborgs.map((cyborg) => {
    return (
      <Section
        key={cyborg.ref}
        title={cyborg.name}
        buttons={
          <>
            {!!cyborg.hackable && !cyborg.emagged && (
              <Button
                icon="terminal"
                color="bad"
                onClick={() =>
                  act('hackbot', {
                    ref: cyborg.ref,
                  })
                }
              >
                Hack
              </Button>
            )}
            <Button.Confirm
              icon={cyborg.locked_down ? 'unlock' : 'lock'}
              color={cyborg.locked_down ? 'good' : 'default'}
              disabled={!auth}
              onClick={() =>
                act('stopbot', {
                  ref: cyborg.ref,
                })
              }
            >
              {cyborg.locked_down ? 'Release' : 'Lockdown'}
            </Button.Confirm>
            <Button.Confirm
              icon="bomb"
              disabled={!auth}
              color="bad"
              onClick={() =>
                act('killbot', {
                  ref: cyborg.ref,
                })
              }
            >
              Detonate
            </Button.Confirm>
          </>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Status">
            <Box
              color={
                cyborg.status ? 'bad' : cyborg.locked_down ? 'average' : 'good'
              }
            >
              {cyborg.status
                ? 'Not Responding'
                : cyborg.locked_down
                  ? 'Locked Down'
                  : 'Nominal'}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Location">
            <Box>{cyborg.locstring}</Box>
          </LabeledList.Item>
          <LabeledList.Item label="Integrity">
            <ProgressBar
              color={cyborg.health > 50 ? 'good' : 'bad'}
              value={cyborg.health / 100}
            />
          </LabeledList.Item>
          {(typeof cyborg.charge === 'number' && (
            <>
              <LabeledList.Item label="Cell Charge">
                <ProgressBar
                  color={cyborg.charge > 30 ? 'good' : 'bad'}
                  value={cyborg.charge / 100}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Cell Capacity">
                <Box color={cyborg.cell_capacity! < 30000 ? 'average' : 'good'}>
                  {cyborg.cell_capacity}
                </Box>
              </LabeledList.Item>
            </>
          )) || (
            <LabeledList.Item label="Cell">
              <Box color="bad">No Power Cell</Box>
            </LabeledList.Item>
          )}
          {!!cyborg.is_hacked && (
            <LabeledList.Item label="Safeties">
              <Box color="bad">DISABLED</Box>
            </LabeledList.Item>
          )}
          <LabeledList.Item label="Module">{cyborg.module}</LabeledList.Item>
          <LabeledList.Item label="Master AI">
            <Box color={cyborg.synchronization ? 'default' : 'average'}>
              {cyborg.synchronization || 'None'}
            </Box>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  });
};
