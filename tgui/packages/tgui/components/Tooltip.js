import { classes } from 'common/react';

export const Tooltip = props => {
  const {
    content,
    position = 'bottom',
    scale,
  } = props;
  // Empirically calculated length of the string,
  // at which tooltip text starts to overflow.
  const long = typeof content === 'string' && content.length > 35;
  return (
    <div
      className={classes([
        'Tooltip',
        long && 'Tooltip--long',
        position && 'Tooltip--' + position,
        scale && 'Tooltip--scale--' + Math.floor(scale),
      ])}
      data-tooltip={content} />
  );
};
