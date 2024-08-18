import { KEY } from 'common/keys';
import { BooleanLike } from 'common/react';
import { Component, createRef, RefObject } from 'react';
import { dragStartHandler } from 'tgui/drag';
import {
  removeAllSkiplines,
  sanitizeMultiline,
} from 'tgui/interfaces/TextInputModal';

import { Channel, ChannelIterator } from './ChannelIterator';
import { ChatHistory } from './ChatHistory';
import { LINE_LENGTHS, RADIO_PREFIXES, WINDOW_SIZES } from './constants';
import { windowClose, windowOpen, windowSet } from './helpers';
import { byondMessages } from './timers';

type ByondOpen = {
  channel: Channel;
};

type ByondProps = {
  maxLength: number;
  lightMode: BooleanLike;
};

type State = {
  buttonContent: string | number;
  size: WINDOW_SIZES;
};

const CHANNEL_REGEX = /^:\w\s|^,b\s/;

export class TguiSay extends Component<{}, State> {
  private channelIterator: ChannelIterator;
  private chatHistory: ChatHistory;
  private currentPrefix: keyof typeof RADIO_PREFIXES | null;
  private innerRef: RefObject<HTMLTextAreaElement>;
  private lightMode: boolean;
  private maxLength: number;
  private messages: typeof byondMessages;
  state: State;

