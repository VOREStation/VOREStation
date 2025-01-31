import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Dimmer,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { FullscreenNotice } from './common/FullscreenNotice';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type Data = {
  gridCheck: BooleanLike;
  failTime: number;
  locked: BooleanLike;
  normallyLocked: BooleanLike;
  siliconUser: BooleanLike;
  externalPower;
  chargingStatus;
  powerChannels: {
    title: string;
    powerLoad: number;
    status: number;
    topicParams: {
      auto: Record<string, number>;
      on: Record<string, number>;
      off: Record<string, number>;
    }[];
  };
  powerCellStatus: number;
  emagged: BooleanLike;
  isOperating: BooleanLike;
  chargeMode: BooleanLike;
  totalCharging: number;
  totalLoad: number;
  coverLocked: BooleanLike;
  nightshiftLights: BooleanLike;
  nightshiftSetting: number;
  emergencyLights: boolean;
};

export const APC = (props) => {
  const { act, data } = useBackend<Data>();

  const { gridCheck, failTime } = data;

  let body = <ApcContent />;

  if (gridCheck) {
    body = <GridCheck />;
  } else if (failTime) {
    body = <ApcFailure />;
  }

  return (
    <Window width={450} height={475}>
      <Window.Content scrollable>{body}</Window.Content>
    </Window>
  );
};

type powerStatus = {
  color: string;
  externalPowerText: string;
  chargingText: string;
};

const powerStatusMap: Record<number, powerStatus> = {
  2: {
    color: 'good',
    externalPowerText: 'External Power',
    chargingText: 'Fully Charged',
  },
  1: {
    color: 'average',
    externalPowerText: 'Low External Power',
    chargingText: 'Charging',
  },
  0: {
    color: 'bad',
    externalPowerText: 'No External Power',
    chargingText: 'Not Charging',
  },
};

const malfMap: Record<
  number,
  { icon: string; content: string; action: string }
> = {
  1: {
    icon: 'terminal',
    content: 'Override Programming',
    action: 'hack',
  },
  // 2: {
  //   icon: 'caret-square-down',
  //   content: 'Shunt Core Process',
  //   action: 'occupy',
  // },
  // 3: {
  //   icon: 'caret-square-left',
  //   content: 'Return to Main Core',
  //   action: 'deoccupy',
  // },
  // 4: {
  //   icon: 'caret-square-down',
  //   content: 'Shunt Core Process',
  //   action: 'occupy',
  // },
};

