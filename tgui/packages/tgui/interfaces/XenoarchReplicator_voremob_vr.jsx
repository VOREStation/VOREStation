import { useBackend } from '../backend';
import { Button } from '../components';
import { Window } from '../layouts';

export const XenoarchReplicator_voremob_vr = (props) => {
  const { act, data } = useBackend();

  const { tgui_construction } = data;

  return (
    <Window theme="abductor" width={400} height={400} resizable>
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
