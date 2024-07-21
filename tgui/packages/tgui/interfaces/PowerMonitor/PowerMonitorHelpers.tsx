import { toFixed } from 'common/math';

import { Box, ColorBox, Icon, Tooltip } from '../../components';

export const AreaCharge = (props: { charging: number; charge: number }) => {
  const { charging, charge } = props;
  return (
    <>
      <Icon
        width="18px"
        textAlign="center"
        name={
          (charging === 0 &&
            (charge > 50 ? 'battery-half' : 'battery-quarter')) ||
          (charging === 1 && 'bolt') ||
          (charging === 2 && 'battery-full') ||
          ''
        }
        color={
          (charging === 0 && (charge > 50 ? 'yellow' : 'red')) ||
          (charging === 1 && 'yellow') ||
          (charging === 2 && 'green')
        }
      />
      <Box inline width="36px" textAlign="right">
        {toFixed(charge) + '%'}
      </Box>
    </>
  );
};

export const AreaStatusColorBox = (props: { status: number }) => {
  const { status } = props;
  const power: boolean = Boolean(status & 2);
  const mode: boolean = Boolean(status & 1);
  const tooltipText: string =
    (power ? 'On' : 'Off') + ` [${mode ? 'auto' : 'manual'}]`;
  return (
    <Tooltip content={tooltipText}>
      <ColorBox
        color={power ? 'good' : 'bad'}
        content={mode ? undefined : 'M'}
      />
    </Tooltip>
  );
};
