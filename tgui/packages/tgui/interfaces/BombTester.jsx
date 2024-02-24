import { Component } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Icon, LabeledList, Section, Slider } from '../components';
import { Window } from '../layouts';

export const BombTester = (props) => {
  const { act, data } = useBackend();

  const {
    simulating,
    mode,
    tank1,
    tank1ref,
    tank2,
    tank2ref,
    canister,
    sim_canister_output,
  } = data;

  return (
    <Window width={450} height={400}>
      <Window.Content>
        {(simulating && <BombTesterSimulation />) || (
          <Section title="Virtual Explosive Simulator v2.01">
            <LabeledList>
              <LabeledList.Item label="Mode">
                <Button
                  onClick={() => act('set_mode', { mode: 1 })}
                  selected={mode === 1}
                >
                  Single Tank
                </Button>
                <Button
                  onClick={() => act('set_mode', { mode: 2 })}
                  selected={mode === 2}
                >
                  Transfer Valve
                </Button>
                <Button
                  onClick={() => act('set_mode', { mode: 3 })}
                  selected={mode === 3}
                >
                  Canister
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Primary Slot">
                {(tank1 && (
                  <Button
                    onClick={() => act('remove_tank', { ref: tank1ref })}
                    icon="eject"
                  >
                    {tank1}
                  </Button>
                )) || (
                  <Button
                    onClick={() => act('add_tank', { slot: 1 })}
                    icon="upload"
                  >
                    Insert Tank
                  </Button>
                )}
              </LabeledList.Item>
              <LabeledList.Item label="Secondary Slot">
                {(tank2 && (
                  <Button
                    onClick={() => act('remove_tank', { ref: tank2ref })}
                    icon="eject"
                  >
                    {tank2}
                  </Button>
                )) || (
                  <Button
                    onClick={() => act('add_tank', { slot: 2 })}
                    icon="upload"
                  >
                    Insert Tank
                  </Button>
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Connected Canister"
                buttons={
                  <Button onClick={() => act('canister_scan')} icon="search">
                    Scan
                  </Button>
                }
              >
                {(canister && <Box color="label">{canister}</Box>) || (
                  <Box color="bad">No tank connected.</Box>
                )}
              </LabeledList.Item>
              {canister && (
                <LabeledList.Item label="Canister Release Pressure">
                  <Slider
                    minValue={0}
                    value={sim_canister_output}
                    maxValue={1013.25}
                    onDrag={(e, val) =>
                      act('set_can_pressure', { pressure: val })
                    }
                  />
                </LabeledList.Item>
              )}
            </LabeledList>
            <Button
              mt={2}
              color="red"
              icon="bomb"
              fontSize={2}
              onClick={() => act('start_sim')}
              fluid
            >
              Begin Simulation
            </Button>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

class BombTesterSimulation extends Component {
  constructor(props) {
    super(props);

    const BOUND_X = 340;
    const BOUND_Y = 205;
    const MOVEMENT_SPEED = 2;

    let startRight = Math.random() > 0.5;
    let startBottom = Math.random() > 0.5;

    this.state = {
      x: startRight ? BOUND_X : 0,
      y: startBottom ? BOUND_Y : 0,
      reverseX: false,
      reverseY: false,
    };

    this.process = setInterval(() => {
      this.setState((prevState) => {
        const state = { ...prevState };
        if (state.reverseX) {
          if (state.x - MOVEMENT_SPEED < -5) {
            state.reverseX = false;
            state.x += MOVEMENT_SPEED;
          } else {
            state.x -= MOVEMENT_SPEED;
          }
        } else {
          if (state.x + MOVEMENT_SPEED > BOUND_X) {
            state.reverseX = true;
            state.x -= MOVEMENT_SPEED;
          } else {
            state.x += MOVEMENT_SPEED;
          }
        }

        if (state.reverseY) {
          if (state.y - MOVEMENT_SPEED < -20) {
            state.reverseY = false;
            state.y += MOVEMENT_SPEED;
          } else {
            state.y -= MOVEMENT_SPEED;
          }
        } else {
          if (state.y + MOVEMENT_SPEED > BOUND_Y) {
            state.reverseY = true;
            state.y -= MOVEMENT_SPEED;
          } else {
            state.y += MOVEMENT_SPEED;
          }
        }

        return state;
      });
    }, 1);
  }

  componentWillUnmount() {
    clearInterval(this.process);
  }

  render() {
    const { x, y } = this.state;

    const newStyle = {
      position: 'relative',
      left: x + 'px',
      top: y + 'px',
    };

    return (
      <Section title="Simulation in progress!" fill>
        <Box
          position="absolute"
          style={{ overflow: 'hidden', width: '100%', height: '100%' }}
        >
          <Icon style={newStyle} name="bomb" size={10} color="red" />
        </Box>
      </Section>
    );
  }
}
