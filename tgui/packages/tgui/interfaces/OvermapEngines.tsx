import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  Collapsible,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  global_state: BooleanLike;
  global_limit: number;
  engines_info: {
    eng_type: string;
    eng_on: BooleanLike;
    eng_thrust: number;
    eng_thrust_limiter: number;
    eng_status: string[];
    eng_reference: string;
  }[];
  total_thrust: number;
};

export const OvermapEngines = (props) => {
  return (
    <Window width={390} height={530}>
      <Window.Content>
        <OvermapEnginesContent />
      </Window.Content>
    </Window>
  );
};

export const OvermapEnginesContent = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    global_state, // This indicates all engines being powered up or not
    global_limit, // Global Thrust limit
    engines_info, // Array of engines
    total_thrust, // Total thrust of all engines together
  } = data;
  return (
    <>
      <Section title="Status">
        <LabeledList>
          <LabeledList.Item label="Engines">
            <Button
              icon="power-off"
              selected={global_state}
              onClick={() => act('global_toggle')}
            >
              {global_state ? 'Shut All Engines Down' : 'Start All Engines'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Volume Limit">
            <Button
              onClick={() => act('global_limit', { global_limit: -0.1 })}
              icon="minus"
            />
            <Button onClick={() => act('set_global_limit')}>
              {global_limit}%
            </Button>
            <Button
              onClick={() => act('global_limit', { global_limit: 0.1 })}
              icon="plus"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Total Thrust">
            <AnimatedNumber value={total_thrust} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Engines" height="340px" style={{ overflowY: 'auto' }}>
        {engines_info.map((engine, i) => (
          <Stack mt={i !== 0 && -1} key={i}>
            <Stack.Item basis="80%">
              <Collapsible
                title={
                  <Box inline>
                    Engine #{i + 1} | Thrust:{' '}
                    <AnimatedNumber value={engine.eng_thrust} /> | Limit:{' '}
                    <AnimatedNumber
                      value={engine.eng_thrust_limiter}
                      format={(val) => val + '%'}
                    />
                  </Box>
                  // "Engine " + (i + 1)
                  //   + " | Thrust: " + engine.eng_thrust
                  //   + " | Limit: " + engine.eng_thrust_limiter + "%"
                }
              >
                <Section width="127%">
                  <LabeledList>
                    <LabeledList.Item label="Type">
                      {engine.eng_type}
                    </LabeledList.Item>
                    <LabeledList.Item label="Status">
                      <Box
                        color={
                          engine.eng_on
                            ? engine.eng_on === 1
                              ? 'good'
                              : 'average'
                            : 'bad'
                        }
                      >
                        {engine.eng_on
                          ? engine.eng_on === 1
                            ? 'Online'
                            : 'Booting'
                          : 'Offline'}
                      </Box>
                      {engine.eng_status.map((status, index) => {
                        if (Array.isArray(status)) {
                          return (
                            <Box key={index} color={status[1]}>
                              {status[0]}
                            </Box>
                          );
                        } else {
                          return <Box key={index}>{status}</Box>;
                        }
                      })}
                    </LabeledList.Item>
                    <LabeledList.Item label="Current Thrust">
                      {engine.eng_thrust}
                    </LabeledList.Item>
                    <LabeledList.Item label="Volume Limit">
                      <Button
                        onClick={() =>
                          act('limit', {
                            limit: -0.1,
                            engine: engine.eng_reference,
                          })
                        }
                        icon="minus"
                      />
                      <Button
                        onClick={() =>
                          act('set_limit', { engine: engine.eng_reference })
                        }
                      >
                        {engine.eng_thrust_limiter}%
                      </Button>
                      <Button
                        onClick={() =>
                          act('limit', {
                            limit: 0.1,
                            engine: engine.eng_reference,
                          })
                        }
                        icon="plus"
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Collapsible>
            </Stack.Item>
            <Stack.Item basis="20%">
              <Button
                fluid
                iconSpin={engine.eng_on === -1}
                color={engine.eng_on === -1 ? 'purple' : undefined}
                selected={engine.eng_on === 1}
                icon="power-off"
                onClick={() =>
                  act('toggle_engine', { engine: engine.eng_reference })
                }
              >
                {engine.eng_on
                  ? engine.eng_on === 1
                    ? 'Shutoff'
                    : 'Booting'
                  : 'Startup'}
              </Button>
            </Stack.Item>
          </Stack>
        ))}
      </Section>
    </>
  );
};
