import { Window } from 'tgui/layouts';

import { CryoContent } from './CryoContent';

export const Cryo = (props) => {
  return (
    <Window width={520} height={470}>
      <Window.Content className="Layout__content--flexColumn">
        <CryoContent />
      </Window.Content>
    </Window>
  );
};