const ApcContent = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    locked,
    siliconUser,
    externalPower,
    chargingStatus,
    powerChannels,
    powerCellStatus,
    emagged,
    isOperating,
    chargeMode,
    totalCharging,
    totalLoad,
    coverLocked,
    nightshiftSetting,
    emergencyLights,
  } = data;

  const is_locked: BooleanLike = locked && !siliconUser;
  const externalPowerStatus: powerStatus =
    powerStatusMap[externalPower] || powerStatusMap[0];
  const chargingPowerStatus: powerStatus =
    powerStatusMap[chargingStatus] || powerStatusMap[0];
  const channelArray: any = powerChannels || [];
  // const malfStatus = malfMap[data.malfStatus] || null;
  const adjustedCellChange: number = powerCellStatus / 100;

  return (
    <>
      <InterfaceLockNoticeBox
        deny={emagged}
        denialMessage={
          <>
            <Box color="bad" fontSize="1.5rem">
              Fault in ID authenticator.
            </Box>
            <Box color="bad">Please contact maintenance for service.</Box>
          </>
        }
      />
      <Section title="Power Status">
        <LabeledList>
          <LabeledList.Item
            label="Main Breaker"
            color={externalPowerStatus.color}
            buttons={
              <Button
                icon={isOperating ? 'power-off' : 'times'}
                selected={isOperating && !is_locked}
                color={isOperating ? '' : 'bad'}
                disabled={is_locked}
                onClick={() => act('breaker')}
              >
                {isOperating ? 'On' : 'Off'}
              </Button>
            }
          >
            [ {externalPowerStatus.externalPowerText} ]
          </LabeledList.Item>
          <LabeledList.Item label="Power Cell">
            <ProgressBar color="good" value={adjustedCellChange} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Charge Mode"
            color={chargingPowerStatus.color}
            buttons={
              <Button
                icon={chargeMode ? 'sync' : 'times'}
                selected={chargeMode}
                disabled={is_locked}
                onClick={() => act('charge')}
              >
                {chargeMode ? 'Auto' : 'Off'}
              </Button>
            }
          >
            [ {chargingPowerStatus.chargingText} ]
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Power Channels">
        <LabeledList>
          {channelArray.map((channel) => {
            const { topicParams } = channel;
            return (
              <LabeledList.Item
                key={channel.title}
                label={channel.title}
                buttons={
                  <>
                    <Box
                      inline
                      mx={2}
                      color={channel.status >= 2 ? 'good' : 'bad'}
                    >
                      {channel.status >= 2 ? 'On' : 'Off'}
                    </Box>
                    <Button
                      icon="sync"
                      selected={
                        !is_locked &&
                        (channel.status === 1 || channel.status === 3)
                      }
                      disabled={is_locked}
                      onClick={() => act('channel', topicParams.auto)}
                    >
                      Auto
                    </Button>
                    <Button
                      icon="power-off"
                      selected={!is_locked && channel.status === 2}
                      disabled={is_locked}
                      onClick={() => act('channel', topicParams.on)}
                    >
                      On
                    </Button>
                    <Button
                      icon="times"
                      selected={!is_locked && channel.status === 0}
                      disabled={is_locked}
                      onClick={() => act('channel', topicParams.off)}
                    >
                      Off
                    </Button>
                  </>
                }
              >
                {channel.powerLoad} W
              </LabeledList.Item>
            );
          })}
          <LabeledList.Item label="Total Load">
            {totalCharging ? (
              <b>
                {totalLoad} W (+ {totalCharging} W charging)
              </b>
            ) : (
              <b>{totalLoad} W</b>
            )}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Misc"
        buttons={
          !!data.siliconUser && (
            <Button icon="lightbulb-o" onClick={() => act('overload')}>
              Overload
            </Button>
          )
        }
      >
        <LabeledList>
          <LabeledList.Item
            label="Cover Lock"
            buttons={
              <Button
                icon={coverLocked ? 'lock' : 'unlock'}
                selected={coverLocked}
                disabled={is_locked}
                onClick={() => act('cover')}
              >
                {coverLocked ? 'Engaged' : 'Disengaged'}
              </Button>
            }
          />
          <LabeledList.Item
            label="Night Shift Lighting"
            buttons={
              <>
                <Button
                  icon="lightbulb-o"
                  selected={nightshiftSetting === 2}
                  onClick={() =>
                    act('nightshift', {
                      nightshift: 2,
                    })
                  }
                >
                  Disabled
                </Button>
                <Button
                  icon="lightbulb-o"
                  selected={nightshiftSetting === 1}
                  onClick={() =>
                    act('nightshift', {
                      nightshift: 1,
                    })
                  }
                >
                  Automatic
                </Button>
                <Button
                  icon="lightbulb-o"
                  selected={nightshiftSetting === 3}
                  onClick={() =>
                    act('nightshift', {
                      nightshift: 3,
                    })
                  }
                >
                  Enabled
                </Button>
              </>
            }
          />
          <LabeledList.Item
            label="Emergency Lighting"
            buttons={
              <Button
                icon="lightbulb-o"
                selected={emergencyLights}
                onClick={() => act('emergency_lighting')}
              >
                {emergencyLights ? 'Enabled' : 'Disabled'}
              </Button>
            }
          />
        </LabeledList>
      </Section>
    </>
  );
};

const GridCheck = (props) => {
  return (
    <FullscreenNotice title="System Failure">
      <Box fontSize="1.5rem" bold>
        <Icon
          name="exclamation-triangle"
          verticalAlign="middle"
          size={3}
          mr="1rem"
        />
      </Box>
      <Box fontSize="1.5rem" bold>
        Power surge detected, grid check in effect...
      </Box>
    </FullscreenNotice>
  );
};

const ApcFailure = (props) => {
  const { data, act } = useBackend<Data>();

  const { locked, siliconUser, failTime } = data;

  let rebootOptions = (
    <Button icon="repeat" color="good" onClick={() => act('reboot')}>
      Restart Now
    </Button>
  );

  if (locked && !siliconUser) {
    rebootOptions = <Box color="bad">Swipe an ID card for manual reboot.</Box>;
  }

  return (
    <Dimmer textAlign="center">
      <Box color="bad">
        <h1>SYSTEM FAILURE</h1>
      </Box>
      <Box color="average">
        <h2>
          I/O regulators malfunction detected! Waiting for system reboot...
        </h2>
      </Box>
      <Box color="good">Automatic reboot in {failTime} seconds...</Box>
      <Box mt={4}>{rebootOptions}</Box>
    </Dimmer>
  );
};
