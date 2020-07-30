<<<<<<< HEAD
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { decodeHtmlEntities, toTitleCase } from 'common/string';
import { Component, Fragment } from 'inferno';
import { backendSuspendStart, useBackend } from '../backend';
import { Icon } from '../components';
import { UI_DISABLED, UI_INTERACTIVE, UI_UPDATE } from '../constants';
import { toggleKitchenSink, useDebug } from '../debug';
import { dragStartHandler, recallWindowGeometry, resizeStartHandler, setWindowKey } from '../drag';
import { createLogger } from '../logging';
import { useDispatch } from '../store';
=======
import { classes } from 'common/react';
import { decodeHtmlEntities, toTitleCase } from 'common/string';
import { Component, Fragment } from 'inferno';
import { useBackend } from '../backend';
import { IS_IE8, runCommand, winset } from '../byond';
import { Box, Icon } from '../components';
import { UI_DISABLED, UI_INTERACTIVE, UI_UPDATE } from '../constants';
import { dragStartHandler, resizeStartHandler } from '../drag';
import { releaseHeldKeys } from '../hotkeys';
import { createLogger } from '../logging';
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
import { Layout, refocusLayout } from './Layout';

const logger = createLogger('Window');

<<<<<<< HEAD
const DEFAULT_SIZE = [400, 600];

export class Window extends Component {
  componentDidMount() {
    const { config, suspended } = useBackend(this.context);
    if (suspended) {
      return;
    }
    logger.log('mounting');
    const options = {
      size: DEFAULT_SIZE,
      ...config.window,
    };
    if (this.props.width && this.props.height) {
      options.size = [this.props.width, this.props.height];
    }
    setWindowKey(config.window.key);
    recallWindowGeometry(config.window.key, options);
=======
export class Window extends Component {
  componentDidMount() {
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    refocusLayout();
  }

  render() {
    const {
      resizable,
      theme,
<<<<<<< HEAD
      title,
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      children,
    } = this.props;
    const {
      config,
<<<<<<< HEAD
      suspended,
    } = useBackend(this.context);
    const { debugLayout } = useDebug(this.context);
    const dispatch = useDispatch(this.context);
    const fancy = config.window?.fancy;
    // Determine when to show dimmer
    const showDimmer = config.user.observer
=======
      debugLayout,
    } = useBackend(this.context);
    // Determine when to show dimmer
    const showDimmer = config.observer
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      ? config.status < UI_DISABLED
      : config.status < UI_INTERACTIVE;
    return (
      <Layout
        className="Window"
        theme={theme}>
        <TitleBar
          className="Window__titleBar"
<<<<<<< HEAD
          title={!suspended && (title || decodeHtmlEntities(config.title))}
          status={config.status}
          fancy={fancy}
          onDragStart={dragStartHandler}
          onClose={() => {
            logger.log('pressed close');
            dispatch(backendSuspendStart());
=======
          title={decodeHtmlEntities(config.title)}
          status={config.status}
          fancy={config.fancy}
          onDragStart={dragStartHandler}
          onClose={() => {
            logger.log('pressed close');
            releaseHeldKeys();
            winset(config.window, 'is-visible', false);
            runCommand(`uiclose ${config.ref}`);
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
          }} />
        <div
          className={classes([
            'Window__rest',
            debugLayout && 'debug-layout',
          ])}>
<<<<<<< HEAD
          {!suspended && children}
=======
          {children}
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
          {showDimmer && (
            <div className="Window__dimmer" />
          )}
        </div>
<<<<<<< HEAD
        {fancy && resizable && (
=======
        {config.fancy && resizable && (
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
          <Fragment>
            <div className="Window__resizeHandle__e"
              onMousedown={resizeStartHandler(1, 0)} />
            <div className="Window__resizeHandle__s"
              onMousedown={resizeStartHandler(0, 1)} />
            <div className="Window__resizeHandle__se"
              onMousedown={resizeStartHandler(1, 1)} />
          </Fragment>
        )}
      </Layout>
    );
  }
}

const WindowContent = props => {
<<<<<<< HEAD
  const {
    className,
    fitted,
    scrollable,
    children,
    ...rest
  } = props;
=======
  const { scrollable, children } = props;
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  // A bit lazy to actually write styles for it,
  // so we simply include a Box with margins.
  return (
    <Layout.Content
<<<<<<< HEAD
      scrollable={scrollable}
      className={classes([
        'Window__content',
        className,
      ])}
      {...rest}>
      {fitted && children || (
        <div className="Window__contentPadding">
          {children}
        </div>
      )}
=======
      scrollable={scrollable}>
      <Box m={1}>
        {children}
      </Box>
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    </Layout.Content>
  );
};

Window.Content = WindowContent;

const statusToColor = status => {
  switch (status) {
    case UI_INTERACTIVE:
      return 'good';
    case UI_UPDATE:
      return 'average';
    case UI_DISABLED:
    default:
      return 'bad';
  }
};

<<<<<<< HEAD
const TitleBar = (props, context) => {
=======
const TitleBar = props => {
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  const {
    className,
    title,
    status,
    fancy,
    onDragStart,
    onClose,
  } = props;
<<<<<<< HEAD
  const dispatch = useDispatch(context);
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  return (
    <div
      className={classes([
        'TitleBar',
        className,
      ])}>
      <Icon
        className="TitleBar__statusIcon"
        color={statusToColor(status)}
        name="eye" />
      <div className="TitleBar__title">
<<<<<<< HEAD
        {typeof title === 'string'
          && title === title.toLowerCase()
          && toTitleCase(title)
          || title}
=======
        {title === title.toLowerCase()
          ? toTitleCase(title)
          : title}
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      </div>
      <div
        className="TitleBar__dragZone"
        onMousedown={e => fancy && onDragStart(e)} />
<<<<<<< HEAD
      {process.env.NODE_ENV !== 'production' && (
        <div
          className="TitleBar__devBuildIndicator"
          onClick={() => dispatch(toggleKitchenSink())}>
          <Icon name="bug" />
        </div>
      )}
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      {!!fancy && (
        <div
          className="TitleBar__close TitleBar__clickable"
          // IE8: Synthetic onClick event doesn't work on IE8.
          // IE8: Use a plain character instead of a unicode symbol.
          // eslint-disable-next-line react/no-unknown-property
          onclick={onClose}>
<<<<<<< HEAD
          {Byond.IS_LTE_IE8 ? 'x' : '×'}
=======
          {IS_IE8 ? 'x' : '×'}
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
        </div>
      )}
    </div>
  );
};
