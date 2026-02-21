import { Window } from 'tgui/layouts';

import { RCONContent } from './RCONContent';

export const RCON = (props) => {
  return (
    <Window width={630} height={600}>
      <Window.Content>
        <RCONContent />
      </Window.Content>
    </Window>
  );
};
