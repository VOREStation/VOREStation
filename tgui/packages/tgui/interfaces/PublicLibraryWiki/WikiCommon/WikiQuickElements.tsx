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
      {temperature + 'K | ' + (temperature - zeroC) + '°C'}
    </Box>
  );
};

export const NotAvilableBox = (props) => {
  return <Box textColor="label">---</Box>;
};
