import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { BeakerContents } from '../common/BeakerContents';
import { modalOpen } from '../common/ComplexModal';
import { transferAmounts } from './constants';
import type { reagent } from './types';

export const ChemMasterBeaker = (props: {
  beaker: BooleanLike;
  beakerReagents: reagent[];
  bufferNonEmpty: BooleanLike;
}) => {
  const { act } = useBackend();
  const { beaker, beakerReagents, bufferNonEmpty } = props;

  const headerButton = bufferNonEmpty ? (
    <Button.Confirm
      icon="eject"
      disabled={!beaker}
      onClick={() => act('eject')}
    >
      Eject and Clear Buffer
    </Button.Confirm>
  ) : (
    <Button icon="eject" disabled={!beaker} onClick={() => act('eject')}>
      Eject and Clear Buffer
    </Button>
  );

  return (
    <Section title="Beaker" buttons={headerButton}>
      {beaker ? (
        <BeakerContents
          beakerLoaded
          beakerContents={beakerReagents}
          buttons={(chemical: reagent, i: number) => (
            <Box mb={i < beakerReagents.length - 1 && '2px'}>
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
              {transferAmounts.map((am, j) => (
                <Button
                  key={j}
                  mb="0"
                  onClick={() =>
                    act('add', {
                      id: chemical.id,
                      amount: am,
                    })
                  }
                >
                  {am}
                </Button>
              ))}
              <Button
                mb="0"
                onClick={() =>
                  act('add', {
                    id: chemical.id,
                    amount: chemical.volume,
                  })
                }
              >
                All
              </Button>
              <Button
                mb="0"
                onClick={() =>
                  modalOpen('addcustom', {
                    id: chemical.id,
                  })
                }
              >
                Custom..
              </Button>
            </Box>
          )}
        />
      ) : (
        <Box color="label">No beaker loaded.</Box>
      )}
    </Section>
  );
};
