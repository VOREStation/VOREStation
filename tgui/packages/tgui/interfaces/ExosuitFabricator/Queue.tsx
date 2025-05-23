import { useBackend } from 'tgui/backend';
import { Box, Button, ProgressBar, Section, Stack } from 'tgui-core/components';
import { formatMoney } from 'tgui-core/format';

import { COLOR_KEYS } from './constants';
import { MaterialAmount } from './Material';
import type { Data } from './types';

export const Queue = (props: {
  queueMaterials: Record<string, number>;
  missingMaterials: Record<string, number>;
  textColors: Record<number, number>;
}) => {
  const { act, data } = useBackend<Data>();

  const { isProcessingQueue, queue = [] } = data;

  const { queueMaterials, missingMaterials, textColors } = props;

  const disabled: boolean = !queue || !queue.length;

  return (
    <Stack height="100%" width="100%" vertical>
      <Stack.Item height={0} grow>
        <Section
          height="100%"
          title="Queue"
          overflowY="auto"
          buttons={
            <>
              <Button.Confirm
                disabled={disabled}
                color="bad"
                icon="minus-circle"
                onClick={() => act('clear_queue')}
              >
                Clear Queue
              </Button.Confirm>
              {(!!isProcessingQueue && (
                <Button
                  disabled={disabled}
                  icon="stop"
                  onClick={() => act('stop_queue')}
                >
                  Stop
                </Button>
              )) || (
                <Button
                  disabled={disabled}
                  icon="play"
                  onClick={() => act('build_queue')}
                >
                  Build Queue
                </Button>
              )}
            </>
          }
        >
          <Stack vertical height="100%">
            <Stack.Item>
              <BeingBuilt />
            </Stack.Item>
            <Stack.Item>
              <QueueList textColors={textColors} />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      {!disabled && (
        <Stack.Item mt={1}>
          <Section title="Material Cost">
            <QueueMaterials
              queueMaterials={queueMaterials}
              missingMaterials={missingMaterials}
            />
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

const QueueMaterials = (props: {
  queueMaterials: Record<string, number>;
  missingMaterials: Record<string, number>;
}) => {
  const { queueMaterials, missingMaterials } = props;

  return (
    <Stack wrap="wrap">
      {Object.keys(queueMaterials).map((material) => (
        <Stack.Item width="12%" key={material}>
          <MaterialAmount
            formatmoney
            name={material}
            amount={queueMaterials[material]}
          />
          {!!missingMaterials[material] && (
            <Box textColor="bad" style={{ textAlign: 'center' }}>
              {formatMoney(missingMaterials[material])}
            </Box>
          )}
        </Stack.Item>
      ))}
    </Stack>
  );
};

const QueueList = (props: { textColors: Record<number, number> }) => {
  const { act, data } = useBackend<Data>();

  const { textColors } = props;

  const { queue = [] } = data;

  if (!queue || !queue.length) {
    return <>No parts in queue.</>;
  }

  return queue.map((part, index) => (
    <Box key={index}>
      <Stack mb={0.5} vertical justify="center" wrap="wrap" height="20px">
        <Stack.Item basis="content">
          <Button
            height="20px"
            mr={1}
            icon="minus-circle"
            color="bad"
            onClick={() => act('del_queue_part', { index: index + 1 })}
          />
        </Stack.Item>
        <Stack.Item>
          <Box inline textColor={COLOR_KEYS[textColors[index]]}>
            {part.name}
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  ));
};

const BeingBuilt = (props) => {
  const { data } = useBackend<Data>();

  const { buildingPart, storedPart } = data;

  if (storedPart) {
    return (
      <Box>
        <ProgressBar minValue={0} maxValue={1} value={1} color="average">
          <Stack>
            <Stack.Item>{storedPart}</Stack.Item>
            <Stack.Item grow />
            <Stack.Item>{'Fabricator outlet obstructed...'}</Stack.Item>
          </Stack>
        </ProgressBar>
      </Box>
    );
  }

  if (buildingPart) {
    const { name, duration, printTime } = buildingPart;

    const timeLeft = Math.ceil(duration / 10);

    return (
      <Box>
        <ProgressBar minValue={0} maxValue={printTime} value={duration}>
          <Stack>
            <Stack.Item>{name}</Stack.Item>
            <Stack.Item grow />
            <Stack.Item>
              {(timeLeft >= 0 && timeLeft + 's') || 'Dispensing...'}
            </Stack.Item>
          </Stack>
        </ProgressBar>
      </Box>
    );
  }
};
