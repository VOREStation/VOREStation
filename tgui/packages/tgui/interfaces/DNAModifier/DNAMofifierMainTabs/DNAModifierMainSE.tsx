import { useBackend } from 'tgui/backend';
import { Icon, Section, Stack } from 'tgui-core/components';

import { DNAModifierBlocks } from '../DNAModifierBlocks';
import type { Data } from '../types';
import { DNAModifierMainRadiationEmitter } from './DNAModifierMainRadiationEmitter';

export const DNAModifierMainSE = (props) => {
  return (
    <Stack vertical fill>
      <Stack.Item grow>
        <DNAModifierMainBlocks />
      </Stack.Item>
      <Stack.Item minHeight="140px">
        <DNAModifierMainRadiationEmitter />
      </Stack.Item>
    </Stack>
  );
};

const DNAModifierMainBlocks = (props) => {
  const { act, data } = useBackend<Data>();

  const { selectedSEBlock, selectedSESubBlock, dnaBlockSize, occupant } = data;

  return !occupant ? (
    <Section fill scrollable>
      <Stack fill>
        <Stack.Item grow align="center" textAlign="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No occupant in DNA modifier.
        </Stack.Item>
      </Stack>
    </Section>
  ) : !occupant.isViableSubject ? (
    <Section fill>
      <Stack fill>
        <Stack.Item grow align="center" textAlign="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No operation possible on this subject.
        </Stack.Item>
      </Stack>
    </Section>
  ) : (
    <Section scrollable fill title="Modify Structural Enzymes">
      <DNAModifierBlocks
        dnaString={occupant.structuralEnzymes || ''}
        selectedBlock={selectedSEBlock}
        selectedSubblock={selectedSESubBlock}
        blockSize={dnaBlockSize}
        action="selectSEBlock"
      />
    </Section>
  );
};
