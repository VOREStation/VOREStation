import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import { modalData } from './types';

export const virusModalBodyOverride = (modal: modalData) => {
  const { act } = useBackend();
  const virus = modal.args;
  return (
    <Section
      m="-1rem"
      title={virus.name || 'Virus'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('modal_close')} />
      }
    >
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Spread">
            {virus.spreadtype} Transmission
          </LabeledList.Item>
          <LabeledList.Item label="Possible cure">
            {virus.antigen}
          </LabeledList.Item>
          <LabeledList.Item label="Rate of Progression">
            {virus.rate}
          </LabeledList.Item>
          <LabeledList.Item label="Antibiotic Resistance">
            {virus.resistance}%
          </LabeledList.Item>
          <LabeledList.Item label="Species Affected">
            {virus.species}
          </LabeledList.Item>
          <LabeledList.Item label="Symptoms">
            <LabeledList>
              {virus.symptoms.map((s) => (
                <LabeledList.Item key={s.stage} label={s.stage + '. ' + s.name}>
                  <Box inline color="label">
                    Strength:
                  </Box>{' '}
                  {s.strength}&nbsp;
                  <Box inline color="label">
                    Aggressiveness:
                  </Box>{' '}
                  {s.aggressiveness}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};
