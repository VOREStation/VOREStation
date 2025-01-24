import { isEscape, KEY } from 'common/keys';
import { classes } from 'common/react';
import { KeyboardEvent } from 'react';

import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';
import { Dimmer } from './Dimmer';

/**
 * ## Modal
 * A modal window. Uses a [Dimmer](https://github.com/tgstation/tgui-core/tree/main/lib/components/Dimmer.tsx)
 * under the hood, and dynamically adjusts its own size to fit the content you're trying to display.
 *
 * Must be a direct child of a layout component (e.g. `Window`).
 */
export function Modal(
  props: BoxProps & {
    /** Fires once the enter key is pressed */
    onEnter?: (e: KeyboardEvent<HTMLInputElement>) => void;
    /** Fires once the escape key is pressed */
    onEscape?: (e: KeyboardEvent<HTMLInputElement>) => void;
  },
) {
  const { className, children, onEnter, onEscape, ...rest } = props;

  function handleKeyDown(e: KeyboardEvent<HTMLInputElement>) {
    if (e.key === KEY.Enter) {
      onEnter?.(e);
    }
    if (isEscape(e.key)) {
      onEscape?.(e);
    }
  }

  return (
    <Dimmer onKeyDown={handleKeyDown}>
      <div
        className={classes(['Modal', className, computeBoxClassName(rest)])}
        {...computeBoxProps(rest)}
      >
        {children}
      </div>
    </Dimmer>
  );
}
