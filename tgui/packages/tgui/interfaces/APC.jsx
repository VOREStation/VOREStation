import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';
import { FullscreenNotice } from './common/FullscreenNotice';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const APC = (props) => {
  const { act, data } = useBackend();

  let body = <ApcContent />;

  if (data.gridCheck) {
    body = <GridCheck />;
  } else if (data.failTime) {
    body = <ApcFailure />;
  }

  return (
    <Window width={450} height={475}>
      <Window.Content scrollable>{body}</Window.Content>
    </Window>
  );
};

const powerStatusMap = {
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

const malfMap = {
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
  const { act, data } = useBackend();
  const locked = data.locked && !data.siliconUser;
  const normallyLocked = data.normallyLocked;
  const externalPowerStatus =
    powerStatusMap[data.externalPower] || powerStatusMap[0];
  const chargingStatus =
    powerStatusMap[data.chargingStatus] || powerStatusMap[0];
  const channelArray = data.powerChannels || [];
  // const malfStatus = malfMap[data.malfStatus] || null;
  const adjustedCellChange = data.powerCellStatus / 100;

  return (
    <>
      <InterfaceLockNoticeBox
        deny={data.emagged}
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
                icon={data.isOperating ? 'power-off' : 'times'}
                selected={data.isOperating && !locked}
                color={data.isOperating ? '' : 'bad'}
                disabled={locked}
                onClick={() => act('breaker')}
              >
                {data.isOperating ? 'On' : 'Off'}
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
            color={chargingStatus.color}
            buttons={
              <Button
                icon={data.chargeMode ? 'sync' : 'times'}
                selected={data.chargeMode}
                disabled={locked}
                onClick={() => act('charge')}
              >
                {data.chargeMode ? 'Auto' : 'Off'}
              </Button>
            }
          >
            [ {chargingStatus.chargingText} ]
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
                        !locked &&
                        (channel.status === 1 || channel.status === 3)
                      }
                      disabled={locked}
                      onClick={() => act('channel', topicParams.auto)}
                    >
                      Auto
                    </Button>
                    <Button
                      icon="power-off"
                      selected={!locked && channel.status === 2}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.on)}
                    >
                      On
                    </Button>
                    <Button
                      icon="times"
                      selected={!locked && channel.status === 0}
                      disabled={locked}
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
            {data.totalCharging ? (
              <b>
                {data.totalLoad} W (+ {data.totalCharging} W charging)
              </b>
            ) : (
              <b>{data.totalLoad} W</b>
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
                icon={data.coverLocked ? 'lock' : 'unlock'}
                selected={data.coverLocked}
                disabled={locked}
                onClick={() => act('cover')}
              >
                {data.coverLocked ? 'Engaged' : 'Disengaged'}
              </Button>
            }
          />
          <LabeledList.Item
            label="Night Shift Lighting"
            buttons={
              <>
                <Button
                  icon="lightbulb-o"
                  selected={data.nightshiftSetting === 2}
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
                  selected={data.nightshiftSetting === 1}
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
                  selected={data.nightshiftSetting === 3}
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
                selected={data.emergencyLights}
                onClick={() => act('emergency_lighting')}
              >
                {data.emergencyLights ? 'Enabled' : 'Disabled'}
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
  const { data, act } = useBackend();

  let rebootOptions = (
    <Button icon="repeat" color="good" onClick={() => act('reboot')}>
      Restart Now
    </Button>
  );

  if (data.locked && !data.siliconUser) {
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
      <Box color="good">Automatic reboot in {data.failTime} seconds...</Box>
      <Box mt={4}>{rebootOptions}</Box>
    </Dimmer>
  );
};
