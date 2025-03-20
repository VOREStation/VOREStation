import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
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
import { toFixed } from 'tgui-core/math';

import {
  clearChat,
  purgeChatMessageArchive,
  saveChatToDisk,
} from '../../chat/actions';
import { MESSAGE_TYPES } from '../../chat/constants';
import { useGame } from '../../game';
import { exportSettings, updateSettings, updateToggle } from '../actions';
import { selectSettings } from '../selectors';
import { importChatSettings } from '../settingsImExport';

export const ExportTab = (props) => {
  const dispatch = useDispatch();
  const game = useGame();
  const {
    storedRounds,
    exportStart,
    exportEnd,
    logRetainRounds,
    logEnable,
    logLineCount,
    logLimit,
    totalStoredMessages,
    storedTypes,
  } = useSelector(selectSettings);
  const [purgeButtonText, setPurgeButtonText] = useState(
    'Purge message archive',
  );
  return (
    <Section>
      <Stack align="baseline">
        {!game.databaseBackendEnabled &&
          (logEnable ? (
            <Button.Confirm
              tooltip="Disable local chat logging"
              icon="ban"
              color="red"
              confirmIcon="ban"
              confirmColor="red"
              confirmContent="Disable?"
              onClick={() => {
                dispatch(
                  updateSettings({
                    logEnable: false,
                  }),
                );
              }}
            >
              Disable logging
            </Button.Confirm>
          ) : (
            <Button
              tooltip="Enable local chat logging"
              icon="download"
              color="green"
              onClick={() => {
                dispatch(
                  updateSettings({
                    logEnable: true,
                  }),
                );
              }}
            >
              Enable logging
            </Button>
          ))}
        <Stack.Item grow />
        <Stack.Item color="label">Round ID:&nbsp;</Stack.Item>
        <Stack.Item color={game.roundId ? '' : 'red'}>
          {game.roundId ? game.roundId : 'ERROR'}
        </Stack.Item>
        <Stack.Item color="label">DB Chatlogging:&nbsp;</Stack.Item>
        <Stack.Item color={game.databaseBackendEnabled ? 'green' : 'red'}>
          {game.databaseBackendEnabled ? 'Enabled' : 'Disabled'}
        </Stack.Item>
      </Stack>
      {logEnable && !game.databaseBackendEnabled && (
        <>
          <LabeledList>
            <LabeledList.Item label="Amount of rounds to log (1 to 8)">
              <NumberInput
                width="5em"
                step={1}
                stepPixelSize={10}
                minValue={1}
                maxValue={8}
                value={logRetainRounds}
                format={(value) => toFixed(value)}
                onDrag={(value) =>
                  dispatch(
                    updateSettings({
                      logRetainRounds: value,
                    }),
                  )
                }
              />
              &nbsp;
              {logRetainRounds > 3 && (
                <Box inline fontSize="0.9em" color="red">
                  Warning, might crash!
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Hardlimit for the log archive (0 = inf. to 50000)">
              <NumberInput
                width="5em"
                step={500}
                stepPixelSize={10}
                minValue={0}
                maxValue={50000}
                value={logLimit}
                format={(value) => toFixed(value)}
                onDrag={(value) =>
                  dispatch(
                    updateSettings({
                      logLimit: value,
                    }),
                  )
                }
              />
              &nbsp;
              {logLimit > 0 && (
                <Box
                  inline
                  fontSize="0.9em"
                  color={logLimit > 10000 ? 'red' : 'label'}
                >
                  {logLimit > 15000
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
                  checked={storedTypes[typeDef.type]}
                  onClick={() =>
                    dispatch(
                      updateToggle({
                        type: typeDef.type,
                      }),
                    )
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
                      dispatch(
                        updateSettings({
                          exportStart: value,
                        }),
                      )
                    }
                    options={game.databaseStoredRounds}
                    selected={exportStart}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    onSelected={(value) =>
                      dispatch(
                        updateSettings({
                          exportEnd: value,
                        }),
                      )
                    }
                    options={game.databaseStoredRounds}
                    selected={exportEnd}
                  />
                </Stack.Item>
              </>
            ) : (
              <>
                <Stack.Item>
                  <NumberInput
                    width="5em"
                    step={1}
                    stepPixelSize={10}
                    minValue={0}
                    maxValue={exportEnd === 0 ? 0 : exportEnd - 1}
                    value={exportStart}
                    format={(value) => toFixed(value)}
                    onDrag={(value) =>
                      dispatch(
                        updateSettings({
                          exportStart: value,
                        }),
                      )
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <NumberInput
                    width="5em"
                    step={1}
                    stepPixelSize={10}
                    minValue={exportStart === 0 ? 0 : exportStart + 1}
                    maxValue={storedRounds}
                    value={exportEnd}
                    format={(value) => toFixed(value)}
                    onDrag={(value) =>
                      dispatch(
                        updateSettings({
                          exportEnd: value,
                        }),
                      )
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
                  : storedRounds}
              </Box>
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Amount of lines to export (0 = inf.)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={10}
            minValue={0}
            maxValue={50000}
            value={logLineCount}
            format={(value) => toFixed(value)}
            onDrag={(value) =>
              dispatch(
                updateSettings({
                  logLineCount: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        {!game.databaseBackendEnabled && (
          <LabeledList.Item label="Totally stored messages">
            <Box>{totalStoredMessages}</Box>
          </LabeledList.Item>
        )}
      </LabeledList>
      <Divider />
      <Stack fill>
        <Stack.Item mt={0.15}>
          <Button
            icon="compact-disc"
            tooltip="Export chat settings"
            onClick={() => dispatch(exportSettings())}
          >
            Export settings
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.File
            accept=".json"
            tooltip="Import chat settings"
            icon="arrow-up-from-bracket"
            onSelectFiles={(files) => importChatSettings(files)}
          >
            Import settings
          </Button.File>
        </Stack.Item>
        <Stack.Item grow mt={0.15}>
          <Button
            icon="save"
            tooltip="Export current tab history into HTML file"
            onClick={() => dispatch(saveChatToDisk())}
          >
            Save chat log
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.Confirm
            icon="trash"
            tooltip="Erase current tab history"
            onClick={() => dispatch(clearChat())}
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
                dispatch(purgeChatMessageArchive());
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
