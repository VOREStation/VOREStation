import { Window } from 'tgui/layouts';

import { RCONContent } from './RCONContent';

export const RCON = (props) => {
  return (
    <Window width={630} height={540}>
      <Window.Content scrollable>
        <RCONContent />
      </Window.Content>
    </Window>
  );
};
