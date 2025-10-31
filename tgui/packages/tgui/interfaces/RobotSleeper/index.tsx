import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { CargoCompartment } from './SubElements/CargoCompartment';
import { InjectorPanel } from './SubElements/InjectorPanel';
import { SleeperStatus } from './SubElements/SleeperStatus';
import type { Data } from './types';

export const RobotSleeper = (props) => {
  const { data } = useBackend<Data>();

  const { theme, chems, delivery, name } = data;
  return (
    <Window width={450} height={500} theme={theme || 'ntos'}>
      <Window.Content>
        <Stack vertical fill>
          {!!chems && (
            <Stack.Item>
              <InjectorPanel robotChems={chems} />
            </Stack.Item>
          )}
          {!!delivery && (
            <Stack.Item>
              <CargoCompartment />
            </Stack.Item>
          )}
          <Stack.Item grow>
            <SleeperStatus name={name ?? 'Unknown'} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
