import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Microwave = (props, context) => {
  const { act, config, data } = useBackend(context);

  const { broken, operating, dirty, items } = data;

  return (
    <Window width={400} height={500} resizable>
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
              level={1}
              title="Ingredients"
              buttons={
                <Fragment>
                  <Button icon="radiation" onClick={() => act('cook')}>
                    Microwave
                  </Button>
                  <Button icon="eject" onClick={() => act('dispose')}>
                    Eject
                  </Button>
                </Fragment>
              }>
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
