/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { canRender, classes } from 'common/react';
import { Component, createRef, InfernoNode, RefObject } from 'inferno';
import { addScrollableNode, removeScrollableNode } from '../events';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

interface SectionProps extends BoxProps {
  className?: string;
  title?: string;
  buttons?: InfernoNode;
  fill?: boolean;
  fitted?: boolean;
  scrollable?: boolean;
  flexGrow?: boolean; // VOREStation Addition
  noTopPadding?: boolean; // VOREStation Addition
  stretchContents?: boolean; // VOREStation Addition
  /** @deprecated This property no longer works, please remove it. */
  level?: boolean;
  /** @deprecated Please use `scrollable` property */
  overflowY?: any;
}

export class Section extends Component<SectionProps> {
  scrollableRef: RefObject<HTMLDivElement>;
  scrollable: boolean;

  constructor(props) {
    super(props);
    this.scrollableRef = createRef();
    this.scrollable = props.scrollable;
  }

  componentDidMount() {
    if (this.scrollable) {
      addScrollableNode(this.scrollableRef.current);
    }
    if (this.props.autoFocus) {
      setTimeout(() => {
        if (this.scrollableRef.current) {
          return this.scrollableRef.current.focus();
        }
      }, 1);
    }
  }

  componentWillUnmount() {
    if (this.scrollable) {
      removeScrollableNode(this.scrollableRef.current);
    }
  }

  render() {
    const {
      className,
      title,
      buttons,
      fill,
      fitted,
      scrollable,
      flexGrow, // VOREStation Addition
      noTopPadding, // VOREStation Addition
      stretchContents, // VOREStation Addition
      children,
      ...rest
    } = this.props;
    const hasTitle = canRender(title) || canRender(buttons);
    return (
      <div
        className={classes([
          'Section',
          Byond.IS_LTE_IE8 && 'Section--iefix',
          fill && 'Section--fill',
          fitted && 'Section--fitted',
          scrollable && 'Section--scrollable',
          flexGrow && 'Section--flex', // VOREStation Addition
          className,
          computeBoxClassName(rest),
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
        <div className="Section__rest">
          {/* Vorestation Edit Start */}
          <div ref={this.scrollableRef} className={classes([
            "Section__content",
            !!stretchContents && "Section__content--stretchContents",
            !!noTopPadding && "Section__content--noTopPadding",
          ])}>
            {children}
          </div>
          {/* Vorestation Edit End */}
        </div>
      </div>
    );
  }
}
