/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { computeBoxClassName, computeBoxProps } from './Box';
import { Dimmer } from './Dimmer';

export const Modal = props => {
  const {
    className,
    children,
    onEnter, // VOREStation Addition
    ...rest
  } = props;
  // VOREStation Addition Start
  let handleKeyDown;
  if (onEnter) {
    handleKeyDown = e => {
      let key = e.which || e.keyCode;
      if (key === 13) {
        onEnter(e);
      }
    };
  }
  // VOREStation Addition End
  return (
    <Dimmer
      onKeyDown={handleKeyDown /* VOREStation Edit */}>
      <div
        className={classes([
          'Modal',
          className,
          computeBoxClassName(rest),
        ])}
        {...computeBoxProps(rest)}>
        {children}
      </div>
    </Dimmer>
  );
};
