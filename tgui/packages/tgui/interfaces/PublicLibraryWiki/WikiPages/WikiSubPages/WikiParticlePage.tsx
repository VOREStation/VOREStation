import { LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { ParticleData } from '../../types';
import { ColorizedImage } from '../../WikiCommon/WikiColorIcon';
import { WikiSpoileredList } from '../../WikiCommon/WikiListElements';
import {
  MinMaxBox,
  MinMaxBoxTemperature,
  ProbabilityBox,
} from '../../WikiCommon/WikiQuickElements';

export const WikiParticlePage = (props: { smasher: ParticleData }) => {
  const {
    title,
    req_mat,
    target_items,
    required_energy_min,
    required_energy_max,
    required_atmos_temp_min,
    required_atmos_temp_max,
    inducers,
    result,
    probability,
    icon_data,
  } = props.smasher;

  return (
    <Section fill scrollable title={capitalize(title)}>
      <Stack vertical fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Target Sheet">{req_mat}</LabeledList.Item>
            {!!target_items && (
              <WikiSpoileredList
                ourKey={title}
                title="Target Items"
                entries={target_items}
              />
            )}
            <LabeledList.Divider />
            <LabeledList.Item label="Threshold Energy">
              <MinMaxBox
                min={required_energy_min}
                max={required_energy_max}
                minColor="blue"
                maxColor="orange"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Threshold Temperature">
              <MinMaxBoxTemperature
                min={required_atmos_temp_min}
                max={required_atmos_temp_max}
                minColor="blue"
                maxColor="orange"
              />
            </LabeledList.Item>
            {!!inducers && (
              <WikiSpoileredList
                ourKey={title}
                title="Inducers"
                entries={inducers}
              />
            )}
            <LabeledList.Divider />
            <LabeledList.Item label="Result">{result}</LabeledList.Item>
            <LabeledList.Item label="Icon">
              <ColorizedImage
                icon={icon_data.icon}
                iconState={icon_data.state}
                color={icon_data.color}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Probability">
              <ProbabilityBox chance={probability} />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
