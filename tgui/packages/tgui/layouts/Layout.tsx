/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { useEffect, useRef } from 'react';

import { computeBoxClassName, computeBoxProps } from '../components/Box';
import { addScrollableNode, removeScrollableNode } from '../events';

export const Layout = (props) => {
  const { className, theme = 'nanotrasen', children, ...rest } = props;
  return (
    <div className={'theme-' + theme}>
      <div
        className={classes(['Layout', className, computeBoxClassName(rest)])}
        {...computeBoxProps(rest)}
      >
        {children}
      </div>
    </div>
  );
};

const LayoutContent = (props) => {
  const {
    className,
    scrollable,
    children,
    scrollableHorizontal,
    container_id,
    ...rest
  } = props;
  const currentRef = useRef(null);

  useEffect(() => {
    if (!currentRef?.current) return;
    if (!scrollable) return;
    addScrollableNode(currentRef.current);

    return () => {
      if (!currentRef?.current) return;
      removeScrollableNode(currentRef.current);
    };
  }, []);

  return (
    <div
      ref={currentRef}
      id={container_id || ''}
      className={classes([
        'Layout__content',
        scrollable && 'Layout__content--scrollable',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}
    >
      {children}
    </div>
  );
};

Layout.Content = LayoutContent;
