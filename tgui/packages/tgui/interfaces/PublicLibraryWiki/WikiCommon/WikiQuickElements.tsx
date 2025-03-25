import { Box } from 'tgui-core/components';

import { zeroC } from '../constants';

export const YesBox = (props) => {
  return <Box textColor="green">Yes</Box>;
};

export const NoBox = (props) => {
  return <Box textColor="red">No</Box>;
};

export const TemperatureBox = (props: {
  temperature: number;
  color: string;
}) => {
  const { temperature, color } = props;

  return (
    <Box color={color}>
      {temperature.toFixed(2) +
        'K | ' +
        (temperature - zeroC).toFixed(2) +
        '°C'}
    </Box>
  );
};

export const NotAvilableBox = (props) => {
  return <Box textColor="label">---</Box>;
};

export const MinMaxBox = (props: {
  min: number;
  max: number;
  minColor?: string;
  maxColor?: string;
  unit?: string;
}) => {
  const { min, max, minColor, maxColor, unit } = props;

  return (
    <>
      <Box color={minColor} inline>
        {min.toFixed(2)}
        {unit}
      </Box>
      {' - '}
      <Box color={maxColor} inline>
        {max.toFixed(2)}
        {unit}
      </Box>
    </>
  );
};

export const MinMaxBoxTemperature = (props: {
  min: number;
  max: number;
  minColor?: string;
  maxColor?: string;
}) => {
  const { min, max, minColor, maxColor } = props;

  return (
    <>
      <MinMaxBox
        min={min}
        max={max}
        minColor={minColor}
        maxColor={maxColor}
        unit="K"
      />
      {' | '}
      <MinMaxBox
        min={min - zeroC}
        max={max - zeroC}
        minColor={minColor}
        maxColor={maxColor}
        unit="°C"
      />
    </>
  );
};

export const ProbabilityBox = (props: { chance: number }) => {
  const { chance } = props;

  if (chance <= 10) {
    return <Box color="red">{chance}%</Box>;
  }
  if (chance < 30) {
    return <Box color="orange">{chance}%</Box>;
  }
  if (chance < 50) {
    return <Box color="yellow">{chance}%</Box>;
  }
  if (chance < 70) {
    return <Box color="olive">{chance}%</Box>;
  }
  return <Box color="green">{chance}%</Box>;
};
