import { useGame } from '../game';
import type { gameState } from '../game/types';
import { useSettings } from '../settings';
import { MESSAGE_TYPE_UNKNOWN, MESSAGE_TYPES } from './constants';
import { canPageAcceptType } from './model';
import { createMessageNode } from './renderer';
import type { message, Page } from './types';

export function exportToDisk(
  cssText: string,
  startRound: number,
  endRound: number,
  hasTimestamps: boolean,
  page: Page | null,
) {
  const game: gameState = useGame();

  // Fetch from server database
  const opts: SaveFilePickerOptions = {
    id: `ss13-chatlog-${game.roundId}`,
    suggestedName: `ss13-chatlog-${game.roundId}.html`,
    types: [
      {
        description: 'SS13 file',
        accept: { 'text/plain': ['.html'] },
      },
    ],
  };
  // We have to do it likes this, otherwise we get a security error
  // only 516 can do this btw
  if (startRound < endRound) {
    getRound(cssText, game, page, opts, hasTimestamps, startRound, endRound);
  } else if (startRound > 0) {
    getRound(cssText, game, page, opts, hasTimestamps, startRound);
  } else {
    getRound(cssText, game, page, opts, hasTimestamps);
  }
}

async function getRound(
  cssText: string,
  game: gameState,
  page: Page | null,
  opts: SaveFilePickerOptions,
  hasTimestamps: boolean,
  startRound?: number,
  endRound?: number,
) {
  const settings = useSettings();
  const { ckey, token } = game.userData;
  let messages: message[] = [];

  const d = new Date();
  const utcOffset = d.getTimezoneOffset() / -60;

  let roundToExport = startRound;
  if (!roundToExport) {
    roundToExport = game.roundId ? game.roundId : 0;
  }
  let requestString = `${game.chatlogApiEndpoint}/api/export/${ckey}/${settings.logLineCount}?start_id=${roundToExport}`;
  if (hasTimestamps) {
    requestString += `&timezone_offset=${utcOffset}`;
  }
  if (endRound) {
    requestString += `&end_id=${endRound}`;
  }
  window
    .showSaveFilePicker(opts)
    .then(async (fileHandle) => {
      await new Promise<void>((resolve) => {
        fetch(requestString, {
          method: 'GET',
          headers: {
            Accept: 'application/json',
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        })
          .then((response) => response.json())
          .then((json) => {
            json.forEach(
              (obj: {
                msg_type: string | null;
                text_raw: string;
                created_at: number;
                round_id: number;
              }) => {
                const msg: message = {
                  type: obj.msg_type ? obj.msg_type : '',
                  html: obj.text_raw,
                  createdAt: obj.created_at,
                  roundId: obj.round_id,
                };
                const node = createMessageNode();
                node.innerHTML = msg.html ? msg.html : '';

                if (!msg.type) {
                  const typeDef = MESSAGE_TYPES.find(
                    (typeDef) =>
                      typeDef.selector && node.querySelector(typeDef.selector),
                  );
                  msg.type = typeDef?.type || MESSAGE_TYPE_UNKNOWN;
                }

                msg.html = node.outerHTML;

                messages.push(msg);
              },
            );

            let messagesHtml = '';
            if (messages) {
              for (let message of messages) {
                // Filter messages according to active tab for export
                if (page && canPageAcceptType(page, message.type)) {
                  messagesHtml += message.html + '\n';
                }
              }

              const pageHtml =
                '<!doctype html>\n' +
                '<html>\n' +
                '<head>\n' +
                '<title>SS13 Chat Log - Round ' +
                game.roundId +
                '</title>\n' +
                '<style>\n' +
                cssText +
                '</style>\n' +
                '</head>\n' +
                '<body>\n' +
                '<div class="Chat">\n' +
                messagesHtml +
                '</div>\n' +
                '</body>\n' +
                '</html>\n';

              try {
                fileHandle.createWritable().then((writableHandle) => {
                  writableHandle.write(pageHtml);
                  writableHandle.close();
                });
              } catch (e) {
                console.error(e);
              }

              resolve();
            }
          })
          .catch((e) => {
            console.error(e);
            resolve();
          });
      });
    })
    .catch((e) => {
      // Log the error if the error has nothing to do with the user aborting the download
      if (e.name !== 'AbortError') {
        console.error(e);
      }
    });
}
