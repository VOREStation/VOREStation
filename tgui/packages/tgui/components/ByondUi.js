<<<<<<< HEAD
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { shallowDiffers } from 'common/react';
import { debounce } from 'common/timer';
import { Component, createRef } from 'inferno';
=======
import { shallowDiffers } from 'common/react';
import { debounce } from 'common/timer';
import { Component, createRef } from 'inferno';
import { callByond, IS_IE8 } from '../byond';
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
import { createLogger } from '../logging';
import { computeBoxProps } from './Box';

const logger = createLogger('ByondUi');

// Stack of currently allocated BYOND UI element ids.
const byondUiStack = [];

const createByondUiElement = elementId => {
  // Reserve an index in the stack
  const index = byondUiStack.length;
  byondUiStack.push(null);
  // Get a unique id
  const id = elementId || 'byondui_' + index;
  logger.log(`allocated '${id}'`);
  // Return a control structure
  return {
    render: params => {
      logger.log(`rendering '${id}'`);
      byondUiStack[index] = id;
<<<<<<< HEAD
      Byond.winset(id, params);
=======
      callByond('winset', {
        ...params,
        id,
      });
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    },
    unmount: () => {
      logger.log(`unmounting '${id}'`);
      byondUiStack[index] = null;
<<<<<<< HEAD
      Byond.winset(id, {
=======
      callByond('winset', {
        id,
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
        parent: '',
      });
    },
  };
};

window.addEventListener('beforeunload', () => {
  // Cleanly unmount all visible UI elements
  for (let index = 0; index < byondUiStack.length; index++) {
    const id = byondUiStack[index];
    if (typeof id === 'string') {
      logger.log(`unmounting '${id}' (beforeunload)`);
      byondUiStack[index] = null;
<<<<<<< HEAD
      Byond.winset(id, {
=======
      callByond('winset', {
        id,
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
        parent: '',
      });
    }
  }
});

/**
 * Get the bounding box of the DOM element.
 */
const getBoundingBox = element => {
  const rect = element.getBoundingClientRect();
  return {
    pos: [
      rect.left,
      rect.top,
    ],
    size: [
      rect.right - rect.left,
      rect.bottom - rect.top,
    ],
  };
};

export class ByondUi extends Component {
  constructor(props) {
    super(props);
    this.containerRef = createRef();
    this.byondUiElement = createByondUiElement(props.params?.id);
    this.handleResize = debounce(() => {
      this.forceUpdate();
<<<<<<< HEAD
    }, 100);
=======
    }, 500);
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  }

  shouldComponentUpdate(nextProps) {
    const {
      params: prevParams = {},
      ...prevRest
    } = this.props;
    const {
      params: nextParams = {},
      ...nextRest
    } = nextProps;
    return shallowDiffers(prevParams, nextParams)
      || shallowDiffers(prevRest, nextRest);
  }

  componentDidMount() {
    // IE8: It probably works, but fuck you anyway.
<<<<<<< HEAD
    if (Byond.IS_LTE_IE10) {
      return;
    }
    window.addEventListener('resize', this.handleResize);
    this.componentDidUpdate();
    this.handleResize();
=======
    if (IS_IE8) {
      return;
    }
    window.addEventListener('resize', this.handleResize);
    return this.componentDidUpdate();
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  }

  componentDidUpdate() {
    // IE8: It probably works, but fuck you anyway.
<<<<<<< HEAD
    if (Byond.IS_LTE_IE10) {
=======
    if (IS_IE8) {
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      return;
    }
    const {
      params = {},
    } = this.props;
    const box = getBoundingBox(this.containerRef.current);
    logger.log('bounding box', box);
    this.byondUiElement.render({
<<<<<<< HEAD
      parent: window.__windowId__,
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      ...params,
      pos: box.pos[0] + ',' + box.pos[1],
      size: box.size[0] + 'x' + box.size[1],
    });
  }

  componentWillUnmount() {
    // IE8: It probably works, but fuck you anyway.
<<<<<<< HEAD
    if (Byond.IS_LTE_IE10) {
=======
    if (IS_IE8) {
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      return;
    }
    window.removeEventListener('resize', this.handleResize);
    this.byondUiElement.unmount();
  }

  render() {
<<<<<<< HEAD
    const { params, ...rest } = this.props;
=======
    const {
      parent,
      params,
      ...rest
    } = this.props;
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
    const type = params?.type;
    const boxProps = computeBoxProps(rest);
    return (
      <div
        ref={this.containerRef}
        {...boxProps}>
<<<<<<< HEAD
        {/* Filler */}
        <div style={{ 'min-height': '22px' }} />
=======
        {type === 'button' && <ButtonMock />}
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
      </div>
    );
  }
}
<<<<<<< HEAD
=======

const ButtonMock = () => (
  <div
    style={{
      'min-height': '22px',
    }} />
);
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
