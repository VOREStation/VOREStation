import { useAtomValue } from 'jotai';
import { useState } from 'react';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Dropdown,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import { MESSAGE_TYPES } from '../../chat/constants';
import { purgeMessageArchive } from '../../chat/helpers';
import { chatRenderer } from '../../chat/renderer';
import { gameAtom } from '../../game/atoms';
import { exportChatSettings, importChatSettings } from '../settingsImExport';
import { useSettings } from '../use-settings';

export const ExportTab = (props) => {
  const game = useAtomValue(gameAtom);
  const { settings, updateSettings, toggleInObject } = useSettings();
  const [purgeButtonText, setPurgeButtonText] = useState(
    'Purge message archive',
  );
  return (
    <Section>
      <Stack align="baseline">
        {!game.databaseBackendEnabled &&
          (settings.logEnable ? (
            <Button.Confirm
              tooltip="Disable local chat logging"
              icon="ban"
              color="red"
              confirmIcon="ban"
              confirmColor="red"
              confirmContent="Disable?"
              onClick={() =>
                updateSettings({
                  logEnable: false,
                })
              }
            >
              Disable logging
            </Button.Confirm>
          ) : (
            <Button
              tooltip="Enable local chat logging"
              icon="download"
              color="green"
              onClick={() =>
                updateSettings({
                  logEnable: true,
                })
              }
            >
              Enable logging
            </Button>
          ))}
        <Stack.Item grow />
        <Stack.Item color="label">Round ID:</Stack.Item>
        <Stack.Item color={game.roundId ? '' : 'red'}>
          {game.roundId ? game.roundId : 'ERROR'}
        </Stack.Item>
        <Stack.Item color="label">DB Chatlogging:</Stack.Item>
        <Stack.Item color={game.databaseBackendEnabled ? 'green' : 'red'}>
          {game.databaseBackendEnabled ? 'Enabled' : 'Disabled'}
        </Stack.Item>
      </Stack>
      {settings.logEnable && !game.databaseBackendEnabled && (
        <>
          <LabeledList>
            <LabeledList.Item label="Amount of rounds to log (1 to 8)">
              <NumberInput
                tickWhileDragging
                width="5em"
                step={1}
                stepPixelSize={10}
                minValue={1}
                maxValue={8}
                value={settings.logRetainRounds}
                format={(value) => value.toFixed()}
                onChange={(value) =>
                  updateSettings({
                    logRetainRounds: value,
                  })
                }
              />
              &nbsp;
              {settings.logRetainRounds > 3 && (
                <Box inline fontSize="0.9em" color="red">
                  Warning, might crash!
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Hardlimit for the log archive (0 = inf. to 50000)">
              <NumberInput
                tickWhileDragging
                width="5em"
                step={500}
                stepPixelSize={10}
                minValue={0}
                maxValue={50000}
                value={settings.logLimit}
                format={(value) => value.toFixed()}
                onChange={(value) =>
                  updateSettings({
                    logLimit: value,
                  })
                }
              />
              &nbsp;
              {settings.logLimit > 0 && (
                <Box
                  inline
                  fontSize="0.9em"
                  color={settings.logLimit > 10000 ? 'red' : 'label'}
                >
                  {settings.logLimit > 15000
                    ? 'Warning, might crash! Takes priority above round retention.'
                    : 'Takes priority above round retention.'}
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
          <Section>
            <Collapsible mt={1} color="transparent" title="Messages to log">
              {MESSAGE_TYPES.map((typeDef) => (
                <Button.Checkbox
                  key={typeDef.type}
                  checked={settings.storedTypes[typeDef.type]}
                  onClick={() =>
                    updateSettings({
                      storedTypes: toggleInObject(
                        settings.storedTypes,
                        typeDef.type,
                      ),
                    })
                  }
                >
                  {typeDef.name}
                </Button.Checkbox>
              ))}
            </Collapsible>
          </Section>
        </>
      )}
      <LabeledList>
        <LabeledList.Item label="Export round start (0 = curr.) / end (0 = dis.)">
          <Stack align="center">
            {game.databaseBackendEnabled ? (
              <>
                <Stack.Item>
                  <Dropdown
                    onSelected={(value) =>
                      updateSettings({
                        exportStart: value,
                      })
                    }
                    options={game.databaseStoredRounds}
                    selected={settings.exportStart.toString()}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    onSelected={(value) =>
                      updateSettings({
                        exportEnd: value,
                      })
                    }
                    options={game.databaseStoredRounds}
                    selected={settings.exportEnd.toString()}
                  />
                </Stack.Item>
              </>
            ) : (
              <>
                <Stack.Item>
                  <NumberInput
                    tickWhileDragging
                    width="5em"
                    step={1}
                    stepPixelSize={10}
                    minValue={0}
                    maxValue={
                      settings.exportEnd === 0 ? 0 : settings.exportEnd - 1
                    }
                    value={settings.exportStart}
                    format={(value) => value.toFixed()}
                    onChange={(value) =>
                      updateSettings({
                        exportStart: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <NumberInput
                    tickWhileDragging
                    width="5em"
                    step={1}
                    stepPixelSize={10}
                    minValue={
                      settings.exportStart === 0 ? 0 : settings.exportStart + 1
                    }
                    maxValue={settings.storedRounds}
                    value={settings.exportEnd}
                    format={(value) => value.toFixed()}
                    onChange={(value) =>
                      updateSettings({
                        exportEnd: value,
                      })
                    }
                  />
                </Stack.Item>
              </>
            )}
            <Stack.Item>
              <Box fontSize="0.9em" color="label">
                &nbsp;Stored Rounds:&nbsp;
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box>
                {game.databaseBackendEnabled
                  ? game.databaseStoredRounds.length - 1
                  : settings.storedRounds}
              </Box>
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Amount of lines to export (0 = inf.)">
          <NumberInput
            tickWhileDragging
            width="5em"
            step={100}
            stepPixelSize={10}
            minValue={0}
            maxValue={50000}
            value={settings.logLineCount}
            format={(value) => value.toFixed()}
            onChange={(value) =>
              updateSettings({
                logLineCount: value,
              })
            }
          />
        </LabeledList.Item>
        {!game.databaseBackendEnabled && (
          <LabeledList.Item label="Totally stored messages">
            <Box>{chatRenderer.getStoredMessages()}</Box>
          </LabeledList.Item>
        )}
      </LabeledList>
      <Divider />
      <Stack fill>
        <Stack.Item mt={0.15}>
          <Button
            icon="compact-disc"
            tooltip="Export chat settings"
            onClick={() => exportChatSettings()}
          >
            Export settings
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.File
            accept=".json"
            tooltip="Import chat settings"
            icon="arrow-up-from-bracket"
            onSelectFiles={importChatSettings}
          >
            Import settings
          </Button.File>
        </Stack.Item>
        <Stack.Item grow mt={0.15}>
          <Button
            icon="save"
            tooltip="Export current tab history into HTML file"
            onClick={() =>
              chatRenderer.saveToDisk(
                settings.logLineCount,
                chatRenderer.archivedMessages.length - settings.exportEnd,
                chatRenderer.archivedMessages.length - settings.exportStart,
                settings.exportEnd,
                settings.exportStart,
              )
            }
          >
            Save chat log
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.Confirm
            icon="trash"
            tooltip="Erase current tab history"
            onClick={() => chatRenderer.clearChat()}
          >
            Clear chat
          </Button.Confirm>
        </Stack.Item>
        {!game.databaseBackendEnabled && (
          <Stack.Item mt={0.15}>
            <Button.Confirm
              disabled={purgeButtonText === 'Purged!'}
              icon="trash"
              tooltip="Erase current tab history"
              color="red"
              confirmIcon="trash"
              confirmColor="red"
              confirmContent="Are you sure?"
              onClick={() => {
                purgeMessageArchive(updateSettings);
                setPurgeButtonText('Purged!');
                setTimeout(() => {
                  setPurgeButtonText('Purge message archive');
                }, 1000);
              }}
            >
              {purgeButtonText}
            </Button.Confirm>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};
