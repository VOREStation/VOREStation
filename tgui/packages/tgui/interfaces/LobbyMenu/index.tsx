import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

export const LobbyMenu = (props) => {
  const { act, data } = useBackend();

  return (
    <Window fitted scrollbars={false}>
      <Window.Content>Meow</Window.Content>
    </Window>
  );
};
