/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes, pureComponentHooks } from 'common/react';
import { InfernoNode } from 'inferno';
import { Box, unit } from './Box';
import { Divider } from './Divider';

type LabeledListProps = {
  children?: any;
};

export const LabeledList = (props: LabeledListProps) => {
  const { children } = props;
  return (
    <table className="LabeledList">
      {children}
    </table>
  );
};

LabeledList.defaultHooks = pureComponentHooks;

type LabeledListItemProps = {
  className?: string | BooleanLike;
  label?: string | BooleanLike;
  labelColor?: string | BooleanLike;
  color?: string | BooleanLike;
  textAlign?: string | BooleanLike;
  verticalAlign?: string | BooleanLike; // VOREStation Addition
  buttons?: InfernoNode,
  /** @deprecated */
  content?: any,
  children?: InfernoNode;
};

const LabeledListItem = (props: LabeledListItemProps) => {
  const {
    className,
    label,
    labelColor = 'label',
    color,
    textAlign,
    verticalAlign, // VOREStation Addition
    buttons,
    content,
    children,
    ...rest // VOREStation Addition
  } = props;
  return (
    <tr
      className={classes([
        'LabeledList__row',
        className,
      ])}>
      <Box
        as="td"
        verticalAlign={verticalAlign} // VOREStation Addition
        color={labelColor}
        className={classes([
          'LabeledList__cell',
          'LabeledList__label',
        ])}>
        {label ? label + ':' : null}
      </Box>
      <Box
        as="td"
        color={color}
        textAlign={textAlign}
        verticalAlign={verticalAlign} // VOREStation Addition
        className={classes([
          'LabeledList__cell',
          'LabeledList__content',
        ])}
        colSpan={buttons ? undefined : 2}
        {...rest} /* VOREStation Addition*/>
        {content}
        {children}
      </Box>
      {buttons && (
        <td className="LabeledList__cell LabeledList__buttons">
          {buttons}
        </td>
      )}
    </tr>
  );
};

LabeledListItem.defaultHooks = pureComponentHooks;

type LabeledListDividerProps = {
  size?: number;
};

const LabeledListDivider = (props: LabeledListDividerProps) => {
  const padding = props.size
    ? unit(Math.max(0, props.size - 1))
    : 0;
  return (
    <tr className="LabeledList__row">
      <td
        colSpan={3}
        style={{
          'padding-top': padding,
          'padding-bottom': padding,
        }}>
        <Divider />
      </td>
    </tr>
  );
};

LabeledListDivider.defaultHooks = pureComponentHooks;

LabeledList.Item = LabeledListItem;
LabeledList.Divider = LabeledListDivider;
