/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { storage } from 'common/storage';
import { createLogger } from 'tgui/logging';
import { store } from '../events/store';
import { userDataAtom } from '../game/atoms';
import type { TelemetryUpdatePayload } from '../game/types';
import { MAX_CONNECTIONS_STORED } from './constants';
import { type ConnectionRecord, connectionsMatch } from './helpers';

type Telemetry = {
  connections: ConnectionRecord[];
};

type TelemetryRequestPayload = {
  limits?: {
    connections: number;
  };
};

const logger = createLogger('telemetry');

let telemetry: Telemetry | null = null;
let wasRequestedWithPayload: TelemetryRequestPayload | null = null;

export function telemetryRequest(payload: TelemetryRequestPayload): void {
  // Defer telemetry request until we have the actual telemetry
  if (!telemetry) {
    logger.debug('deferred telemetry');
    wasRequestedWithPayload = payload;
    return;
  }

  logger.debug('sending telemetry');
  const limits = payload?.limits?.connections;
  // Trim connections according to the server limit
  const connections = telemetry.connections.slice(0, limits);
  Byond.sendMessage('telemetry', { connections });
}

export function testTelemetryCommand() {
  setTimeout(() => {
    if (!telemetry) {
      Byond.sendMessage('ready');
    }
  }, 500);
}

export async function handleTelemetryData(
  payload: TelemetryUpdatePayload,
): Promise<void> {
  // Extract client data
  const client = payload?.config?.client;
  if (!client) {
    logger.error('backend/update payload is missing client data!');
    return;
  }
  store.set(userDataAtom, {
    ckey: payload.config.client.ckey,
    token: payload.config.client.chatlog_token,
  });

  // Load telemetry
  if (!telemetry) {
    const stored = await storage.get('telemetry');
    telemetry = {
      connections: stored?.connections ?? [],
    };
    logger.debug('Retrieved telemetry from storage', telemetry);
  }

  // Append a connection record
  let telemetryMutated = false;

  const duplicateConnection = telemetry!.connections.find((conn) =>
    connectionsMatch(conn, client),
  );

  if (!duplicateConnection) {
    telemetryMutated = true;
    telemetry!.connections.unshift(client);
    if (telemetry!.connections.length > MAX_CONNECTIONS_STORED) {
      telemetry!.connections.pop();
    }
  }

  // Save telemetry
  if (telemetryMutated) {
    logger.debug('Saving telemetry to storage', telemetry);
    storage.set('telemetry', telemetry);
  }

  // Continue deferred telemetry requests
  if (wasRequestedWithPayload) {
    const deferred = wasRequestedWithPayload;
    wasRequestedWithPayload = null;
    telemetryRequest(deferred);
  }
}
