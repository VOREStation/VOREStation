import { Box, LabeledList } from 'tgui-core/components';

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
  min: number | null;
  max: number | null;
  minColor?: string;
  maxColor?: string;
  unit?: string;
}) => {
  const { min, max, minColor, maxColor, unit } = props;

  const realMin = typeof min === 'number' ? min.toFixed(2) : -Infinity;
  const realMax = typeof max === 'number' ? max.toFixed(2) : Infinity;

  return (
    <>
      <Box color={minColor} inline>
        {realMin}
        {unit}
      </Box>
      {' - '}
      <Box color={maxColor} inline>
        {realMax}
        {unit}
      </Box>
    </>
  );
};

export const MinMaxBoxTemperature = (props: {
  min: number | null;
  max: number | null;
  minColor?: string;
  maxColor?: string;
}) => {
  const { min, max, minColor, maxColor } = props;

  const realMin = min ? min : 0;
  const realMax = max ? max : Infinity;

  return (
    <>
      <MinMaxBox
        min={realMin}
        max={realMax}
        minColor={minColor}
        maxColor={maxColor}
        unit="K"
      />
      {' | '}
      <MinMaxBox
        min={realMin - zeroC}
        max={realMax}
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

export const TierdBox = (props: { level: number; label: string }) => {
  const { level, label } = props;

  if (level >= 1) {
    return <Box color="yellow">WARNING, {label}</Box>;
  }
  if (level >= 2) {
    return <Box color="red">DANGE, highly {label}</Box>;
  }
  return <NotAvilableBox />;
};

export const SupplyEntry = (props: {
  supply_points?: number;
  market_price?: number;
  stack_size?: number;
}) => {
  const { supply_points, market_price, stack_size } = props;

  return (
    <>
      <LabeledList.Item label="Supply Points">
        {supply_points ? (
          supply_points +
          ' per sheet, ' +
          (!!stack_size &&
            supply_points * stack_size + ' per stack of ' + stack_size)
        ) : (
          <NotAvilableBox />
        )}
      </LabeledList.Item>
      <LabeledList.Item label="Market Price">
        {market_price ? (
          market_price +
          ' thaler' +
          (market_price > 1 ? 's' : '') +
          ' per sheet  |  ' +
          (!!stack_size &&
            market_price * stack_size +
              ' thaler' +
              (market_price * stack_size > 1 ? 's' : '') +
              ' per stack of ' +
              stack_size)
        ) : (
          <NotAvilableBox />
        )}
      </LabeledList.Item>
    </>
  );
};
