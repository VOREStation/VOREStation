import 'tgui/styles/interfaces/CommandlineTerminal.scss';

import { Button, LabeledList } from 'tgui-core/components';

import { useBackend } from '../../backend';

export const MacroEntry = (props: { command: string; name: string }) => {
  const { command, name } = props;
  const { act } = useBackend();
  return (
    <LabeledList.Item
      label={name}
      buttons={
        <Button
          className="commandline_macroButton"
          tooltip={`Execute command: ${command}`}
          onClick={() => act('sendCommand', { command: command })}
        >
          Execute
        </Button>
      }
      className="commandline_macroEntry"
    >
      {command}
    </LabeledList.Item>
  );
};
