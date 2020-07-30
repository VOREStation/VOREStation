<<<<<<< HEAD
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes, isFalsy, pureComponentHooks } from 'common/react';
import { computeBoxClassName, computeBoxProps } from './Box';
=======
import { classes, isFalsy, pureComponentHooks } from 'common/react';
import { Box } from './Box';
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

export const Section = props => {
  const {
    className,
    title,
    level = 1,
    buttons,
<<<<<<< HEAD
    fill,
    stretchContents,
    noTopPadding,
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
        flexGrow && 'Section--flex',
        className,
        ...computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
=======
    content,
    children,
    ...rest
  } = props;
  const hasTitle = !isFalsy(title) || !isFalsy(buttons);
  const hasContent = !isFalsy(content) || !isFalsy(children);
  return (
    <Box
      className={classes([
        'Section',
        'Section--level--' + level,
        className,
      ])}
      {...rest}>
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
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
          {children}
        </div>
      )}
    </div>
=======
        <div className="Section__content">
          {content}
          {children}
        </div>
      )}
    </Box>
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  );
};

Section.defaultHooks = pureComponentHooks;