  constructor(props: never) {
    super(props);

    this.channelIterator = new ChannelIterator();
    this.chatHistory = new ChatHistory();
    this.currentPrefix = null;
    this.innerRef = createRef();
    this.lightMode = false;
    this.maxLength = 1024;
    this.messages = byondMessages;
    this.state = {
      buttonContent: '',
      size: WINDOW_SIZES.small,
    };

    this.handleArrowKeys = this.handleArrowKeys.bind(this);
    this.handleBackspaceDelete = this.handleBackspaceDelete.bind(this);
    this.handleClose = this.handleClose.bind(this);
    this.handleEnter = this.handleEnter.bind(this);
    this.handleForceSay = this.handleForceSay.bind(this);
    this.handleIncrementChannel = this.handleIncrementChannel.bind(this);
    this.handleInput = this.handleInput.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);
    this.handleOpen = this.handleOpen.bind(this);
    this.handleProps = this.handleProps.bind(this);
    this.reset = this.reset.bind(this);
    this.setSize = this.setSize.bind(this);
    this.setValue = this.setValue.bind(this);
  }

  componentDidMount() {
    Byond.subscribeTo('props', this.handleProps);
    Byond.subscribeTo('force', this.handleForceSay);
    Byond.subscribeTo('open', this.handleOpen);
  }

  handleArrowKeys(direction: KEY.PageUp | KEY.PageDown) {
    const currentValue = this.innerRef.current?.value;

    if (direction === KEY.PageUp) {
      if (this.chatHistory.isAtLatest() && currentValue) {
        // Save current message to temp history if at the most recent message
        this.chatHistory.saveTemp(currentValue);
      }
      // Try to get the previous message, fall back to the current value if none
      const prevMessage = this.chatHistory.getOlderMessage();

      if (prevMessage) {
        this.setState({ buttonContent: this.chatHistory.getIndex() });
        this.setSize(prevMessage.length);
        this.setValue(prevMessage);
      }
    } else {
      const nextMessage =
        this.chatHistory.getNewerMessage() || this.chatHistory.getTemp() || '';

      const buttonContent = this.chatHistory.isAtLatest()
        ? this.channelIterator.current()
        : this.chatHistory.getIndex();

      this.setState({ buttonContent });
      this.setSize(nextMessage.length);
      this.setValue(nextMessage);
    }
  }

  handleBackspaceDelete() {
    const typed = this.innerRef.current?.value;

    // User is on a chat history message
    if (!this.chatHistory.isAtLatest()) {
      this.chatHistory.reset();
      this.setState({
        buttonContent: this.currentPrefix ?? this.channelIterator.current(),
      });
      // Empty input, resets the channel
    } else if (
      !!this.currentPrefix &&
      this.channelIterator.isSay() &&
      typed?.length === 0
    ) {
      this.currentPrefix = null;
      this.setState({ buttonContent: this.channelIterator.current() });
    }

    this.setSize(typed?.length);
  }

  handleClose() {
    const current = this.innerRef.current;

    if (current) {
      current.blur();
    }

    this.reset();
    this.chatHistory.reset();
    this.channelIterator.reset();
    this.currentPrefix = null;
    windowClose();
  }

  handleEnter() {
    const prefix = this.currentPrefix ?? '';
    const value = this.innerRef.current?.value;

    if (value?.length && value.length < this.maxLength) {
      this.chatHistory.add(value);

      // Everything can be multiline, but only emotes get passed that way to the game
      const sanitizedValue = this.channelIterator.isMultiline()
        ? sanitizeMultiline(value)
        : removeAllSkiplines(value);

      Byond.sendMessage('entry', {
        channel: this.channelIterator.current(),
        entry: this.channelIterator.isSay()
          ? prefix + sanitizedValue
          : sanitizedValue,
      });
    }

    this.handleClose();
  }

  handleForceSay() {
    const currentValue = this.innerRef.current?.value;
    // Only force say if we're on a visible channel and have typed something
    if (!currentValue || !this.channelIterator.isVisible()) return;

    const prefix = this.currentPrefix ?? '';
    const grunt = this.channelIterator.isSay()
      ? prefix + currentValue
      : currentValue;

    this.messages.forceSayMsg(grunt);
    this.reset();
  }

  handleIncrementChannel() {
    this.currentPrefix = null;

    this.channelIterator.next();

    // If we've looped onto a quiet channel, tell byond to hide thinking indicators
    if (!this.channelIterator.isVisible()) {
      this.messages.channelIncrementMsg(false, this.channelIterator.current());
    } else {
      this.messages.channelIncrementMsg(true, this.channelIterator.current());
    }

    this.setState({ buttonContent: this.channelIterator.current() });
  }

  handleDecrementChannel() {
    this.currentPrefix = null;

    this.channelIterator.prev();

    // If we've looped onto a quiet channel, tell byond to hide thinking indicators
    if (!this.channelIterator.isVisible()) {
      this.messages.channelIncrementMsg(false, this.channelIterator.current());
    } else {
      this.messages.channelIncrementMsg(true, this.channelIterator.current());
    }

    this.setState({ buttonContent: this.channelIterator.current() });
  }

  handleInput() {
    const typed = this.innerRef.current?.value;

    // If we're typing, send the message
    if (this.channelIterator.isVisible()) {
      this.messages.typingMsg(this.channelIterator.current());
    }

    this.setSize(typed?.length);

    // Is there a value? Is it long enough to be a prefix?
    if (!typed || typed.length < 3) {
      return;
    }

    if (!CHANNEL_REGEX.test(typed)) {
      return;
    }

    // Is it a valid prefix?
    const prefix = typed
      .slice(0, 3)
      ?.toLowerCase() as keyof typeof RADIO_PREFIXES;
    if (!RADIO_PREFIXES[prefix] || prefix === this.currentPrefix) {
      return;
    }

    this.channelIterator.set('Say');
    this.currentPrefix = prefix;
    this.setState({ buttonContent: RADIO_PREFIXES[prefix] });
    this.setValue(typed.slice(3));
  }

  handleKeyDown(event: React.KeyboardEvent<HTMLTextAreaElement>) {
    const currentValue = this.innerRef.current?.value;
    switch (event.key) {
      case KEY.PageUp:
      case KEY.PageDown:
        // Allow moving between lines if there are newlines
        /* if (currentValue?.includes('\n')) {
          break;
        } */
        event.preventDefault();
        this.handleArrowKeys(event.key);
        break;

      case KEY.Delete:
      case KEY.Backspace:
        this.handleBackspaceDelete();
        break;

      case KEY.Enter:
        // Allow inputting newlines
        if (event.shiftKey) {
          break;
        }
        event.preventDefault();
        this.handleEnter();
        break;

      case KEY.Tab:
        event.preventDefault();
        if (event.shiftKey) {
          this.handleDecrementChannel();
        } else {
          this.handleIncrementChannel();
        }
        break;

      case KEY.Escape:
        this.handleClose();
        break;
    }
  }

  handleOpen = (data: ByondOpen) => {
    setTimeout(() => {
      this.innerRef.current?.focus();
    }, 0);

    const { channel } = data;
    // Catches the case where the modal is already open
    if (this.channelIterator.isSay()) {
      this.channelIterator.set(channel);
    }
    this.setState({ buttonContent: this.channelIterator.current() });

    windowOpen(this.channelIterator.current());
  };

  handleProps = (data: ByondProps) => {
    const { maxLength, lightMode } = data;
    this.maxLength = maxLength;
    this.lightMode = !!lightMode;
  };

  reset() {
    this.setValue('');
    this.setSize();
    this.setState({
      buttonContent: this.channelIterator.current(),
    });
  }

  setSize(length = 0) {
    let newSize: WINDOW_SIZES;

    const currentValue = this.innerRef.current?.value;

    if (currentValue?.includes('\n')) {
      newSize = WINDOW_SIZES.large;
    } else if (length > LINE_LENGTHS.medium) {
      newSize = WINDOW_SIZES.large;
    } else if (length <= LINE_LENGTHS.medium && length > LINE_LENGTHS.small) {
      newSize = WINDOW_SIZES.medium;
    } else {
      newSize = WINDOW_SIZES.small;
    }

    if (this.state.size !== newSize) {
      this.setState({ size: newSize });
      windowSet(newSize);
    }
  }

  setValue(value: string) {
    const textArea = this.innerRef.current;
    if (textArea) {
      textArea.value = value;
    }
  }

  render() {
    const theme =
      (this.lightMode && 'lightMode') ||
      (this.currentPrefix && RADIO_PREFIXES[this.currentPrefix]) ||
      this.channelIterator.current();

    return (
      <div className={`window window-${theme} window-${this.state.size}`}>
        <Dragzone position="top" theme={theme} />
        <div className="center">
          <Dragzone position="left" theme={theme} />
          <div className="input">
            <button
              className={`button button-${theme}`}
              onClick={this.handleIncrementChannel}
              type="button"
            >
              {this.state.buttonContent}
            </button>
            <textarea
              className={`textarea textarea-${theme}`}
              maxLength={this.maxLength}
              onInput={this.handleInput}
              onKeyDown={this.handleKeyDown}
              ref={this.innerRef}
            />
          </div>
          <Dragzone position="right" theme={theme} />
        </div>
        <Dragzone position="bottom" theme={theme} />
      </div>
    );
  }
}

const Dragzone = ({ theme, position }: { theme: string; position: string }) => {
  // Horizontal or vertical?
  const location =
    position === 'left' || position === 'right' ? 'vertical' : 'horizontal';

  return (
    <div
      className={`dragzone-${location} dragzone-${position} dragzone-${theme}`}
      onMouseDown={dragStartHandler}
    />
  );
};
