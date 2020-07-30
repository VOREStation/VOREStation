<<<<<<< HEAD
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes, pureComponentHooks } from 'common/react';
=======
import { classes, pureComponentHooks } from 'common/react';
import { IS_IE8 } from '../byond';
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
import { Box, unit } from './Box';

export const computeFlexProps = props => {
  const {
    className,
    direction,
    wrap,
    align,
<<<<<<< HEAD
    alignContent,
    justify,
    inline,
    spacing = 0,
    spacingPrecise = 0,
=======
    justify,
    inline,
    spacing = 0,
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    ...rest
  } = props;
  return {
    className: classes([
      'Flex',
<<<<<<< HEAD
      Byond.IS_LTE_IE10 && (
        direction === 'column'
          ? 'Flex--iefix--column'
          : 'Flex--iefix'
      ),
      inline && 'Flex--inline',
      spacing > 0 && 'Flex--spacing--' + spacing,
      spacingPrecise > 0 && 'Flex--spacingPrecise--' + spacingPrecise,
=======
      IS_IE8 && (
        direction === 'column'
          ? 'Flex--ie8--column'
          : 'Flex--ie8'
      ),
      inline && 'Flex--inline',
      spacing > 0 && 'Flex--spacing--' + spacing,
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      className,
    ]),
    style: {
      ...rest.style,
      'flex-direction': direction,
      'flex-wrap': wrap,
      'align-items': align,
<<<<<<< HEAD
      'align-content': alignContent,
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      'justify-content': justify,
    },
    ...rest,
  };
};

export const Flex = props => (
  <Box {...computeFlexProps(props)} />
);

Flex.defaultHooks = pureComponentHooks;

export const computeFlexItemProps = props => {
  const {
    className,
    grow,
    order,
    shrink,
    // IE11: Always set basis to specified width, which fixes certain
    // bugs when rendering tables inside the flex.
    basis = props.width,
    align,
    ...rest
  } = props;
  return {
    className: classes([
      'Flex__item',
<<<<<<< HEAD
      Byond.IS_LTE_IE10 && 'Flex__item--iefix',
=======
      IS_IE8 && 'Flex__item--ie8',
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      className,
    ]),
    style: {
      ...rest.style,
      'flex-grow': grow,
      'flex-shrink': shrink,
      'flex-basis': unit(basis),
      'order': order,
      'align-self': align,
    },
    ...rest,
  };
};

export const FlexItem = props => (
  <Box {...computeFlexItemProps(props)} />
);

FlexItem.defaultHooks = pureComponentHooks;

Flex.Item = FlexItem;
