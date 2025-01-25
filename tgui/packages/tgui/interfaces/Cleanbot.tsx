import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  on: BooleanLike;
  open: BooleanLike;
  locked: BooleanLike;
  patrol: BooleanLike;
  vocal: BooleanLike;
  wet_floors: BooleanLike;
  spray_blood: BooleanLike;
  version: string;
  blood: BooleanLike;
  rgbpanel: BooleanLike;
  red_switch: BooleanLike;
  green_switch: BooleanLike;
  blue_switch: BooleanLike;
};

export const Cleanbot = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    on,
    open,
    locked,
    version,
    blood,
    vocal,
    wet_floors,
    spray_blood,
    rgbpanel,
    red_switch,
    green_switch,
    blue_switch,
  } = data;

  return (
    <Window width={400} height={400}>
      <Window.Content scrollable>
        <Section
          title={'Automatic Station Cleaner ' + version}
          buttons={
            <Button icon="power-off" selected={on} onClick={() => act('start')}>
              {on ? 'On' : 'Off'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="Maintenance Panel"
              color={open ? 'bad' : 'good'}
            >
              {open ? 'Open' : 'Closed'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Behavior Controls"
              color={locked ? 'good' : 'bad'}
            >
              {locked ? 'Locked' : 'Unlocked'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(!locked && (
          <Section title="Behavior Controls">
            <LabeledList>
              <LabeledList.Item label="Blood">
                <Button
                  fluid
                  icon={blood ? 'toggle-on' : 'toggle-off'}
                  selected={blood}
                  onClick={() => act('blood')}
                >
                  {blood ? 'Clean' : 'Ignore'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Speaker">
                <Button
                  fluid
                  icon={vocal ? 'toggle-on' : 'toggle-off'}
                  selected={vocal}
                  onClick={() => act('vocal')}
                >
                  {vocal ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
              {/* VOREStation Edit: Not really used on Vore.*/}
              {/* <LabeledList.Item label="Patrol">
                <Button
                  fluid
                  icon={patrol ? "toggle-on" : "toggle-off"}
                  selected={patrol}
                  onClick={() => act("patrol")}>
                  {patrol ? "On" : "Off"}
                </Button>
              </LabeledList.Item> */}
              {/* VOREStation Edit End */}
            </LabeledList>
          </Section>
        )) ||
          null}
        {(!locked && open && (
          <Section title="Maintenance Panel">
            {(rgbpanel && (
              <Box>
                <Button
                  fontSize={5.39}
                  icon={red_switch ? 'toggle-on' : 'toggle-off'}
                  backgroundColor={red_switch ? 'red' : 'maroon'}
                  onClick={() => act('red_switch')}
                />
                <Button
                  fontSize={5.39}
                  icon={green_switch ? 'toggle-on' : 'toggle-off'}
                  backgroundColor={green_switch ? 'green' : 'darkgreen'}
                  onClick={() => act('green_switch')}
                />
                <Button
                  fontSize={5.39}
                  icon={blue_switch ? 'toggle-on' : 'toggle-off'}
                  backgroundColor={blue_switch ? 'blue' : 'darkblue'}
                  onClick={() => act('blue_switch')}
                />
              </Box>
            )) || (
              <Box>
                <LabeledList>
                  <LabeledList.Item label="Odd Looking Screw Twiddled">
                    <Button
                      fluid
                      selected={wet_floors}
                      onClick={() => act('wet_floors')}
                      icon="screwdriver"
                    >
                      {wet_floors ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Weird Button Pressed">
                    <Button
                      fluid
                      color="brown"
                      selected={spray_blood}
                      onClick={() => act('spray_blood')}
                      icon="screwdriver"
                    >
                      {spray_blood ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                </LabeledList>
              </Box>
            )}
          </Section>
        )) ||
          null}
      </Window.Content>
    </Window>
  );
};
