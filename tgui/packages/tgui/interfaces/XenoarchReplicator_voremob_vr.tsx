import { useBackend } from '../backend';
import { Button } from '../components';
import { Window } from '../layouts';
import { tgui_construction } from './common/CommonTypes';

type Data = {
  tgui_construction: tgui_construction;
};

export const XenoarchReplicator_voremob_vr = (props) => {
  const { act, data } = useBackend<Data>();

  const { tgui_construction } = data;

  return (
    <Window theme="abductor" width={400} height={400}>
      <Window.Content scrollable>
        {tgui_construction.map((button, i) => (
          <Button
            key={button.key}
            color={button.background}
            icon={button.icon}
            iconColor={button.foreground}
            fontSize={4}
            onClick={() => act('construct', { key: button.key })}
          />
        ))}
      </Window.Content>
    </Window>
  );
};
