import { Box, Dimmer, Icon } from 'tgui-core/components';

export const DNAModifierIrradiating = (props: { duration: number }) => {
  return (
    <Dimmer textAlign="center">
      <Icon name="spinner" size={5} spin />
      <br />
      <Box color="average">
        <h1>
          <Icon name="radiation" />
          &nbsp;Irradiating occupant&nbsp;
          <Icon name="radiation" />
        </h1>
      </Box>
      <Box color="label">
        <h3>
          For {props.duration} second{props.duration === 1 ? '' : 's'}
        </h3>
      </Box>
    </Dimmer>
  );
};
