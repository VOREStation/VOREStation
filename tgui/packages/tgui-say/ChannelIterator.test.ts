import { ChannelIterator } from './ChannelIterator';

describe('ChannelIterator', () => {
  let channelIterator: ChannelIterator;

  beforeEach(() => {
    channelIterator = new ChannelIterator();
  });

  it('should cycle through channels properly', () => {
    expect(channelIterator.current()).toBe('Say');
    expect(channelIterator.next()).toBe('Radio');
    expect(channelIterator.next()).toBe('Me');
    expect(channelIterator.next()).toBe('Whis');
    expect(channelIterator.next()).toBe('Subtle');
    expect(channelIterator.next()).toBe('LOOC');
    expect(channelIterator.next()).toBe('OOC');
    expect(channelIterator.next()).toBe('Say'); // Admin is blacklisted so it should be skipped
  });

  it('should cycle through channels backwards properly', () => {
    expect(channelIterator.current()).toBe('Say');
    expect(channelIterator.prev()).toBe('OOC'); // Admin is blacklisted so it should be skipped
    expect(channelIterator.prev()).toBe('LOOC');
    expect(channelIterator.prev()).toBe('Subtle');
    expect(channelIterator.prev()).toBe('Whis');
    expect(channelIterator.prev()).toBe('Me');
    expect(channelIterator.prev()).toBe('Radio');
    expect(channelIterator.prev()).toBe('Say');
  });

  it('should set a channel properly', () => {
    channelIterator.set('OOC');
    expect(channelIterator.current()).toBe('OOC');
  });

  it('should return true when current channel is "Say"', () => {
    channelIterator.set('Say');
    expect(channelIterator.isSay()).toBe(true);
  });

  it('should return false when current channel is not "Say"', () => {
    channelIterator.set('Radio');
    expect(channelIterator.isSay()).toBe(false);
  });

  it('should return true when current channel is visible', () => {
    channelIterator.set('Say');
    expect(channelIterator.isVisible()).toBe(true);
  });

  it('should return false when current channel is not visible', () => {
    channelIterator.set('OOC');
    expect(channelIterator.isVisible()).toBe(false);
  });

  it('should not leak a message from a blacklisted channel', () => {
    channelIterator.set('Admin');
    expect(channelIterator.next()).toBe('Admin');
  });
});
