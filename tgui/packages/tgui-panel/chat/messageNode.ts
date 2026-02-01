export function createMessageNode(): HTMLElement {
  const node = document.createElement('div');
  node.className = 'ChatMessage';
  return node;
}
