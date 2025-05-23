import { useBackend } from 'tgui/backend';
import {
  Box,
  ColorBox,
  ImageButton,
  Input,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import type { Data } from './types';

const quick_actions: {
  name: string;
  icon: string;
  icon_state: string;
  eventName: string;
}[] = [
  {
    name: 'Communicator',
    icon: 'icons/obj/device.dmi',
    icon_state: 'communicator',
    eventName: 'quick_action_comm',
  },
  {
    name: 'PDA',
    icon: 'icons/obj/pda_vr.dmi',
    icon_state: 'pda',
    eventName: 'quick_action_pda',
  },
  {
    name: 'Crew Manifest',
    icon: 'icons/obj/pda_vr.dmi',
    icon_state: 'cart',
    eventName: 'quick_action_crew_manifest',
  },
  {
    name: 'Law Manager',
    icon: 'icons/mob/screen1_robot.dmi',
    icon_state: 'harm',
    eventName: 'quick_action_law_manager',
  },
  {
    name: 'Alarm Monitor',
    icon: 'icons/obj/modular_console.dmi',
    icon_state: 'alert-green',
    eventName: 'quick_action_alarm_monitoring',
  },
  {
    name: 'Power Monitor',
    icon: 'icons/obj/modular_console.dmi',
    icon_state: 'power_monitor',
    eventName: 'quick_action_power_monitoring',
  },
  {
    name: 'Take Image',
    icon: 'icons/obj/items.dmi',
    icon_state: 'camera',
    eventName: 'quick_action_take_image',
  },
  {
    name: 'View Images',
    icon: 'icons/obj/items.dmi',
    icon_state: 'film',
    eventName: 'quick_action_view_images',
  },
  {
    name: 'Delete Images',
    icon: 'icons/obj/items.dmi',
    icon_state: 'photo',
    eventName: 'quick_action_delete_images',
  },
  {
    name: 'Toggle Lights',
    icon: 'icons/obj/lighting.dmi',
    icon_state: 'flashlight',
    eventName: 'quick_action_flashlight',
  },
  {
    name: 'Toggle Sensor Augmentation',
    icon: 'icons/inventory/eyes/item.dmi',
    icon_state: 'sec_hud',
    eventName: 'quick_action_sensors',
  },
  {
    name: 'Emit Sparks',
    icon: 'icons/effects/effects.dmi',
    icon_state: 'sparks',
    eventName: 'quick_action_sparks',
  },
];

export const StatusScreen = (props) => {
  const { act } = useBackend<Data>();

  return (
    <Stack vertical fill height="94%">
      <Stack.Item basis="20%">
        <Stack fill>
          <Stack.Item grow>
            <Configuration />
          </Stack.Item>
          <Stack.Item grow>
            <Status />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Quick Actions" fill scrollable>
          <Stack>
            <Stack.Item grow>
              {quick_actions
                .slice(0, quick_actions.length / 2)
                .map((action) => (
                  <ImageButton
                    key={action.name}
                    dmIcon={action.icon}
                    dmIconState={action.icon_state}
                    imageSize={48}
                    onClick={() => act(action.eventName)}
                    fluid
                  >
                    {action.name}
                  </ImageButton>
                ))}
            </Stack.Item>
            <Stack.Item grow>
              {quick_actions.slice(quick_actions.length / 2).map((action) => (
                <ImageButton
                  key={action.name}
                  dmIcon={action.icon}
                  dmIconState={action.icon_state}
                  imageSize={48}
                  onClick={() => act(action.eventName)}
                  fluid
                >
                  {action.name}
                </ImageButton>
              ))}
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const Configuration = (props) => {
  const { data } = useBackend<Data>();

  const { name, module_name, ai } = data;
  return (
    <Section title="Configuration" fill>
      <LabeledList>
        <LabeledList.Item label="Unit">{name}</LabeledList.Item>
        <LabeledList.Item label="Type">{module_name}</LabeledList.Item>
        <LabeledList.Item label="AI">
          {ai ? <Box color="good">{ai}</Box> : <Box color="average">None</Box>}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const Status = (props) => {
  const { act, data } = useBackend<Data>();

  const { charge, max_charge, health, max_health, light_color } = data;

  return (
    <Section title="Status" fill>
      <LabeledList>
        <LabeledList.Item label="Charge">
          {charge && max_charge ? (
            <ProgressBar
              value={charge}
              maxValue={max_charge}
              ranges={{
                good: [max_charge * 0.75, Number.POSITIVE_INFINITY],
                average: [max_charge * 0.3, max_charge * 0.75],
                bad: [Number.NEGATIVE_INFINITY, max_charge * 0.3],
              }}
            >
              {charge} / {max_charge}
            </ProgressBar>
          ) : (
            <NoticeBox danger>NO CELL INSTALLED</NoticeBox>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Chassis Integrity">
          <ProgressBar
            value={health}
            maxValue={max_health}
            ranges={{
              good: [max_health * 0.75, Number.POSITIVE_INFINITY],
              average: [max_health * 0.3, max_health * 0.75],
              bad: [Number.NEGATIVE_INFINITY, max_health * 0.3],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Light color">
          <Box inline>
            <ColorBox mr={1} color={light_color} />
            <Input
              width="5em"
              monospace
              value={light_color}
              onChange={(e, value: string) => act('set_light_col', { value })}
            />
          </Box>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
