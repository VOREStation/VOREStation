import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  bought: { id: string; name: string; on: BooleanLike }[];
  not_bought: { id: string; name: string; ram: number }[];
  available_ram: number;
  emotions: { id: string; name: string }[];
  current_emotion: string;
};

export const pAIInterface = (props) => {
  const { act, data } = useBackend<Data>();

  const { bought, not_bought, available_ram, emotions, current_emotion } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content scrollable>
        <Section title="Emotion">
          {emotions.map((emote) => (
            <Button
              key={emote.id}
              selected={emote.id === current_emotion}
              onClick={() => act('image', { image: emote.id })}
            >
              {emote.name}
            </Button>
          ))}
        </Section>
        <Section title={'Software (Available RAM: ' + available_ram + ')'}>
          <LabeledList>
            <LabeledList.Item label="Installed">
              {bought.map((app) => (
                <Button
                  key={app.id}
                  selected={app.on}
                  onClick={() => act('software', { software: app.id })}
                >
                  {app.name}
                </Button>
              ))}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Downloadable">
              {not_bought.map((app) => (
                <Button
                  key={app.id}
                  disabled={app.ram > available_ram}
                  onClick={() => act('purchase', { purchase: app.id })}
                >
                  {app.name + ' (' + app.ram + ')'}
                </Button>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
