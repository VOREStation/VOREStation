import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

import { ComplexModal } from '../common/ComplexModal';
import { DNAModifierIrradiating } from './DNAModifierIrradiating';
import { DNAModifierMain } from './DNAModifierMain';
import { DNAModifierOccupant } from './DNAModifierOccupant';
import { Data } from './types';

export const DNAModifier = (props) => {
  const { data } = useBackend<Data>();

  const { irradiating, occupant } = data;

  const isDNAInvalid: boolean =
    !occupant.isViableSubject ||
    !occupant.uniqueIdentity ||
    !occupant.structuralEnzymes;

  return (
    <Window width={660} height={870}>
      <ComplexModal />
      {irradiating && <DNAModifierIrradiating duration={irradiating} />}
      <Window.Content className="Layout__content--flexColumn">
        <DNAModifierOccupant isDNAInvalid={isDNAInvalid} />
        <DNAModifierMain isDNAInvalid={isDNAInvalid} />
      </Window.Content>
    </Window>
  );
};
