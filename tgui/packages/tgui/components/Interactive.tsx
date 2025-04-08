/**
 * MIT License
 * https://github.com/omgovich/react-colorful/
 *
 * Copyright (c) 2020 Vlad Shilov <omgovich@ya.ru>
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import React, {
  Component,
  createRef,
  type ReactNode,
  type RefObject,
} from 'react';
import { isArrow, KEY } from 'tgui-core/keys';
import { clamp } from 'tgui-core/math';

export interface Interaction {
  left: number;
  top: number;
}

// Finds the proper window object to fix iframe embedding issues
const getParentWindow = (node?: HTMLDivElement | null): Window => {
  return (node && node.ownerDocument.defaultView) || window;
};

// Returns a relative position of the pointer inside the node's bounding box
const getRelativePosition = (
  node: HTMLDivElement,
  event: MouseEvent,
): Interaction => {
  const rect = node.getBoundingClientRect();
  const parentWindow = getParentWindow(node);

  const offsetX = event.pageX - (rect.left + parentWindow.scrollX);
  const offsetY = event.pageY - (rect.top + parentWindow.scrollY);

  return {
    left: clamp(offsetX / rect.width, 0, 1),
    top: clamp(offsetY / rect.height, 0, 1),
  };
};

export interface InteractiveProps {
  onMove: (interaction: Interaction) => void;
  onKey: (offset: Interaction) => void;
  children: ReactNode;
  style?: React.CSSProperties;
}

export class Interactive extends Component<InteractiveProps> {
  containerRef: RefObject<HTMLDivElement | null>;

  constructor(props: InteractiveProps) {
    super(props);
    this.containerRef = createRef();
  }

  handleMoveStart = (event: React.MouseEvent<HTMLDivElement>) => {
    const el = this.containerRef?.current;
    if (!el) return;

    // Prevent text selection
    event.preventDefault();
    el.focus();
    this.props.onMove(getRelativePosition(el, event.nativeEvent));
    this.toggleDocumentEvents(true);
  };

  handleMove = (event: MouseEvent) => {
    event.preventDefault();

    const isDown = event.buttons > 0;

    if (isDown && this.containerRef?.current) {
      this.props.onMove(getRelativePosition(this.containerRef.current, event));
    } else {
      this.toggleDocumentEvents(false);
    }
  };

  handleMoveEnd = () => {
    this.toggleDocumentEvents(false);
  };

  handleKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    const pressedKey = event.key;

    if (!isArrow(pressedKey)) {
      return;
    }
    event.preventDefault();
    this.props.onKey({
      left:
        pressedKey === KEY.Right ? 0.05 : pressedKey === KEY.Left ? -0.05 : 0,
      top: pressedKey === KEY.Down ? 0.05 : pressedKey === KEY.Up ? -0.05 : 0,
    });
  };

  toggleDocumentEvents(state?: boolean) {
    const el = this.containerRef?.current;
    const parentWindow = getParentWindow(el);

    const toggleEvent = state
      ? parentWindow.addEventListener
      : parentWindow.removeEventListener;
    toggleEvent('mousemove', this.handleMove);
    toggleEvent('mouseup', this.handleMoveEnd);
  }

  componentDidMount() {
    this.toggleDocumentEvents(true);
  }

  componentWillUnmount() {
    this.toggleDocumentEvents(false);
  }

  render() {
    const { style, children, ...rest } = this.props;
    return (
      <div
        {...rest}
        style={style}
        ref={this.containerRef}
        onMouseDown={this.handleMoveStart}
        className="react-colorful__interactive"
        onKeyDown={this.handleKeyDown}
        tabIndex={0}
        role="slider"
      >
        {children}
      </div>
    );
  }
}
