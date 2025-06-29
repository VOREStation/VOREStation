import { useState } from 'react';
import { Window } from 'tgui/layouts';

import { TextInputModal } from '../TextInputModal';

export const CommandlineTerminal = () => {
  const [tabIndex, setTabIndex] = useState<number>(0);
  const [zoom, setZoom] = useState<number>(1);

  function handleTabIndex(value: number) {
    setTabIndex(value);
  }

  function handleZoom(value: number) {
    setZoom(value);
  }

  return (
    <Window width={850} height={600}>
      <Window.Content>test hecko :D</Window.Content>
      <TextInputModal
        max_length={100}
        message="This is a test message for the command line terminal."
        multiline={false}
        placeholder="Type your command here..."
        timeout={30}
        title="Command Line Terminal"
        onType={(value) => console.log(value)}
      />
    </Window>
  );
};
