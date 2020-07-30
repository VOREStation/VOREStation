<<<<<<< HEAD
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { computeBoxProps, computeBoxClassName } from '../components/Box';
=======
import { classes } from 'common/react';
import { IS_IE8 } from '../byond';
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

/**
 * Brings Layout__content DOM element back to focus.
 *
 * Commonly used to keep the content scrollable in IE.
 */
export const refocusLayout = () => {
  // IE8: Focus method is seemingly fucked.
<<<<<<< HEAD
  if (Byond.IS_LTE_IE8) {
=======
  if (IS_IE8) {
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    return;
  }
  const element = document.getElementById('Layout__content');
  if (element) {
    element.focus();
  }
};

export const Layout = props => {
  const {
    className,
    theme = 'nanotrasen',
    children,
  } = props;
  return (
    <div className={'theme-' + theme}>
      <div
        className={classes([
          'Layout',
          className,
        ])}>
        {children}
      </div>
    </div>
  );
};

const LayoutContent = props => {
  const {
    className,
    scrollable,
    children,
<<<<<<< HEAD
    ...rest
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  } = props;
  return (
    <div
      id="Layout__content"
      className={classes([
        'Layout__content',
        scrollable && 'Layout__content--scrollable',
        className,
<<<<<<< HEAD
        ...computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
=======
      ])}>
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      {children}
    </div>
  );
};

Layout.Content = LayoutContent;
