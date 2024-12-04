import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Button,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  safety: BooleanLike;
  selected_option: string | null;
  show_selected_option: BooleanLike;
  temperature: number;
  optimalTemp: number;
  temperatureEnough: BooleanLike;
  efficiency: number;
  containersRemovable: BooleanLike;
  our_contents: {
    empty: BooleanLike;
    progress: number;
    progressText: string;
    container: string | null;
  }[];
};

export const CookingAppliance = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    on,
    safety,
    selected_option,
    show_selected_option,
    temperature,
    optimalTemp,
    temperatureEnough,
    efficiency,
    containersRemovable,
    our_contents,
  } = data;

  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        <Section
          title="Status"
          buttons={
            <Button
              selected={on}
              icon="power-off"
              onClick={() => act('toggle_power')}
            >
              {on ? 'On' : 'Off'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Safety">
              <Button
                fluid
                selected={safety}
                icon={safety ? 'shield-alt' : 'exclamation-triangle'}
                onClick={() => act('toggle_safety')}
              >
                {safety ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            {!!show_selected_option && (
              <LabeledList.Item label="Selected Output">
                <Button
                  icon="pencil"
                  fluid
                  onClick={() => act('change_output')}
                  tooltip="Change Output"
                >
                  {selected_option || 'Default'}
                </Button>
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Temperature">
              <ProgressBar
                color={temperatureEnough ? 'good' : 'blue'}
                value={temperature}
                maxValue={optimalTemp}
              >
                <AnimatedNumber value={temperature} />
                &deg;C / {optimalTemp}&deg;C
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Efficiency">
              <AnimatedNumber value={efficiency} />%
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Containers">
          <LabeledList>
            {our_contents.map((content, i) => {
              if (content.empty) {
                return (
                  <LabeledList.Item key={i} label={'Slot #' + (i + 1)}>
                    <Button onClick={() => act('slot', { slot: i + 1 })}>
                      Empty
                    </Button>
                  </LabeledList.Item>
                );
              }

              return (
                <LabeledList.Item
                  label={'Slot #' + (i + 1)}
                  verticalAlign="middle"
                  key={i}
                >
                  <Flex spacing={1}>
                    <Flex.Item>
                      <Button
                        disabled={!containersRemovable}
                        onClick={() => act('slot', { slot: i + 1 })}
                      >
                        {content.container || 'No Container'}
                      </Button>
                    </Flex.Item>
                    <Flex.Item grow={1}>
                      <ProgressBar
                        color={content.progressText[0]}
                        value={content.progress}
                        maxValue={1}
                      >
                        {content.progressText[1]}
                      </ProgressBar>
                    </Flex.Item>
                  </Flex>
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
