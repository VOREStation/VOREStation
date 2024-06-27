import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { BodyScannerEmpty } from './BodyScannerEmpty';
import { BodyScannerMain } from './BodyScannerMain';
import { Data, occupant } from './types';

export const BodyScanner = (props) => {
  const { data } = useBackend<Data>();
  const { occupied, occupant = {} as occupant } = data;
  const body = occupied ? (
    <BodyScannerMain occupant={occupant} />
  ) : (
    <BodyScannerEmpty />
  );
  return (
    <Window width={690} height={600}>
      <Window.Content scrollable className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};
6;
