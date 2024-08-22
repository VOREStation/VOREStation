import { useBackend } from '../../backend';
import { Box, Button, Flex, ProgressBar, Section } from '../../components';
import { formatMoney } from '../../format';
import { COLOR_KEYS } from './constants';
import { MaterialAmount } from './Material';
import { Data } from './types';

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
    <Flex height="100%" width="100%" direction="column">
      <Flex.Item height={0} grow={1}>
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
          <Flex direction="column" height="100%">
            <Flex.Item>
              <BeingBuilt />
            </Flex.Item>
            <Flex.Item>
              <QueueList textColors={textColors} />
            </Flex.Item>
          </Flex>
        </Section>
      </Flex.Item>
      {!disabled && (
        <Flex.Item mt={1}>
          <Section title="Material Cost">
            <QueueMaterials
              queueMaterials={queueMaterials}
              missingMaterials={missingMaterials}
            />
          </Section>
        </Flex.Item>
      )}
    </Flex>
  );
};

const QueueMaterials = (props: {
  queueMaterials: Record<string, number>;
  missingMaterials: Record<string, number>;
}) => {
  const { queueMaterials, missingMaterials } = props;

  return (
    <Flex wrap="wrap">
      {Object.keys(queueMaterials).map((material) => (
        <Flex.Item width="12%" key={material}>
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
        </Flex.Item>
      ))}
    </Flex>
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
    <Box key={part.name}>
      <Flex
        mb={0.5}
        direction="column"
        justify="center"
        wrap="wrap"
        height="20px"
        inline
      >
        <Flex.Item basis="content">
          <Button
            height="20px"
            mr={1}
            icon="minus-circle"
            color="bad"
            onClick={() => act('del_queue_part', { index: index + 1 })}
          />
        </Flex.Item>
        <Flex.Item>
          <Box inline textColor={COLOR_KEYS[textColors[index]]}>
            {part.name}
          </Box>
        </Flex.Item>
      </Flex>
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
          <Flex>
            <Flex.Item>{storedPart}</Flex.Item>
            <Flex.Item grow={1} />
            <Flex.Item>{'Fabricator outlet obstructed...'}</Flex.Item>
          </Flex>
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
          <Flex>
            <Flex.Item>{name}</Flex.Item>
            <Flex.Item grow={1} />
            <Flex.Item>
              {(timeLeft >= 0 && timeLeft + 's') || 'Dispensing...'}
            </Flex.Item>
          </Flex>
        </ProgressBar>
      </Box>
    );
  }
};
