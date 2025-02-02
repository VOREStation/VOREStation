import { Window } from 'tgui/layouts';

import { CommunicationsConsoleContent } from './CommunicationsConsoleContent';

export const CommunicationsConsole = (props) => {
  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <CommunicationsConsoleContent />
      </Window.Content>
    </Window>
  );
};
