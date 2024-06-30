import { sortBy } from 'common/collections';

import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

type Data = { contents: content[] };

type content = { name: string; ref: string };

export const FileCabinet = (props) => {
  const { act, data } = useBackend<Data>();

  const { contents } = data;

  // Wow, the filing cabinets sort themselves in 2320.
  const sortedContents = sortBy((val: content) => val.name)(contents || []);

  return (
    <Window width={350} height={300}>
      <Window.Content scrollable>
        <Section>
          {sortedContents.map((item) => (
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
