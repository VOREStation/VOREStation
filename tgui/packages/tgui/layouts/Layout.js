/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { computeBoxClassName, computeBoxProps } from '../components/Box';
import { addScrollableNode, removeScrollableNode } from '../events';

/**
 * Brings Layout__content DOM element back to focus.
 *
 * Commonly used to keep the content scrollable in IE.
 */
export const refocusLayout = () => {
  // IE8: Focus method is seemingly fucked.
  if (Byond.IS_LTE_IE8) {
    return;
  }
  const element = document.getElementById('Layout__content');
  if (element) {
    element.focus();
  }
};

export const Layout = (props) => {
  const { className, theme = 'nanotrasen', children, ...rest } = props;
  return (
    <div className={'theme-' + theme}>
      <div className={classes(['Layout', className, computeBoxClassName(rest)])} {...computeBoxProps(rest)}>
        {children}
      </div>
    </div>
  );
};

const LayoutContent = (props) => {
  const { className, scrollable, children, ...rest } = props;
  return (
    <div
      className={classes([
        'Layout__content',
        scrollable && 'Layout__content--scrollable',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {children}
    </div>
  );
};

LayoutContent.defaultHooks = {
  onComponentDidMount: (node) => addScrollableNode(node),
  onComponentWillUnmount: (node) => removeScrollableNode(node),
};

Layout.Content = LayoutContent;
