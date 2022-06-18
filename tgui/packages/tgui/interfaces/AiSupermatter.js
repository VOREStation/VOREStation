import { useBackend } from "../backend";
import { Box, Icon, LabeledList, ProgressBar, Section } from "../components";
import { Window } from "../layouts";
import { FullscreenNotice } from './common/FullscreenNotice';

export const AiSupermatter = (props, context) => {
  const { data } = useBackend(context);

  const {
    integrity_percentage,
    ambient_temp,
    ambient_pressure,
    detonating,
  } = data;

  let body = <AiSupermatterContent />;
  if (detonating) {
    body = <AiSupermatterDetonation />;
  }

  return (
    <Window
      width={500}
      height={300}>
      <Window.Content>
        {body}
      </Window.Content>
    </Window>
  );
};

const AiSupermatterDetonation = (props, context) => (
  <FullscreenNotice title="DETONATION IMMINENT">
    <Box fontSize="1.5rem" bold color="bad">
      <Icon
        color="bad"
        name="exclamation-triangle"
        verticalAlign="middle"
        size={3}
        mr="1rem"
      />
      <Box color="bad">CRYSTAL DELAMINATING</Box>
      <Box color="bad">Evacuate area immediately</Box>
    </Box>
  </FullscreenNotice>
);

const AiSupermatterContent = (props, context) => {
  const { data } = useBackend(context);

  const {
    integrity_percentage,
    ambient_temp,
    ambient_pressure,
  } = data;

  return (
    <Section title="Status">
      <LabeledList>
        <LabeledList.Item label="Crystal Integrity">
          <ProgressBar
            value={integrity_percentage}
            maxValue={100}
            ranges={{
              good: [90, Infinity],
              average: [25, 90],
              bad: [-Infinity, 25],
            }} />
        </LabeledList.Item>
        <LabeledList.Item label="Environment Temperature">
          <ProgressBar
            value={ambient_temp}
            maxValue={10000}
            ranges={{
              bad: [5000, Infinity],
              average: [4000, 5000],
              good: [-Infinity, 4000],
            }}>
            {ambient_temp} K
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Environment Pressure">
          {ambient_pressure} kPa
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
