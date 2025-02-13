import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

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
    selective_preference,
    save_digest_mode,
    eating_privacy_local,
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
          <LabeledList.Item label="Contaminates">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_contaminate' })
              }
              icon={contaminates ? 'toggle-on' : 'toggle-off'}
              selected={contaminates}
            >
              {contaminates ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          {(contaminates && (
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
          )) ||
            null}
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
          <LabeledList.Item label="Egg Type">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_egg_type' })}
              icon="pen"
            >
              {capitalize(egg_type)}
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
