import { Box, LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { geneTypeToColor } from '../../constants';
import type { GeneData } from '../../types';
import { WikiList } from '../../WikiCommon/WikiListElements';

export const WikiGenePage = (props: { gene: GeneData }) => {
  const {
    title,
    description,
    trait_type,
    bounds_off_min,
    bounds_off_max,
    bounds_on_min,
    bounds_on_max,
    blockers,
  } = props.gene;

  return (
    <Section fill scrollable title={capitalize(title)}>
      <Stack vertical fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Description">
              <Box color={description ? undefined : 'label'}>
                {description ? description : 'No information available!'}
              </Box>
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Type">
              <Box color={geneTypeToColor[trait_type]}>{trait_type}</Box>
            </LabeledList.Item>
            <LabeledList.Item label="Active Range">
              <Box color="green">
                {bounds_on_min} - {bounds_on_max}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Inactive Range">
              <Box color="red">
                {bounds_off_min} - {bounds_off_max}
              </Box>
            </LabeledList.Item>
            {!!blockers && (
              <WikiList entries={blockers} title="Suppressed By" />
            )}
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
