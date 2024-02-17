import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const Medbot = (props) => {
  const { act, data } = useBackend();

  const {
    on,
    open,
    beaker,
    beaker_total,
    beaker_max,
    locked,
    heal_threshold,
    heal_threshold_max,
    injection_amount_min,
    injection_amount,
    injection_amount_max,
    use_beaker,
    declare_treatment,
    vocal,
  } = data;

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <Section
          title="Automatic Medical Unit v2.0"
          buttons={
            <Button icon="power-off" selected={on} onClick={() => act('power')}>
              {on ? 'On' : 'Off'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="Maintenance Panel"
              color={open ? 'bad' : 'good'}
            >
              {open ? 'Open' : 'Closed'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Beaker"
              buttons={
                <Button
                  disabled={!beaker}
                  icon="eject"
                  onClick={() => act('eject')}
                >
                  Eject
                </Button>
              }
            >
              {(beaker && (
                <ProgressBar value={beaker_total} maxValue={beaker_max}>
                  {beaker_total} / {beaker_max}
                </ProgressBar>
              )) || <Box color="average">No beaker loaded.</Box>}
            </LabeledList.Item>
            <LabeledList.Item
              label="Behavior Controls"
              color={locked ? 'good' : 'bad'}
            >
              {locked ? 'Locked' : 'Unlocked'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(!locked && (
          <Section title="Behavioral Controls">
            <LabeledList>
              <LabeledList.Item label="Healing Threshold">
                <NumberInput
                  fluid
                  minValue={0}
                  maxValue={heal_threshold_max}
                  value={heal_threshold}
                  onDrag={(e, val) => act('adj_threshold', { val: val })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Injection Amount">
                <NumberInput
                  fluid
                  minValue={injection_amount_min}
                  maxValue={injection_amount_max}
                  value={injection_amount}
                  onDrag={(e, val) => act('adj_inject', { val: val })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Reagent Source">
                <Button
                  fluid
                  icon={use_beaker ? 'toggle-on' : 'toggle-off'}
                  selected={use_beaker}
                  onClick={() => act('use_beaker')}
                >
                  {use_beaker
                    ? 'Loaded Beaker (When available)'
                    : 'Internal Synthesizer'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Treatment Report">
                <Button
                  fluid
                  icon={declare_treatment ? 'toggle-on' : 'toggle-off'}
                  selected={declare_treatment}
                  onClick={() => act('declaretreatment')}
                >
                  {declare_treatment ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Speaker">
                <Button
                  fluid
                  icon={vocal ? 'toggle-on' : 'toggle-off'}
                  selected={vocal}
                  onClick={() => act('togglevoice')}
                >
                  {vocal ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )) ||
          null}
      </Window.Content>
    </Window>
  );
};
