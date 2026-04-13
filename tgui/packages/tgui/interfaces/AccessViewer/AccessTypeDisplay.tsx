import { Box, Tooltip } from 'tgui-core/components';
import { ACCESS_FLAGS } from './constants';

export const AccessTypeDisplay = (props: { type: number }) => {
  const { type } = props;

  const names = ACCESS_FLAGS.filter((flag) => type & flag.bit).map(
    (f) => f.label,
  );
  const allFlags = ACCESS_FLAGS.reduce((acc, f) => acc | f.bit, 0);

  const label =
    names.length === 0
      ? 'None'
      : type === allFlags
        ? 'All'
        : names.length > 1
          ? 'Multiple'
          : names[0];

  const tooltip =
    names.length > 1 || type === allFlags ? names.join(', ') : undefined;

  return (
    <Tooltip content={tooltip}>
      <Box>{label}</Box>
    </Tooltip>
  );
};
