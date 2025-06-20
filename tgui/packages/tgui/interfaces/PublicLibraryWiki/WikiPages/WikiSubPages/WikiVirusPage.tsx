import { Box, Icon, LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import {
  virusDiscoveryToColor,
  virusInfectivityToColor,
  virusResilienceToColor,
  virusSpreadToColor,
  virusSpreadToIcon,
  viursThreatToColor,
} from '../../constants';
import type { VirusData } from '../../types';
import { YesNoBox } from '../../WikiCommon/WikiQuickElements';

export const WikiVirusPage = (props: { virus: VirusData }) => {
  const {
    title,
    description,
    form,
    agent,
    danger,
    infectivity,
    resiliance,
    max_stages,
    discovery,
    spread,
    all_cures,
    aggressive,
    curable,
    resistable,
    carriable,
    spread_dead,
    infect_synth,
  } = props.virus;

  return (
    <Section fill scrollable title={capitalize(title)}>
      <Stack vertical fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Description">
              {description}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Type">
              {form} - {agent}
            </LabeledList.Item>
            <LabeledList.Item label="Hazard Level">
              <Box color={viursThreatToColor[danger]}>{danger}</Box>
            </LabeledList.Item>
            <LabeledList.Item label="Growth Stages">
              <Box>{max_stages}</Box>
            </LabeledList.Item>
            <LabeledList.Item label="Curable">
              <Stack>
                <Stack.Item>
                  <YesNoBox value={!!curable} />
                </Stack.Item>
                <Stack.Item>
                  {!all_cures ? ' - single treatment' : ''}
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Resistable">
              <YesNoBox value={!!resistable} />
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Transmission">
              <Stack vertical>
                <Stack.Item>
                  <Stack>
                    <Stack.Item>
                      <Box>{spread}</Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Icon
                        color={virusSpreadToColor[spread]}
                        name={virusSpreadToIcon[spread]}
                      />
                    </Stack.Item>
                    {aggressive ? (
                      <>
                        <Stack.Item>{' - Agressive '}</Stack.Item>
                        <Stack.Item>
                          <Icon name={'triangle-exclamation'} />
                        </Stack.Item>
                      </>
                    ) : (
                      ''
                    )}
                  </Stack>
                </Stack.Item>
                {!!carriable && (
                  <Stack.Item>
                    <Stack>
                      <Stack.Item>
                        <Box inline>{'>'}</Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Box inline color="yellow">
                          {'Transmissable without symptoms'}
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                )}
                {!!spread_dead && (
                  <Stack.Item>
                    <Stack>
                      <Stack.Item>
                        <Box inline>{'>'}</Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Box inline color="yellow">
                          {'Transmissable from dead tissue'}
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                )}
                {!!infect_synth && (
                  <Stack.Item>
                    <Stack>
                      <Stack.Item>
                        <Box inline>{'>'}</Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Box inline color="yellow">
                          {'Inorganic pathogen'}
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                )}
              </Stack>
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Discoverability">
              <Box color={virusDiscoveryToColor[discovery]}>{discovery}</Box>
            </LabeledList.Item>
            <LabeledList.Item label="Infectivity">
              <Box color={virusInfectivityToColor[infectivity]}>
                {infectivity}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Resiliance">
              <Box color={virusResilienceToColor[resiliance]}>{resiliance}</Box>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
