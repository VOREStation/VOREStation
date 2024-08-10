/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { KEY } from 'common/keys';
import { classes } from 'common/react';
import { KeyboardEvent, KeyboardEventHandler } from 'react';

import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';
import { Dimmer } from './Dimmer';

export function Modal(
  props: BoxProps & {
    onEnter?: ((e: KeyboardEvent<HTMLInputElement>) => void) | undefined;
  },
) {
  const { className, children, onEnter, ...rest } = props;
  // VOREStation Addition start
  let handleKeyDown: KeyboardEventHandler<HTMLDivElement> | undefined;
  if (onEnter) {
    handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
      if (e.key === KEY.Enter) {
        onEnter(e);
      }
    };
  }
  // VOREStation Addition end

  return (
    <Dimmer onKeyDown={handleKeyDown} /* VOREStation edit */>
      <div
        className={classes(['Modal', className, computeBoxClassName(rest)])}
        {...computeBoxProps(rest)}
      >
        {children}
      </div>
    </Dimmer>
  );
}
