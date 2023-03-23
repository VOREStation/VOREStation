import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Icon, Knob, LabeledControls, LabeledList, Section, Tooltip } from '../components';
import { formatSiUnit } from '../format';
import { Window } from '../layouts';

export const Canister = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    connected,
    can_relabel,
    pressure,
    releasePressure,
    defaultReleasePressure,
    minReleasePressure,
    maxReleasePressure,
    valveOpen,
    holding,
  } = data;
  return (
    <Window width={360} height={242} resizable>
      <Window.Content>
        <Section
          title="Canister"
          buttons={
            <Button icon="pencil-alt" disabled={!can_relabel} content="Relabel" onClick={() => act('relabel')} />
          }>
          <LabeledControls>
            <LabeledControls.Item minWidth="66px" label="Tank Pressure">
              <AnimatedNumber
                value={pressure}
                format={(value) => {
                  if (value < 10000) {
                    return toFixed(value) + ' kPa';
                  }
                  return formatSiUnit(value * 1000, 1, 'Pa');
                }}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Regulator">
              <Box position="relative" left="-8px">
                <Knob
                  forcedInputWidth="60px"
                  size={1.25}
                  color={!!valveOpen && 'yellow'}
                  value={releasePressure}
                  unit="kPa"
                  minValue={minReleasePressure}
                  maxValue={maxReleasePressure}
                  stepPixelSize={1}
                  onDrag={(e, value) =>
                    act('pressure', {
                      pressure: value,
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-20px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() =>
                    act('pressure', {
                      pressure: maxReleasePressure,
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-20px"
                  color="transparent"
                  icon="undo"
                  onClick={() =>
                    act('pressure', {
                      pressure: defaultReleasePressure,
                    })
                  }
                />
              </Box>
            </LabeledControls.Item>
            <LabeledControls.Item label="Valve">
              <Button
                my={0.5}
                width="50px"
                lineHeight={2}
                fontSize="11px"
                color={valveOpen ? (holding ? 'caution' : 'danger') : null}
                content={valveOpen ? 'Open' : 'Closed'}
                onClick={() => act('valve')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item mr={1} label="Port">
              <Box position="relative">
                <Icon size={1.25} name={connected ? 'plug' : 'times'} color={connected ? 'good' : 'bad'} />
                <Tooltip content={connected ? 'Connected' : 'Disconnected'} position="top" />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section
          title="Holding Tank"
          buttons={
            !!holding && (
              <Button icon="eject" color={valveOpen && 'danger'} content="Eject" onClick={() => act('eject')} />
            )
          }>
          {!!holding && (
            <LabeledList>
              <LabeledList.Item label="Label">{holding.name}</LabeledList.Item>
              <LabeledList.Item label="Pressure">
                <AnimatedNumber value={holding.pressure} /> kPa
              </LabeledList.Item>
            </LabeledList>
          )}
          {!holding && <Box color="average">No Holding Tank</Box>}
        </Section>
      </Window.Content>
    </Window>
  );
};
