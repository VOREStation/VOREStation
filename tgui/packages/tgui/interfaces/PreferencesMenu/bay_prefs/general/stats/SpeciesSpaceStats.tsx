import { T0C } from 'tgui/constants';
import { Box, LabeledList, Stack } from 'tgui-core/components';
import { YesNoBox } from '../../../../PublicLibraryWiki/WikiCommon/WikiQuickElements';
import type { SpeciesStats } from '../data';
import {
  breathetypeToColor,
  compareWithBase,
  darksightToString,
  formatStat,
  slowdownToString,
} from '../functions';

export const SpeciesBaseStats = (props: {
  speciesStats: SpeciesStats;
  baseStats: SpeciesStats;
}) => {
  const { speciesStats, baseStats } = props;

  return (
    <Stack>
      <Stack.Item>
        <Box bold>Physiology</Box>
        <LabeledList>
          <LabeledList.Item label="Max Health">
            <Box
              color={compareWithBase(
                baseStats.total_health,
                speciesStats.total_health,
              )}
            >
              {speciesStats.total_health}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Breathes Gas">
            <Box
              color={breathetypeToColor(
                speciesStats.breath_type,
                baseStats.breath_type,
              )}
            >
              {speciesStats.breath_type || 'N/A'}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Body Temperature">
            <Box
              color={compareWithBase(
                speciesStats.body_temperature,
                baseStats.body_temperature,
                'blue',
              )}
            >
              {formatStat(speciesStats.body_temperature - T0C, ' °C')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Hypothermia Threshold">
            <Box
              color={compareWithBase(
                speciesStats.cold_level_1,
                baseStats.cold_level_1,
              )}
            >
              {formatStat(speciesStats.cold_level_1 - T0C, ' °C')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Heatstroke Threshold">
            <Box
              color={compareWithBase(
                baseStats.heat_level_1,
                speciesStats.heat_level_1,
              )}
            >
              {formatStat(speciesStats.heat_level_1 - T0C, ' °C')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Min Pressure Limit">
            <Box
              color={compareWithBase(
                speciesStats.hazard_low_pressure,
                baseStats.hazard_low_pressure,
              )}
            >
              {formatStat(
                Math.max(0, speciesStats.hazard_low_pressure),
                ' kPa',
              )}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Max Pressure Limit">
            <Box
              color={compareWithBase(
                baseStats.hazard_high_pressure,
                speciesStats.hazard_high_pressure,
              )}
            >
              {formatStat(
                Math.max(0, speciesStats.hazard_high_pressure),
                ' kPa',
              )}
            </Box>
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item>
        <Box bold>Abilities</Box>
        <LabeledList>
          <LabeledList.Item label="Movement Speed">
            <Box
              color={compareWithBase(speciesStats.slowdown, baseStats.slowdown)}
            >
              {slowdownToString(speciesStats.slowdown)}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Darksight">
            <Box
              color={compareWithBase(
                baseStats.darksight,
                speciesStats.darksight,
              )}
            >
              {darksightToString(speciesStats.darksight)}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Soft Landing">
            <YesNoBox value={!!speciesStats.soft_landing} />
          </LabeledList.Item>
          <LabeledList.Item label="Lightweight">
            <YesNoBox value={!!speciesStats.lightweight} />
          </LabeledList.Item>
          <LabeledList.Item label="Cliff Climber">
            <YesNoBox value={!!speciesStats.can_climb} />
          </LabeledList.Item>
          <LabeledList.Item label="Water Breathing">
            <YesNoBox value={!!speciesStats.water_breather} />
          </LabeledList.Item>
          <LabeledList.Item label="Vibration Sensing">
            <YesNoBox value={!!speciesStats.has_vibration_sense} />
          </LabeledList.Item>
          <LabeledList.Item label="Winged Flight">
            <YesNoBox value={!!speciesStats.has_flight} />
          </LabeledList.Item>
          <LabeledList.Item label="ZeroG Maneuvering">
            <YesNoBox value={!!speciesStats.can_zero_g_move} />
          </LabeledList.Item>
          <LabeledList.Item label="Space Flight">
            <YesNoBox value={!!speciesStats.can_space_freemove} />
          </LabeledList.Item>
          <LabeledList.Item label="Dispersed Eyes">
            <YesNoBox value={!!speciesStats.dispersed_eyes} />
          </LabeledList.Item>
          <LabeledList.Item label="Trash Eating">
            <YesNoBox value={!!speciesStats.trashcan} />
          </LabeledList.Item>
          <LabeledList.Item label="Metal Eating">
            <YesNoBox value={!!speciesStats.eat_minerals} />
          </LabeledList.Item>
          <LabeledList.Item label="Hemovore">
            <YesNoBox value={!!speciesStats.bloodsucker} />
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item>
        <Box bold>Modifiers</Box>
        <LabeledList>
          <LabeledList.Item label="Brute">
            <Box
              color={compareWithBase(
                speciesStats.brute_mod,
                baseStats.brute_mod,
              )}
            >
              {formatStat(speciesStats.brute_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Burn">
            <Box
              color={compareWithBase(speciesStats.burn_mod, baseStats.burn_mod)}
            >
              {formatStat(speciesStats.burn_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Toxin">
            <Box
              color={compareWithBase(
                speciesStats.toxins_mod,
                baseStats.toxins_mod,
              )}
            >
              {formatStat(speciesStats.toxins_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Suffocation">
            <Box
              color={compareWithBase(speciesStats.oxy_mod, baseStats.oxy_mod)}
            >
              {formatStat(speciesStats.oxy_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Radiation">
            <Box
              color={compareWithBase(
                speciesStats.radiation_mod,
                baseStats.radiation_mod,
              )}
            >
              {formatStat(speciesStats.radiation_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Electrical">
            <Box
              color={compareWithBase(
                speciesStats.siemens_coefficient,
                baseStats.siemens_coefficient,
              )}
            >
              {formatStat(speciesStats.siemens_coefficient, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Flash">
            <Box
              color={compareWithBase(
                speciesStats.flash_mod,
                baseStats.flash_mod,
              )}
            >
              {formatStat(speciesStats.flash_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Pain">
            <Box
              color={compareWithBase(speciesStats.pain_mod, baseStats.pain_mod)}
            >
              {formatStat(speciesStats.pain_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Stun">
            <Box
              color={compareWithBase(speciesStats.stun_mod, baseStats.stun_mod)}
            >
              {formatStat(speciesStats.stun_mod, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Medication">
            <Box
              color={compareWithBase(
                baseStats.chem_strength_heal,
                speciesStats.chem_strength_heal,
              )}
            >
              {formatStat(speciesStats.chem_strength_heal, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Poison">
            <Box
              color={compareWithBase(
                speciesStats.chem_strength_tox,
                baseStats.chem_strength_tox,
              )}
            >
              {formatStat(speciesStats.chem_strength_tox, 'x')}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Item Slowdown">
            <Box
              color={compareWithBase(
                speciesStats.item_slowdown_mod,
                baseStats.item_slowdown_mod,
              )}
            >
              {formatStat(speciesStats.item_slowdown_mod, 'x')}
            </Box>
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};
