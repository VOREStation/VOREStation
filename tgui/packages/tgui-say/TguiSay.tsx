import './styles/main.scss';

import { useEffect, useRef, useState } from 'react';
import { dragStartHandler } from 'tgui/drag';
import { isEscape, KEY } from 'tgui-core/keys';
import { clamp } from 'tgui-core/math';
import { type BooleanLike, classes } from 'tgui-core/react';

import { type Channel, ChannelIterator } from './ChannelIterator';
import { ChatHistory } from './ChatHistory';
import { LineLength, RADIO_PREFIXES, WindowSize } from './constants';
import {
  getMarkupString,
  getPrefix,
  windowClose,
  windowOpen,
  windowSet,
} from './helpers';
import { byondMessages } from './timers';

type ByondOpen = {
  channel: Channel;
};

type ByondProps = {
  maxLength: number;
  minimumHeight: number;
  minimumWidth: number;
  lightMode: BooleanLike;
  scale: BooleanLike;
};

export function TguiSay() {
  const innerRef = useRef<HTMLTextAreaElement>(null);
  const channelIterator = useRef(new ChannelIterator());
  const chatHistory = useRef(new ChatHistory());
  const messages = useRef(byondMessages);
  const scale = useRef(true);
  const minimumHeight = useRef(WindowSize.Small);
  const minimumWidth = useRef(WindowSize.Width);

  // I initially wanted to make these an object or a reducer, but it's not really worth it.
  // You lose the granulatity and add a lot of boilerplate.
  const [buttonContent, setButtonContent] = useState('');
  const [currentPrefix, setCurrentPrefix] = useState<
    keyof typeof RADIO_PREFIXES | null
  >(null);
  const [maxLength, setMaxLength] = useState(4096);
  const [size, setSize] = useState(WindowSize.Small);
  const [lightMode, setLightMode] = useState(false);
  const [value, setValue] = useState('');

  const position = useRef([window.screenX, window.screenY]);
  const isDragging = useRef(false);

  function handleArrowKeys(direction: KEY.PageUp | KEY.PageDown): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    if (direction === KEY.PageUp) {
      if (chat.isAtLatest() && value) {
        // Save current message to temp history if at the most recent message
        chat.saveTemp(value);
      }
      // Try to get the previous message, fall back to the current value if none
      const prevMessage = chat.getOlderMessage();

      if (prevMessage) {
        setButtonContent(chat.getIndex().toString());
        setValue(prevMessage);
      }
    } else {
      const nextMessage = chat.getNewerMessage() || chat.getTemp() || '';

      const newContent = chat.isAtLatest()
        ? iterator.current()
        : chat.getIndex().toString();

      setButtonContent(newContent);
      setValue(nextMessage);
    }
  }

  function handleBackspaceDelete(): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    // User is on a chat history message
    if (!chat.isAtLatest()) {
      chat.reset();
      setButtonContent(currentPrefix ?? iterator.current());

      // Empty input, resets the channel
    } else if (currentPrefix && iterator.isSay() && value?.length === 0) {
      setCurrentPrefix(null);
      setButtonContent(iterator.current());
    }
  }

  function handleButtonClick(event: React.MouseEvent<HTMLButtonElement>): void {
    isDragging.current = true;

    setTimeout(() => {
      // So the button doesn't jump around accidentally
      if (isDragging.current) {
        dragStartHandler(event.nativeEvent);
      }
    }, 50);
  }

  // Prevents the button from changing channels if it's dragged
  function handleButtonRelease(): void {
    isDragging.current = false;
    const currentPosition = [window.screenX, window.screenY];

    if (JSON.stringify(position.current) !== JSON.stringify(currentPosition)) {
      position.current = currentPosition;
      return;
    }

    handleIncrementChannel();
  }

  function handleClose(): void {
    innerRef.current?.blur();
    windowClose(minimumWidth.current, minimumHeight.current, scale.current);

    setTimeout(() => {
      chatHistory.current.reset();
      channelIterator.current.reset();
      unloadChat();
    }, 25);
  }

  function handleEnter(): void {
    const iterator = channelIterator.current;
    const prefix = currentPrefix ?? '';

    if (value?.length) {
      if (value.length < maxLength) {
        chatHistory.current.add(value);
        Byond.sendMessage('entry', {
          channel: iterator.current(),
          entry: iterator.isSay() ? prefix + value : value,
        });
      } else {
        Byond.sendMessage('lenwarn', {
          length: value.length,
          maxlength: maxLength,
        });
        return;
      }
    }
    handleClose();
  }

  function handleForceSay(): void {
    const iterator = channelIterator.current;

    // Only force say if we're on a visible channel and have typed something
    if (!value || iterator.isVisible()) return;

    const prefix = currentPrefix ?? '';
    const grunt = iterator.isSay() ? prefix + value : value;

    messages.current.forceSayMsg(grunt);
    unloadChat();
  }

  function handleIncrementChannel(): void {
    const iterator = channelIterator.current;

    iterator.next();
    setButtonContent(iterator.current());
    setCurrentPrefix(null);
    messages.current.channelIncrementMsg(
      iterator.isVisible(),
      iterator.current(),
    );
  }

  function handleDecrementChannel() {
    const iterator = channelIterator.current;

    iterator.prev();
    setButtonContent(iterator.current());
    setCurrentPrefix(null);
    messages.current.channelIncrementMsg(
      iterator.isVisible(),
      iterator.current(),
    );
  }

  function handleInput(event: React.FormEvent<HTMLTextAreaElement>): void {
    const iterator = channelIterator.current;
    let newValue = event.currentTarget.value;

    const newPrefix = getPrefix(newValue) || currentPrefix;
    // Handles switching prefixes
    if (newPrefix && newPrefix !== currentPrefix) {
      setButtonContent(RADIO_PREFIXES[newPrefix]);
      setCurrentPrefix(newPrefix);
      newValue = newValue.slice(3);
      iterator.set('Say');

      if (newPrefix === ',b ') {
        Byond.sendMessage('thinking', { visible: false });
      }
    }

    // Handles typing indicators
    if (channelIterator.current.isVisible() && newPrefix !== ',b ') {
      messages.current.typingMsg(iterator.current());
    }

    setValue(newValue);
  }

  function handleKeyDown(
    event: React.KeyboardEvent<HTMLTextAreaElement>,
  ): void {
    if (event.getModifierState('AltGraph')) return;

    switch (event.key) {
      case 'u':
        if (event.ctrlKey || event.metaKey) {
          event.preventDefault();
          const { value, selectionStart, selectionEnd } = event.currentTarget;
          event.currentTarget.value = getMarkupString(
            value,
            '_',
            selectionStart,
            selectionEnd,
          );
          event.currentTarget.selectionEnd = selectionEnd + 2;
        }
        break;
      case 'i':
        if (event.ctrlKey || event.metaKey) {
          event.preventDefault();
          const { value, selectionStart, selectionEnd } = event.currentTarget;
          event.currentTarget.value = getMarkupString(
            value,
            '|',
            selectionStart,
            selectionEnd,
          );
          event.currentTarget.selectionEnd = selectionEnd + 2;
        }
        break;
      case 'b':
        if (event.ctrlKey || event.metaKey) {
          event.preventDefault();
          const { value, selectionStart, selectionEnd } = event.currentTarget;
          event.currentTarget.value = getMarkupString(
            value,
            '+',
            selectionStart,
            selectionEnd,
          );
          event.currentTarget.selectionEnd = selectionEnd + 2;
        }
        break;
      case KEY.PageUp:
      case KEY.PageDown:
        event.preventDefault();
        handleArrowKeys(event.key);
        break;

      case KEY.Delete:
      case KEY.Backspace:
        handleBackspaceDelete();
        break;

      case KEY.Enter:
        if (!event.shiftKey) {
          event.preventDefault();
          handleEnter();
        }
        break;

      case KEY.Tab:
        event.preventDefault();
        if (event.shiftKey) {
          handleDecrementChannel();
          break;
        }
        handleIncrementChannel();
        break;

      default:
        if (isEscape(event.key)) {
          handleClose();
        }
    }
  }

  function handleOpen(data: ByondOpen): void {
    setSize(minimumHeight.current);
    channelIterator.current.set(data.channel);

    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.current());
    windowOpen(
      channelIterator.current.current(),
      minimumWidth.current,
      minimumHeight.current,
      scale.current,
    );

    innerRef.current?.focus();
  }

  function handleProps(data: ByondProps): void {
    setMaxLength(data.maxLength);
    const minWidth = clamp(
      data.minimumWidth,
      WindowSize.Width,
      WindowSize.MaxWidth,
    );
    minimumHeight.current = data.minimumHeight;
    minimumWidth.current = minWidth;
    setLightMode(!!data.lightMode);
    scale.current = !!data.scale;
  }

  function unloadChat(): void {
    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.current());
    setValue('');
  }

  /** Subscribe to Byond messages */
  useEffect(() => {
    Byond.subscribeTo('props', handleProps);
    Byond.subscribeTo('force', handleForceSay);
    Byond.subscribeTo('open', handleOpen);
  }, []);

  /** Value has changed, we need to check if the size of the window is ok */
  useEffect(() => {
    const len = value?.length || 0;

    let newSize: WindowSize;
    if (len > LineLength.Medium) {
      newSize = WindowSize.Large;
    } else if (len <= LineLength.Medium && len > LineLength.Small) {
      newSize = WindowSize.Medium;
    } else {
      newSize = WindowSize.Small;
    }
    newSize = clamp(newSize, minimumHeight.current, WindowSize.Max);

    if (size !== newSize) {
      windowSet(minimumWidth.current, newSize, scale.current);
      setSize(newSize);
    }
  }, [value]);

  const theme =
    (lightMode && 'lightMode') ||
    (currentPrefix && RADIO_PREFIXES[currentPrefix]) ||
    channelIterator.current.current();

  return (
    <>
      <div
        className={`window window-${theme} window-${size}`}
        style={{
          zoom: scale.current ? '' : `${100 / window.devicePixelRatio}%`,
        }}
        onMouseDown={dragStartHandler}
      >
        {!lightMode && <div className={`shine shine-${theme}`} />}
      </div>
      <div
        className={classes(['content', lightMode && 'content-lightMode'])}
        style={{
          zoom: scale.current ? '' : `${100 / window.devicePixelRatio}%`,
        }}
      >
        <button
          className={`button button-${theme}`}
          onMouseDown={handleButtonClick}
          onMouseUp={handleButtonRelease}
          type="button"
        >
          {buttonContent}
        </button>
        <textarea
          spellCheck
          autoCorrect="off"
          className={classes([
            'textarea',
            `textarea-${theme}`,
            value.length > LineLength.Large && 'textarea-large',
          ])}
          maxLength={maxLength}
          onInput={handleInput}
          onKeyDown={handleKeyDown}
          ref={innerRef}
          value={value}
        />
        <button
          key="escape"
          className={`button button-${theme}`}
          onClick={handleClose}
          type="submit"
        >
          X
        </button>
      </div>
    </>
  );
}
