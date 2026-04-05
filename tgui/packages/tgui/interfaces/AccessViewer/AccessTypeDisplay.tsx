import { Box, Tooltip } from 'tgui-core/components';
import { ACCESS_FLAGS } from './constants';

export const AccessTypeDisplay = (props: { type: number }) => {
  const { type } = props;

  const names: string[] = ACCESS_FLAGS.filter(
    (flag) => (type & flag.bit) !== 0,
  ).map((flag) => flag.label);

  const allFlags = ACCESS_FLAGS.reduce((acc, f) => acc | f.bit, 0);

  let label = '';
  let tooltip: string | undefined;
  if (names.length === 0) label = 'None';
  else if (type === allFlags) {
    label = 'All';
    tooltip = names.join(', ');
  } else if (names.length > 1) {
    label = 'Multiple';
    tooltip = names.join(', ');
  } else label = names[0];

  return (
    <Tooltip content={tooltip}>
      <Box>{label}</Box>
    </Tooltip>
  );
};
