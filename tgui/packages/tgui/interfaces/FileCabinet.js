import { sortBy } from 'common/collections';
import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

export const FileCabinet = (props, context) => {
  const { act, data } = useBackend(context);

  const { contents } = data;

  // Wow, the filing cabinets sort themselves in 2320.
  const sortedContents = sortBy((val) => val.name)(contents || []);

  return (
    <Window width={350} height={300} resizable>
      <Window.Content scrollable>
        <Section>
          {sortedContents.map((item) => (
            <Button
              key={item.ref}
              fluid
              icon="file"
              content={item.name}
              onClick={() => act('retrieve', { ref: item.ref })}
            />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
