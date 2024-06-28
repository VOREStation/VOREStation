import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  broken: BooleanLike;
  operating: BooleanLike;
  dirty: BooleanLike;
  items: { name: string; amt: number; extra: string }[];
};

export const Microwave = (props) => {
  const { act, config, data } = useBackend<Data>();

  const { broken, operating, dirty, items } = data;

  return (
    <Window width={400} height={500}>
      <Window.Content scrollable>
        {(broken && (
          <Section>
            <Box color="bad">Bzzzzttttt!!</Box>
          </Section>
        )) ||
          (operating && (
            <Section>
              <Box color="good">
                Microwaving in progress!
                <br />
                Please wait...!
              </Box>
            </Section>
          )) ||
          (dirty && (
            <Section>
              <Box color="bad">
                This microwave is dirty!
                <br />
                Please clean it before use!
              </Box>
            </Section>
          )) ||
          (items.length && (
            <Section
              title="Ingredients"
              buttons={
                <>
                  <Button icon="radiation" onClick={() => act('cook')}>
                    Microwave
                  </Button>
                  <Button icon="eject" onClick={() => act('dispose')}>
                    Eject
                  </Button>
                </>
              }
            >
              <LabeledList>
                {items.map((item) => (
                  <LabeledList.Item key={item.name} label={item.name}>
                    {item.amt} {item.extra}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          )) || (
            <Section>
              <Box color="bad">{config.title} is empty.</Box>
            </Section>
          )}
      </Window.Content>
    </Window>
  );
};
