import { toFixed } from 'common/math';
import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Flex,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui/components';

import { purgeChatMessageArchive, saveChatToDisk } from '../../chat/actions';
import { MESSAGE_TYPES } from '../../chat/constants';
import { useGame } from '../../game';
import { updateSettings, updateToggle } from '../actions';
import { selectSettings } from '../selectors';

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
  const [purgeConfirm, setPurgeConfirm] = useState(0);
  const [logConfirm, setLogConfirm] = useState(false);
  return (
    <Section>
      <Flex align="baseline">
        {logEnable ? (
          logConfirm ? (
            <Button
              icon="ban"
              color="red"
              onClick={() => {
                dispatch(
                  updateSettings({
                    logEnable: false,
                  }),
                );
                setLogConfirm(false);
              }}
            >
              Disable?
            </Button>
          ) : (
            <Button
              icon="ban"
              color="red"
              onClick={() => {
                setLogConfirm(true);
                setTimeout(() => {
                  setLogConfirm(false);
                }, 5000);
              }}
            >
              Disable logging
            </Button>
          )
        ) : (
          <Button
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
        )}
        <Flex.Item grow={1} />
        <Flex.Item color="label">Round ID:&nbsp;</Flex.Item>
        <Flex.Item color={game.roundId ? '' : 'red'}>
          {game.roundId ? game.roundId : 'ERROR'}
        </Flex.Item>
      </Flex>
      {logEnable ? (
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
              {logRetainRounds > 3 ? (
                <Box inline fontSize="0.9em" color="red">
                  Warning, might crash!
                </Box>
              ) : (
                ''
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
              {logLimit > 0 ? (
                <Box
                  inline
                  fontSize="0.9em"
                  color={logLimit > 10000 ? 'red' : 'label'}
                >
                  {logLimit > 15000
                    ? 'Warning, might crash! Takes priority above round retention.'
                    : 'Takes priority above round retention.'}
                </Box>
              ) : (
                ''
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
      ) : (
        ''
      )}
      <LabeledList>
        <LabeledList.Item label="Export round start (0 = curr.) / end (0 = dis.)">
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
          &nbsp;
          <Box inline fontSize="0.9em" color="label">
            Stored Rounds:&nbsp;
          </Box>
          <Box inline>{storedRounds}</Box>
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
        <LabeledList.Item label="Totally stored messages">
          <Box>{totalStoredMessages}</Box>
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Button icon="save" onClick={() => dispatch(saveChatToDisk())}>
        Save chat log
      </Button>
      {purgeConfirm > 0 ? (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            dispatch(purgeChatMessageArchive());
            setPurgeConfirm(2);
          }}
        >
          {purgeConfirm > 1 ? 'Purged!' : 'Are you sure?'}
        </Button>
      ) : (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            setPurgeConfirm(1);
            setTimeout(() => {
              setPurgeConfirm(0);
            }, 5000);
          }}
        >
          Purge message archive
        </Button>
      )}
    </Section>
  );
};
