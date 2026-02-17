import { chunkingAtom, store } from '../store';

/// --------- Handlers ------------------------------------------------------///

type OversizePayload = {
  allow: boolean;
  id: string;
};

export function oversizePayloadResponse(payload: OversizePayload): void {
  const { allow, id } = payload;

  if (allow) {
    nextChunk(id);
  } else {
    store.set(chunkingAtom, (prev) => {
      const { [id]: _, ...otherQueues } = prev;
      return otherQueues;
    });
  }
}

export function acknowledgePayloadChunk(payload: OversizePayload): void {
  const { id } = payload;

  const queues = store.get(chunkingAtom);
  const queue = queues[id];

  if (!queue || queue.length === 0) return;

  const [, ...rest] = queue;

  if (rest.length === 0) {
    store.set(chunkingAtom, (prev) => {
      const { [id]: _, ...others } = prev;
      return others;
    });
    return;
  }

  store.set(chunkingAtom, (prev) => ({
    ...prev,
    [id]: rest,
  }));
  Byond.sendMessage('payloadChunk', {
    id,
    chunk: rest[0],
  });
}

/// --------- Helpers -------------------------------------------------------///

function nextChunk(id: string): void {
  const queues = store.get(chunkingAtom);
  const chunk = queues[id]?.[0];

  if (chunk) {
    Byond.sendMessage('payloadChunk', {
      id,
      chunk,
    });
  }
}

type CreateQueueParams = {
  id: string;
  chunks: string[];
};

export function createQueue(payload: CreateQueueParams): void {
  const { id, chunks } = payload;

  store.set(chunkingAtom, (prev) => ({
    ...prev,
    [id]: chunks,
  }));
}
