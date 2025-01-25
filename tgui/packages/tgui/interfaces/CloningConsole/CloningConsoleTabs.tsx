import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Image,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { Data } from './types';

export const CloningConsoleMain = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    loading,
    scantemp,
    occupant,
    locked,
    can_brainscan,
    scan_mode,
    numberofpods,
    pods,
    selected_pod,
  } = data;
  const isLocked = locked && !!occupant;
  return (
    <>
      <Section
        title="Scanner"
        buttons={
          <>
            <Box inline color="label">
              Scanner Lock:&nbsp;
            </Box>
            <Button
              disabled={!occupant}
              selected={isLocked}
              icon={isLocked ? 'toggle-on' : 'toggle-off'}
              onClick={() => act('lock')}
            >
              {isLocked ? 'Engaged' : 'Disengaged'}
            </Button>
            <Button
              disabled={isLocked || !occupant}
              icon="user-slash"
              onClick={() => act('eject')}
            >
              Eject Occupant
            </Button>
          </>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Status">
            {loading ? (
              <Box color="average">
                <Icon name="spinner" spin />
                &nbsp; Scanning...
              </Box>
            ) : (
              <Box color={scantemp.color}>{scantemp.text}</Box>
            )}
          </LabeledList.Item>
          {!!can_brainscan && (
            <LabeledList.Item label="Scan Mode">
              <Button
                icon={scan_mode ? 'brain' : 'male'}
                onClick={() => act('toggle_mode')}
              >
                {scan_mode ? 'Brain' : 'Body'}
              </Button>
            </LabeledList.Item>
          )}
        </LabeledList>
        <Button
          disabled={!occupant || loading}
          icon="user"
          mt="0.5rem"
          mb="0"
          onClick={() => act('scan')}
        >
          Scan Occupant
        </Button>
      </Section>
      <Section title="Pods">
        {numberofpods ? (
          pods.map((pod, i) => {
            let podAction;
            if (pod.status === 'cloning') {
              podAction = (
                <ProgressBar
                  minValue={0}
                  maxValue={1}
                  value={pod.progress / 100}
                  ranges={{
                    good: [0.75, Infinity],
                    average: [0.25, 0.75],
                    bad: [-Infinity, 0.25],
                  }}
                  mt="0.5rem"
                >
                  <Box textAlign="center">{toFixed(pod.progress) + '%'}</Box>
                </ProgressBar>
              );
            } else if (pod.status === 'mess') {
              podAction = (
                <Box bold color="bad" mt="0.5rem">
                  ERROR
                </Box>
              );
            } else {
              podAction = (
                <Button
                  selected={selected_pod === pod.pod}
                  icon={selected_pod === pod.pod && 'check'}
                  mt="0.5rem"
                  onClick={() =>
                    act('selectpod', {
                      ref: pod.pod,
                    })
                  }
                >
                  Select
                </Button>
              );
            }

            return (
              <Box key={i} width="64px" textAlign="center" inline mr="0.5rem">
                <Image
                  fixBlur
                  src={resolveAsset('pod_' + pod.status + '.gif')}
                  style={{
                    width: '100%',
                  }}
                />
                <Box color="label">Pod #{i + 1}</Box>
                <Box bold color={pod.biomass >= 150 ? 'good' : 'bad'} inline>
                  <Icon name={pod.biomass >= 150 ? 'circle' : 'circle-o'} />
                  &nbsp;
                  {pod.biomass}
                </Box>
                {podAction}
              </Box>
            );
          })
        ) : (
          <Box color="bad">No pods detected. Unable to clone.</Box>
        )}
      </Section>
    </>
  );
};

export const CloningConsoleRecords = (props) => {
  const { act, data } = useBackend<Data>();
  const { records } = data;
  if (!records.length) {
    return (
      <Stack height="100%">
        <Stack.Item grow align="center" textAlign="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No records found.
        </Stack.Item>
      </Stack>
    );
  }
  return (
    <Box mt="0.5rem">
      {records.map((record, i) => (
        <Button
          key={i}
          icon="user"
          mb="0.5rem"
          onClick={() =>
            act('view_rec', {
              ref: record.record,
            })
          }
        >
          {record.realname}
        </Button>
      ))}
    </Box>
  );
};
