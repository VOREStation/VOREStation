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

  return (
    <Window width={660} height={870}>
      <ComplexModal />
      {irradiating ? (
        <DNAModifierIrradiating duration={irradiating} />
      ) : (
        ''
      )}{' '}
      {/* Traitgenes edit - Fixed irradiating overlay showing 0 at top of menu when hidden */}
      <Window.Content className="Layout__content--flexColumn">
        <DNAModifierOccupant
          isDNAInvalid={
            !occupant.isViableSubject ||
            !occupant.uniqueIdentity ||
            !occupant.structuralEnzymes
          }
        />{' '}
        {/* Traitgenes Fixed irradiating overlay showing 0 at top of menu when hidden */}
        <DNAModifierMain
          isDNAInvalid={
            !occupant.isViableSubject ||
            !occupant.uniqueIdentity ||
            !occupant.structuralEnzymes
          }
        />{' '}
        {/* Traitgenes Fixed irradiating overlay showing 0 at top of menu when hidden */}
      </Window.Content>
    </Window>
  );
};
