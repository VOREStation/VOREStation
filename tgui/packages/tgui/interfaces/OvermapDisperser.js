import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section, Table, AnimatedNumber } from "../components";
import { Window } from "../layouts";
import { OvermapPanControls } from './common/Overmap';

export const OvermapDisperser = (props, context) => {
  return (
    <Window width={400} height={550} resizable>
      <Window.Content>
        <OvermapDisperserContent />
      </Window.Content>
    </Window>
  );
};

const OvermapDisperserContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    faillink,
    calibration,
    overmapdir,
    cal_accuracy,
    strength,
    range,
    next_shot,
    nopower,
    skill,
    chargeload,
  } = data;

  if (faillink) {
    return (
      <Section title="Error">
        Machine is incomplete, out of range, or misaligned!
      </Section>
    );
  }

  return (
    <Flex wrap="wrap" spacing={1}>
      <Flex.Item basis="22%">
        <Section title="Targeting" textAlign="center">
          <OvermapPanControls actToDo="choose" selected={val => val === overmapdir} />
        </Section>
      </Flex.Item>
      <Flex.Item basis="74%" grow={1}>
        <Section title="Charge">
          <LabeledList>
            {nopower && (
              <LabeledList.Item label="Error">
                At least one part of the machine is unpowered.
              </LabeledList.Item>
            ) || null}
            <LabeledList.Item label="Charge Load Type">
              {chargeload}
            </LabeledList.Item>
            <LabeledList.Item label="Cooldown">
              {next_shot === 0 && (
                <Box color="good">Ready</Box>
              ) || next_shot > 1 && (
                <Box color="average">
                  <AnimatedNumber value={next_shot} /> Seconds
                  <Box color="bad">Warning: Do not fire during cooldown.</Box>
                </Box>
              ) || null}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Flex.Item>
      <Flex.Item basis="50%" mt={1}>
        <Section title="Calibration">
          <AnimatedNumber value={cal_accuracy} />%
          <Button
            ml={1}
            icon="exchange-alt"
            onClick={() => act("skill_calibration")}>
            Pre-Calibration
          </Button>
          <Box mt={1}>
            {calibration.map((cal, i) => (
              <Box key={i}>
                Cal #{i}:
                <Button
                  ml={1}
                  icon="random"
                  onClick={() => act("calibration", { calibration: i })}>
                  {cal.toString() /* We do this to make the button size correctly at 0 */}
                </Button>
              </Box>
            ))}
          </Box>
        </Section>
      </Flex.Item>
      <Flex.Item basis="45%" grow={1} mt={1}>
        <Section title="Setup">
          <LabeledList>
            <LabeledList.Item label="Strength">
              <Button
                fluid
                icon="fist-raised"
                onClick={() => act("strength")}>
                {strength}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Radius">
              <Button
                fluid
                icon="expand-arrows-alt"
                onClick={() => act("range")}>
                {range}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Flex.Item>
      <Flex.Item grow={1} mt={1}>
        <Button
          fluid
          color="red"
          icon="bomb"
          onClick={() => act("fire")}>
          Fire ORB
        </Button>
      </Flex.Item>
    </Flex>
  );
};