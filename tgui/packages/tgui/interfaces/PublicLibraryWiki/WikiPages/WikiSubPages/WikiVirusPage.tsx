import { LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { VirusData } from '../../types';

export const WikiVirusPage = (props: { virus: VirusData }) => {
  const {
    title,
    description,
    form,
    agent,
    danger,
    infectivity,
    cure_chance,
    max_stages,
    discovery,
    flags,
    modifiers,
    spread,
  } = props.virus;

  return (
    <Section fill scrollable title={capitalize(title)}>
      <Stack vertical fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Test">{title}</LabeledList.Item>
            <LabeledList.Divider />
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
