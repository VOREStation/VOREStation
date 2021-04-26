import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section, AnimatedNumber } from "../components";
import { Window } from "../layouts";

export const CookingAppliance = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    temperature,
    optimalTemp,
    temperatureEnough,
    efficiency,
    containersRemovable,
    our_contents,
  } = data;

  return (
    <Window width={600} height={600} resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Temperature">
              <ProgressBar
                color={temperatureEnough ? "good" : "blue"}
                value={temperature}
                maxValue={optimalTemp}>
                <AnimatedNumber value={temperature} />&deg;C / {optimalTemp}&deg;C
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
                  <LabeledList.Item label={"Slot #" + (i + 1)} >
                    <Button
                      onClick={() => act("slot", { slot: i + 1 })}>
                      Empty
                    </Button>
                  </LabeledList.Item>
                );
              }

              return (
                <LabeledList.Item label={"Slot #" + (i + 1)} verticalAlign="middle" key={i}>
                  <Flex spacing={1}>
                    <Flex.Item>
                      <Button
                        disabled={!containersRemovable}
                        onClick={() => act("slot", { slot: i + 1 })}>
                        {content.container || "No Container"}
                      </Button>
                    </Flex.Item>
                    <Flex.Item grow={1}>
                      <ProgressBar
                        color={content.progressText[0]}
                        value={content.progress}
                        maxValue={1}>
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