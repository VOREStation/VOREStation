import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import {
  ShuttleControlConsoleDefault,
  ShuttleControlConsoleExploration,
  ShuttleControlConsoleMulti,
} from './ShuttleControlConsoleTypes';
import { ShuttleControlConsoleWeb } from './ShuttleControlConsoleWeb';
import { Data } from './types';

export const ShuttleControl = (props) => {
  const { data } = useBackend<Data>();
  const { subtemplate, destination_name } = data;
  return (
    <Window
      width={470}
      height={subtemplate === 'ShuttleControlConsoleWeb' ? 560 : 370}
    >
      <Window.Content>
        {(subtemplate === 'ShuttleControlConsoleDefault' && (
          <ShuttleControlConsoleDefault />
        )) ||
          (subtemplate === 'ShuttleControlConsoleMulti' && (
            <ShuttleControlConsoleMulti destination_name={destination_name!} />
          )) ||
          (subtemplate === 'ShuttleControlConsoleExploration' && (
            <ShuttleControlConsoleExploration />
          )) ||
          (subtemplate === 'ShuttleControlConsoleWeb' && (
            <ShuttleControlConsoleWeb />
          ))}
      </Window.Content>
    </Window>
  );
};
