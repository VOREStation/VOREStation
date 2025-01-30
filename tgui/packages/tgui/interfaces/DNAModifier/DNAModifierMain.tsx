import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  Knob,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { operations, rejuvenatorsDoses } from './constants';
import { DNAModifierBlocks } from './DNAModifierBlocks';
import { DNAModifierMainBuffers } from './DNAModifierMainBuffers';
import { Data } from './types';

export const DNAModifierMain = (props /* : {isDNAInvalid: BooleanLike} */) => {
  /* Traitgenes Allow accessing menus while no occupant is inside */
  const { act, data } = useBackend<Data>();

  const { selectedMenuKey, hasOccupant } = data;

  if (!hasOccupant) {
    return (
      <Section flexGrow>
        <Stack height="100%">
          <Stack.Item grow align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size={5} />
            <br />
            No occupant in DNA modifier.
          </Stack.Item>
        </Stack>
      </Section>
    );
  } else if (props.isDNAInvalid) {
    return (
      <Section flexGrow>
        <Stack height="100%">
          <Stack.Item grow align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size={5} />
            <br />
            No operation possible on this subject.
          </Stack.Item>
        </Stack>
      </Section>
    );
  }
  let body;
  if (selectedMenuKey === 'se') {
    body = (
      <>
        <DNAModifierMainSE />
        <DNAModifierMainRadiationEmitter />
      </>
    );
  } else if (selectedMenuKey === 'buffer') {
    body = <DNAModifierMainBuffers />;
  } else if (selectedMenuKey === 'rejuvenators') {
    body = <DNAModifierMainRejuvenators />;
  }
  return (
    <Section flexGrow>
      <Tabs>
        {operations.map((op, i) => (
          <Tabs.Tab
            key={i}
            selected={selectedMenuKey === op[0]}
            onClick={() => act('selectMenuKey', { key: op[0] })}
          >
            <Icon name={op[2]} />
            {op[1]}
          </Tabs.Tab>
        ))}
      </Tabs>
      {body}
    </Section>
  );
};

const DNAModifierMainSE = (props) => {
  const { act, data } = useBackend<Data>();

  const { selectedSEBlock, selectedSESubBlock, dnaBlockSize, occupant } = data;

  return (
    // Traitgenes Allow accessing menus while no occupant is inside
    !occupant ? (
      <Section flexGrow>
        <Flex height="100%">
          <Flex.Item grow="1" align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size={5} />
            <br />
            No occupant in DNA modifier.
          </Flex.Item>
        </Flex>
      </Section>
    ) : !occupant.isViableSubject ? (
      <Section flexGrow>
        <Flex height="100%">
          <Flex.Item grow="1" align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size={5} />
            <br />
            No operation possible on this subject.
          </Flex.Item>
        </Flex>
      </Section>
    ) : (
      <Section title="Modify Structural Enzymes">
        <DNAModifierBlocks
          dnaString={occupant.structuralEnzymes || ''}
          selectedBlock={selectedSEBlock}
          selectedSubblock={selectedSESubBlock}
          blockSize={dnaBlockSize}
          action="selectSEBlock"
        />
        <Button icon="radiation" onClick={() => act('pulseSERadiation')}>
          Irradiate Block
        </Button>
      </Section>
    )
  );
};

const DNAModifierMainRadiationEmitter = (props) => {
  const { act, data } = useBackend<Data>();

  const { radiationIntensity, radiationDuration, occupant } = data; // Traitgenes Allow accessing menus while no occupant is inside

  return (
    // Traitgenes Allow accessing menus while no occupant is inside
    occupant && occupant.isViableSubject ? ( // Traitgenes Allow accessing menus while no occupant is inside
      <Section title="Radiation Emitter">
        <LabeledList>
          <LabeledList.Item label="Intensity">
            <Knob
              minValue={1}
              maxValue={10}
              stepPixelSize={20}
              value={radiationIntensity}
              ml="0"
              onChange={(e, val) => act('radiationIntensity', { value: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Duration">
            <Knob
              minValue={1}
              maxValue={20}
              stepPixelSize={10}
              unit="s"
              value={radiationDuration}
              ml="0"
              onChange={(e, val) => act('radiationDuration', { value: val })}
            />
          </LabeledList.Item>
        </LabeledList>
        <Button
          icon="radiation"
          tooltip="Mutates a random block of DNA." // Traitgenes Body design console is used to edit UIs now. Not this.
          tooltipPosition="top"
          mt="0.5rem"
          onClick={() => act('pulseRadiation')}
        >
          Pulse Radiation
        </Button>
      </Section>
    ) : (
      ''
    )
  );
};

const DNAModifierMainRejuvenators = (props) => {
  const { act, data } = useBackend<Data>();

  const { isBeakerLoaded, beakerVolume, beakerLabel, hasOccupant } = data; // Traitgenes Allow accessing menus while no occupant is inside

  return (
    <Section
      title="Rejuvenators and Beaker"
      buttons={
        <Button
          disabled={!isBeakerLoaded}
          icon="eject"
          onClick={() => act('ejectBeaker')}
        >
          Eject
        </Button>
      }
    >
      {isBeakerLoaded ? (
        <LabeledList>
          <LabeledList.Item label="Inject">
            {rejuvenatorsDoses.map((a, i) => (
              <Button
                key={i}
                disabled={a > beakerVolume || !hasOccupant} // Traitgenes Allow accessing menus while no occupant is inside
                icon="syringe"
                onClick={() =>
                  act('injectRejuvenators', {
                    amount: a,
                  })
                }
              >
                {a}
              </Button>
            ))}
            <Button
              disabled={beakerVolume <= 0 || !hasOccupant} // Traitgenes Allow accessing menus while no occupant is inside
              icon="syringe"
              onClick={() =>
                act('injectRejuvenators', {
                  amount: beakerVolume,
                })
              }
            >
              All
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Beaker">
            <Box mb="0.5rem">{beakerLabel ? beakerLabel : 'No label'}</Box>
            {beakerVolume ? (
              <Box color="good">
                {beakerVolume} unit{beakerVolume === 1 ? '' : 's'} remaining
              </Box>
            ) : (
              <Box color="bad">Empty</Box>
            )}
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <Box color="label" textAlign="center" my="25%">
          <Icon name="exclamation-triangle" size={4} />
          <br />
          No beaker loaded.
        </Box>
      )}
    </Section>
  );
};
