import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { vorespawnAbsorbedColor, vorespawnAbsorbedText } from '../constants';
import type { hostMob, selectedData } from '../types';
import { VoreSelectedMobTypeBellyButtons } from './VoreSelectedMobTypeBellyButtons';

export const VoreSelectedBellyOptions = (props: {
  belly: selectedData;
  host_mobtype: hostMob;
}) => {
  const { act } = useBackend();

  const { belly, host_mobtype } = props;
  const {
    can_taste,
    is_feedable,
    nutrition_percent,
    digest_brute,
    digest_burn,
    digest_oxy,
    digest_tox,
    digest_clone,
    bulge_size,
    display_absorbed_examine,
    shrink_grow_size,
    emote_time,
    emote_active,
    contaminates,
    contaminate_flavor,
    contaminate_color,
    egg_type,
    egg_name,
    egg_size,
    recycling,
    storing_nutrition,
    entrance_logs,
    item_digest_logs,
    selective_preference,
    save_digest_mode,
    eating_privacy_local,
    vorespawn_blacklist,
    vorespawn_whitelist,
    vorespawn_absorbed,
    private_struggle,
    drainmode,
  } = belly;

  return (
    <Stack wrap="wrap">
      <Stack.Item basis="49%" grow>
        <LabeledList>
          <LabeledList.Item label="Can Taste">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_tastes' })}
              icon={can_taste ? 'toggle-on' : 'toggle-off'}
              selected={can_taste}
            >
              {can_taste ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Feedable">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_feedable' })}
              icon={is_feedable ? 'toggle-on' : 'toggle-off'}
              selected={is_feedable}
            >
              {is_feedable ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Contaminates">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_contaminates' })
              }
              icon={contaminates ? 'toggle-on' : 'toggle-off'}
              selected={contaminates}
            >
              {contaminates ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          {contaminates ? (
            <>
              <LabeledList.Item label="Contamination Flavor">
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_contamination_flavor',
                    })
                  }
                  icon="pen"
                >
                  {contaminate_flavor}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Contamination Color">
                <Button
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_contamination_color' })
                  }
                  icon="pen"
                >
                  {!!contaminate_color && capitalize(contaminate_color)}
                </Button>
              </LabeledList.Item>
            </>
          ) : (
            ''
          )}
          <LabeledList.Item label="Nutritional Gain">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_nutritionpercent' })
              }
            >
              {nutrition_percent + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Required Examine Size">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_bulge_size' })
              }
            >
              {bulge_size * 100 + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Display Absorbed Examines">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_display_absorbed_examine',
                })
              }
              icon={display_absorbed_examine ? 'toggle-on' : 'toggle-off'}
              selected={display_absorbed_examine}
            >
              {display_absorbed_examine ? 'True' : 'False'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Toggle Vore Privacy">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_eating_privacy' })
              }
            >
              {capitalize(eating_privacy_local)}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Toggle Struggle Privacy">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_private_struggle' })
              }
              icon={private_struggle ? 'toggle-on' : 'toggle-off'}
              selected={private_struggle}
            >
              {private_struggle ? 'Private' : 'Loud'}
            </Button>
          </LabeledList.Item>

          <LabeledList.Item label="Save Digest Mode">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_save_digest_mode' })
              }
              icon={save_digest_mode ? 'toggle-on' : 'toggle-off'}
              selected={save_digest_mode}
            >
              {save_digest_mode ? 'True' : 'False'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
        <VoreSelectedMobTypeBellyButtons
          belly={belly}
          host_mobtype={host_mobtype}
        />
      </Stack.Item>
      <Stack.Item basis="49%" grow>
        <LabeledList>
          <LabeledList.Item label="Idle Emotes">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_emoteactive' })
              }
              icon={emote_active ? 'toggle-on' : 'toggle-off'}
              selected={emote_active}
            >
              {emote_active ? 'Active' : 'Inactive'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Idle Emote Delay">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_emotetime' })}
            >
              {emote_time + ' seconds'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Brute Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_brute_dmg' })}
            >
              {digest_brute}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Burn Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_burn_dmg' })}
            >
              {digest_burn}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Suffocation Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_oxy_dmg' })}
            >
              {digest_oxy}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Toxins Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_tox_dmg' })}
            >
              {digest_tox}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Clone Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_clone_dmg' })}
            >
              {digest_clone}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Drain Finishing Mode">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_drainmode' })}
            >
              {drainmode}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Shrink/Grow Size">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_grow_shrink' })
              }
            >
              {shrink_grow_size * 100 + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Vore Spawn Blacklist">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_vorespawn_blacklist' })
              }
              icon={vorespawn_blacklist ? 'toggle-on' : 'toggle-off'}
              selected={vorespawn_blacklist}
            >
              {vorespawn_blacklist ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          {vorespawn_blacklist ? (
            ''
          ) : (
            <>
              <LabeledList.Item label="Vore Spawn Whitelist">
                <Button
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_vorespawn_whitelist' })
                  }
                  icon="pen"
                >
                  {vorespawn_whitelist.length
                    ? vorespawn_whitelist.join(', ')
                    : 'Anyone!'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Vore Spawn Absorbed">
                <Button
                  color={vorespawnAbsorbedColor[vorespawn_absorbed]}
                  tooltip="Click to toggle between No, Yes and Prey's Choice."
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_vorespawn_absorbed' })
                  }
                >
                  {vorespawnAbsorbedText[vorespawn_absorbed]}
                </Button>
              </LabeledList.Item>
            </>
          )}
          <LabeledList.Item label="Egg Type">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_egg_type' })}
              icon="pen"
            >
              {capitalize(egg_type)}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Custom Egg Name">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_egg_name' })}
              icon="pen"
            >
              {egg_name ? egg_name : 'Default'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Custom Egg Size">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_egg_size' })}
            >
              {egg_size ? egg_size * 100 + '%' : 'Automatic'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Recycling">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_recycling' })}
              icon={recycling ? 'toggle-on' : 'toggle-off'}
              selected={recycling}
            >
              {recycling ? 'Enabled' : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Storing Nutrition">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_storing_nutrition' })
              }
              icon={storing_nutrition ? 'toggle-on' : 'toggle-off'}
              selected={storing_nutrition}
            >
              {storing_nutrition ? 'Storing' : 'Absorbing'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Entrance Logs">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_entrance_logs' })
              }
              icon={entrance_logs ? 'toggle-on' : 'toggle-off'}
              selected={entrance_logs}
            >
              {entrance_logs ? 'Enabled' : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Item Digestion Logs">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_item_digest_logs' })
              }
              icon={item_digest_logs ? 'toggle-on' : 'toggle-off'}
              selected={item_digest_logs}
            >
              {item_digest_logs ? 'Enabled' : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Selective Mode Preference">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_selective_mode_pref_toggle',
                })
              }
            >
              {capitalize(selective_preference)}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};
