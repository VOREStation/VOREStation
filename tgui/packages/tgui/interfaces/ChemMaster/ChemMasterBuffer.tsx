import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { BufferContents } from '../common/BufferContents';
import { modalOpen } from '../common/ComplexModal';
import { transferAmounts } from './constants';
import type { Data, reagent } from './types';

export const ChemMasterBuffer = (props: {
  beaker: BooleanLike;
  mode: BooleanLike;
  beakerReagents: reagent[];
  bufferReagents: reagent[];
}) => {
  const { act } = useBackend();
  const { data } = useBackend<Data>();
  const { mode, bufferReagents = [] } = props;
  const { beaker} = data;
  return (
    <Section
      title="Buffer"
      buttons={
        <Box color="label" inline>
          Transferring to&nbsp;
          <Button
            icon={mode ? 'flask' : 'trash'}
            color={!mode && 'bad'}
            onClick={() => act('toggle')}
          >
            {mode ? 'Beaker' : 'Disposal'}
          </Button>
        </Box>
      }
    >
      {beaker ? (
        <BufferContents
          beakerLoaded
          bufferContents={bufferReagents}
          buttons={(chemical, i) => (
            <Stack mb={i < bufferReagents.length - 1 && '2px'}>
              <Stack.Item>
                <Button
                  mb="0"
                  onClick={() =>
                    modalOpen('analyze', {
                      idx: i + 1,
                      beaker: 1,
                    })
                  }
                >
                  Analyze
                </Button>
              </Stack.Item>
              {transferAmounts.map((am, i) => (
                <Stack.Item key={i}>
                  <Button
                    mb="0"
                    onClick={() =>
                      act('remove', {
                        id: chemical.id,
                        amount: am,
                      })
                    }
                  >
                    {am}
                  </Button>
                </Stack.Item>
              ))}
              <Stack.Item>
                <Button
                  mb="0"
                  onClick={() =>
                    act('remove', {
                      id: chemical.id,
                      amount: chemical.volume,
                    })
                  }
                >
                  All
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  mb="0"
                  onClick={() =>
                    modalOpen('removecustom', {
                      id: chemical.id,
                    })
                  }
                >
                  Custom...
                </Button>
              </Stack.Item>
            </Stack>
          )}
        />
      ) : bufferReagents.length > 0 ? (
        <BufferContents
          bufferContents={bufferReagents}
          buttons={(chemical, i) => (
            <Stack mb={i < bufferReagents.length - 1 && '2px'}>
              <Stack.Item>
                <Button
                  mb="0"
                  onClick={() =>
                    modalOpen('analyze', {
                      idx: i + 1,
                      beaker: 0,
                    })
                  }
                >
                  Analyze
                </Button>
              </Stack.Item>
              {transferAmounts.map((am, j) => (
                <Stack.Item key={j}>
                  <Button
                    mb="0"
                    onClick={() =>
                      act('remove', {
                        id: chemical.id,
                        amount: am,
                      })
                    }
                  >
                    {am}
                  </Button>
                </Stack.Item>
              ))}
              <Stack.Item>
                <Button
                  mb="0"
                  onClick={() =>
                    act('remove', {
                      id: chemical.id,
                      amount: chemical.volume,
                    })
                  }
                >
                  All
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  mb="0"
                  onClick={() =>
                    modalOpen('removecustom', {
                      id: chemical.id,
                    })
                  }
                >
                  Custom...
                </Button>
              </Stack.Item>
            </Stack>
          )}
        />
      ) : (
        <Box color="label">The buffer is empty.</Box>
      )}
    </Section>
  );
};
