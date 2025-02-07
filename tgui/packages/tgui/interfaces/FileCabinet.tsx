import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section } from 'tgui-core/components';

type Data = { contents: content[] };

type content = { name: string; ref: string };

export const FileCabinet = (props) => {
  const { act, data } = useBackend<Data>();

  const { contents } = data;

  // Wow, the filing cabinets sort themselves in 2320.
  contents.sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Window width={350} height={300}>
      <Window.Content scrollable>
        <Section>
          {contents.map((item) => (
            <Button
              key={item.ref}
              fluid
              icon="file"
              onClick={() => act('retrieve', { ref: item.ref })}
            >
              {item.name}
            </Button>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
