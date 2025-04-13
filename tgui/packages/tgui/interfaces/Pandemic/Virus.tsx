import { useBackend } from 'tgui/backend';
import {
  Box,
  Input,
  LabeledList,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { capitalizeFirst, decodeHtmlEntities } from 'tgui-core/string';

import { getColor } from './helpers';
import type { Data } from './types';

export const VirusDisplay = (props) => {
  const { virus } = props;

  return (
    <Stack fill>
      <Stack.Item grow={3}>
        <Info virus={virus} />
      </Stack.Item>
      {virus.is_adv && (
        <>
          <Stack.Divider />
          <Stack.Item grow={1}>
            <Traits virus={virus} />
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};

const Info = (props) => {
  const { act } = useBackend<Data>();
  const {
    virus: { agent, can_rename, cure, description, index, name, spread },
  } = props;

  return (
    <LabeledList>
      <LabeledList.Item label="Name">
        {can_rename ? (
          <Input
            placeholder="Input a name"
            value={name === 'Unknown' ? '' : name}
            onChange={(value) =>
              act('rename_disease', {
                index: index,
                name: value,
              })
            }
          />
        ) : (
          <Box color="bad">{decodeHtmlEntities(name)}</Box>
        )}
      </LabeledList.Item>
      <LabeledList.Item label="Description">{description}</LabeledList.Item>
      <LabeledList.Item label="Agent">
        {capitalizeFirst(agent)}
      </LabeledList.Item>
      <LabeledList.Item label="Spread">{spread}</LabeledList.Item>
      <LabeledList.Item label=" Possible Cure">{cure}</LabeledList.Item>
    </LabeledList>
  );
};

const Traits = (props) => {
  const {
    virus: { resistance, stage_speed, stealth, transmission },
  } = props;

  return (
    <Section title="Statistics">
      <LabeledList>
        <Tooltip content="Decides the cure complexity.">
          <LabeledList.Item color={getColor(resistance)} label="Resistance">
            {resistance}
          </LabeledList.Item>
        </Tooltip>
        <Tooltip content="Symptomic progression.">
          <LabeledList.Item color={getColor(stage_speed)} label="Stage speed">
            {stage_speed}
          </LabeledList.Item>
        </Tooltip>
        <Tooltip content="Detection difficulty from medical equipment.">
          <LabeledList.Item color={getColor(stealth)} label="Stealth">
            {stealth}
          </LabeledList.Item>
        </Tooltip>
        <Tooltip content="Decides the spread type.">
          <LabeledList.Item
            color={getColor(transmission)}
            label="Transmissibility"
          >
            {transmission}
          </LabeledList.Item>
        </Tooltip>
      </LabeledList>
    </Section>
  );
};
