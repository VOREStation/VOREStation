import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { BeakerContents } from '../common/BeakerContents';
import { modalOpen } from '../common/ComplexModal';
import { transferAmounts } from './constants';
import type { reagent } from './types';

export const ChemMasterBuffer = (props: {
  mode: BooleanLike;
  bufferReagents: reagent[];
}) => {
  const { act } = useBackend();
  const { mode, bufferReagents = [] } = props;
  return (
    <Section
      title="Buffer"
      buttons={
        <Box color="label">
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
      {bufferReagents.length > 0 ? (
        <BeakerContents
          beakerLoaded
          beakerContents={bufferReagents}
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
      ) : (
        <Box color="label">Buffer is empty.</Box>
      )}
    </Section>
  );
};
