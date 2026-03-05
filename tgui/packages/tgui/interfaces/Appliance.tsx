import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Button,
  Dropdown,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  on: BooleanLike;
  safety: BooleanLike;
  selected_option: string | null;
  output_options: Record<string, string>;
  temperature?: number;
  optimalTemp?: number;
  temperatureEnough?: BooleanLike;
  efficiency?: number;
  containersRemovable: BooleanLike;
  our_contents: {
    empty: BooleanLike;
    progress: number;
    progressText: string;
    prediction: string;
    container: string | null;
  }[];
  is_open?: BooleanLike;
  icon_used?: string;
};

export const ApplianceStatus = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    on,
    safety,
    selected_option,
    output_options,
    temperature,
    optimalTemp,
    temperatureEnough,
    efficiency,
    containersRemovable,
    our_contents,
  } = data;

  return (
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
        {!!output_options && !!Object.keys(output_options).length && (
          <LabeledList.Item label="Selected Output">
            <Dropdown
              fluid
              icon="pencil"
              selected={selected_option || 'Default'}
              onSelected={(value) => act('change_output', { value })}
              options={Object.keys(output_options)}
            />
          </LabeledList.Item>
        )}
        {!!temperature && (
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
        )}
        {!!efficiency && (
          <LabeledList.Item label="Efficiency">
            <AnimatedNumber value={efficiency} />%
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

export const Appliance = (props) => {
  const { act, data } = useBackend<Data>();

  const { containersRemovable, our_contents } = data;

  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        <ApplianceStatus />
        <Section title="Containers">
          <LabeledList>
            {our_contents.map((content, i) => {
              if (content.empty) {
                return (
                  <LabeledList.Item key={i} label={`Slot #${i + 1}`}>
                    <Button onClick={() => act('slot', { slot: i + 1 })}>
                      Empty
                    </Button>
                  </LabeledList.Item>
                );
              }

              return (
                <LabeledList.Item
                  label={`Slot #${i + 1}`}
                  verticalAlign="middle"
                  key={i}
                  tooltip={
                    content.prediction
                      ? `Predicted Output: ${content.prediction}`
                      : undefined
                  }
                >
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        disabled={!containersRemovable}
                        onClick={() => act('slot', { slot: i + 1 })}
                      >
                        {content.container || 'No Container'}
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <ProgressBar
                        color={content.progressText[0]}
                        value={content.progress}
                        maxValue={1}
                      >
                        {content.progressText[1]}
                      </ProgressBar>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
