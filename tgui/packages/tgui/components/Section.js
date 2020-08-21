/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes, isFalsy, pureComponentHooks } from 'common/react';
import { computeBoxClassName, computeBoxProps } from './Box';

export const Section = props => {
  const {
    className,
    title,
    level = 1,
    buttons,
    fill,
<<<<<<< HEAD
    stretchContents,
    noTopPadding,
=======
>>>>>>> af81780... Merge pull request #7397 from ShadowLarkens/tgui4.0-and-camera-console
    children,
    scrollable,
    flexGrow,
    ...rest
  } = props;
  const hasTitle = !isFalsy(title) || !isFalsy(buttons);
  const hasContent = !isFalsy(children);
  return (
    <div
      className={classes([
        'Section',
        'Section--level--' + level,
        fill && 'Section--fill',
<<<<<<< HEAD
        scrollable && 'Section--scrollable',
        flexGrow && 'Section--flex',
=======
>>>>>>> af81780... Merge pull request #7397 from ShadowLarkens/tgui4.0-and-camera-console
        className,
        ...computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {hasTitle && (
        <div className="Section__title">
          <span className="Section__titleText">
            {title}
          </span>
          <div className="Section__buttons">
            {buttons}
          </div>
        </div>
      )}
      {hasContent && (
<<<<<<< HEAD
        <div className={classes([
          "Section__content",
          !!stretchContents && "Section__content--stretchContents",
          !!noTopPadding && "Section__content--noTopPadding",
        ])}>
=======
        <div className="Section__content">
>>>>>>> af81780... Merge pull request #7397 from ShadowLarkens/tgui4.0-and-camera-console
          {children}
        </div>
      )}
    </div>
  );
};

Section.defaultHooks = pureComponentHooks;
