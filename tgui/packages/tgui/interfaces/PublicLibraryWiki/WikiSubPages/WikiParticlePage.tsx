import {
  Box,
  Collapsible,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { ParticleData } from '../types';
import { ColorizedImage } from '../WikiCommon/WikiColorIcon';
import {
  MinMaxBox,
  MinMaxBoxTemperature,
  ProbabilityBox,
} from '../WikiCommon/WikiQuickElements';

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
            {target_items && (
              <>
                <LabeledList.Divider />
                <LabeledList.Item label="Target Items">
                  <Collapsible color="transparent" title="Reveal Target Items">
                    {target_items.map((item) => (
                      <Box key={item}>- {item}</Box>
                    ))}
                  </Collapsible>
                </LabeledList.Item>
              </>
            )}
            <LabeledList.Divider />
            <LabeledList.Item label="Threshold Energy">
              <MinMaxBox
                min={required_energy_min}
                max={required_energy_max}
                minColor="green"
                maxColor="red"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Threshold Temperature">
              <MinMaxBoxTemperature
                min={required_atmos_temp_min}
                max={required_atmos_temp_max}
                minColor="green"
                maxColor="red"
              />
            </LabeledList.Item>
            {inducers && (
              <>
                <LabeledList.Divider />
                <LabeledList.Item label="Inducers">
                  <Collapsible color="transparent" title="Reveal Inducers">
                    {Object.keys(inducers).map((inducer) => (
                      <Box key={inducer}>
                        - {inducer} {inducers[inducer]}
                      </Box>
                    ))}
                  </Collapsible>
                </LabeledList.Item>
              </>
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
