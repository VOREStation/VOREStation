import { useBackend } from 'tgui/backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { getNifCondition, getNutritionText } from './functions';
import type { Data } from './types';

export const NIFMain = (props) => {
  const { act, data } = useBackend<Data>();

  const { nif_percent, nif_stat, nutrition, isSynthetic, modules } = data;

  const { setViewing } = props;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="NIF Condition">
          <ProgressBar
            value={nif_percent}
            minValue={0}
            maxValue={100}
            ranges={{
              good: [50, Infinity],
              average: [25, 50],
              bad: [-Infinity, 0],
            }}
          >
            {getNifCondition(nif_stat, nif_percent)} (
            <AnimatedNumber value={nif_percent} />
            %)
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label={'NIF Power'}>
          <ProgressBar
            value={nutrition}
            minValue={0}
            maxValue={700}
            ranges={{
              good: [250, Infinity],
              average: [150, 250],
              bad: [0, 150],
            }}
          >
            {getNutritionText(nutrition, isSynthetic)}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
      <Section title="NIFSoft Modules" mt={1}>
        <LabeledList>
          {modules.map((module) => (
            <LabeledList.Item
              label={module.name}
              key={module.ref}
              buttons={
                <>
                  <Button.Confirm
                    icon="trash"
                    color="bad"
                    confirmContent="UNINSTALL?"
                    confirmIcon="trash"
                    tooltip="Uninstall Module"
                    tooltipPosition="left"
                    onClick={() => act('uninstall', { module: module.ref })}
                  />
                  <Button
                    icon="search"
                    onClick={() => setViewing(module)}
                    tooltip="View Information"
                    tooltipPosition="left"
                  />
                </>
              }
            >
              {(module.activates && (
                <Button
                  fluid
                  selected={module.active}
                  onClick={() => act('toggle_module', { module: module.ref })}
                >
                  {module.stat_text}
                </Button>
              )) || <Box>{module.stat_text}</Box>}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    </Box>
  );
};
