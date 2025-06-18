import { Box, Icon, LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { GeneData } from '../../types';
import { YesNoBox } from '../../WikiCommon/WikiQuickElements';

export const WikiGenePage = (props: { gene: GeneData }) => {
  const { title, description } = props.gene;

  return (
    <Section fill scrollable title={capitalize(title)}>
      <Stack vertical fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Description">
              {description}
            </LabeledList.Item>
            <LabeledList.Divider />
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
