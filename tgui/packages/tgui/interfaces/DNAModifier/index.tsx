import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';

import { ComplexModal } from '../common/ComplexModal';
import { DNAModifierIrradiating } from './DNAModifierIrradiating';
import { DNAModifierMain } from './DNAModifierMain';
import { DNAModifierOccupant } from './DNAModifierOccupant';
import type { Data } from './types';

export const DNAModifier = (props) => {
  const { data } = useBackend<Data>();

  const { irradiating, occupant } = data;

  return (
    <Window width={660} height={870}>
      <ComplexModal />
      {irradiating ? <DNAModifierIrradiating duration={irradiating} /> : ''}
      <Window.Content className="Layout__content--flexColumn">
        <Stack vertical fill>
          <Stack.Item>
            <DNAModifierOccupant
              isDNAInvalid={
                !occupant.isViableSubject ||
                !occupant.uniqueIdentity ||
                !occupant.structuralEnzymes
              }
            />
          </Stack.Item>
          <Stack.Item grow>
            <DNAModifierMain
              isDNAInvalid={
                !occupant.isViableSubject ||
                !occupant.uniqueIdentity ||
                !occupant.structuralEnzymes
              }
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
