import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { healthToColor } from './functions';
import { PaiIcon } from './PaiIcon';
import type { ActivePAIData } from './types';

export const PAIActiveCompanion = (props: { activeData: ActivePAIData }) => {
  const { act } = useBackend();
  const [newDirective, setNewDirective] = useState('');

  const { activeData } = props;
  const {
    name,
    color,
    health,
    chassis,
    law_zero,
    law_extra,
    master_name,
    master_dna,
    screen_msg,
    radio_data,
    sprite_datum_class,
    sprite_datum_size,
  } = activeData;

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item grow>
          <Section
            title={name}
            fill
            scrollable
            buttons={
              <Stack>
                <Stack.Item>
                  <Button.Confirm
                    color="red"
                    icon="ban"
                    disabled={!master_name || !master_dna}
                    onClick={() => act('cleardna')}
                  >
                    Clear DNA
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="lightbulb-o"
                    disabled={!!master_name && !!master_dna}
                    onClick={() => act('setdna')}
                  >
                    Imprint DNA
                  </Button>
                </Stack.Item>
              </Stack>
            }
          >
            <LabeledList>
              <LabeledList.Item label="Owner">
                {!!master_name && !!master_dna ? (
                  <>
                    <Box style={{ textDecoration: 'underline' }} inline>
                      {master_name}
                    </Box>
                    <Box inline>: {master_dna}</Box>
                  </>
                ) : (
                  'unbound'
                )}
              </LabeledList.Item>
              <LabeledList.Divider />
              <LabeledList.Item verticalAlign="top" label="Chassis">
                <PaiIcon
                  label
                  color={color}
                  icon={sprite_datum_class}
                  size={sprite_datum_size}
                  chassis={chassis}
                />
              </LabeledList.Item>
              <LabeledList.Divider />
              <LabeledList.Item label="Integrity">
                <Box color={healthToColor(health)}>{health}</Box>
              </LabeledList.Item>
              {!!screen_msg && (
                <LabeledList.Item label="Screen">{screen_msg}</LabeledList.Item>
              )}
              <LabeledList.Divider />
              <LabeledList.Item label="Prime Directive">
                {law_zero}
              </LabeledList.Item>
              {!!law_extra && (
                <LabeledList.Item label="Additional Directives">
                  {law_extra}
                </LabeledList.Item>
              )}
            </LabeledList>
          </Section>
        </Stack.Item>
        <Stack.Item>
          <Section title="Radio Uplink">
            {radio_data ? (
              <LabeledList>
                <LabeledList.Item label="Receiving">
                  <RadioBox status={!!radio_data.radio_recieve} />
                </LabeledList.Item>
                <LabeledList.Item label="Transmitting">
                  <RadioBox status={!!radio_data.radio_transmit} />
                </LabeledList.Item>
              </LabeledList>
            ) : (
              'Radio firmware not loaded. Please install a pAI personality to load firmware.'
            )}
          </Section>
        </Stack.Item>
        <Stack.Item>
          <Section
            title="Manage Additional Directives:"
            buttons={
              <Stack>
                <Stack.Item>
                  <Button.Confirm color="red" disabled={!law_extra} icon="ban">
                    Clear
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="lightbulb-o"
                    tooltip="Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored."
                    disabled={!newDirective}
                    onClick={() => {
                      act('setlaws', { directive: newDirective });
                      setNewDirective('');
                    }}
                  >
                    Apply
                  </Button>
                </Stack.Item>
              </Stack>
            }
          >
            <LabeledList>
              <LabeledList.Item verticalAlign="top" label="New Directive">
                <TextArea
                  fluid
                  height="80px"
                  maxLength={4096}
                  placeholder="Set new directive..."
                  value={newDirective}
                  onChange={setNewDirective}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const RadioBox = (props: { status: boolean }) => {
  const { status } = props;

  return status ? (
    <Box color="red">Disabled</Box>
  ) : (
    <Box color="green">Enabled</Box>
  );
};
