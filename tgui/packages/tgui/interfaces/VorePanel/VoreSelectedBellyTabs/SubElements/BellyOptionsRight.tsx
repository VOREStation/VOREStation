import { useBackend } from 'tgui/backend';
import { Button, LabeledList } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { vorespawnAbsorbedColor, vorespawnAbsorbedText } from '../../constants';
import type { bellyOptionData } from '../../types';
import { VorePanelEditNumber } from '../../VorePanelElements/VorePanelEditNumber';

export const BellyOptionsRight = (props: {
  editMode: boolean;
  bellyOptionData: bellyOptionData;
}) => {
  const { act } = useBackend();

  const { editMode, bellyOptionData } = props;
  const {
    digest_brute,
    digest_burn,
    digest_oxy,
    digest_tox,
    digest_clone,
    digest_max,
    digest_free,
    shrink_grow_size,
    egg_type,
    egg_types,
    egg_name,
    egg_size,
    recycling,
    storing_nutrition,
    selective_preference,
    vorespawn_blacklist,
    vorespawn_whitelist,
    vorespawn_absorbed,
    drainmode,
  } = bellyOptionData;

  return (
    <LabeledList>
      <LabeledList.Item label="Digest Brute Damage">
        <VorePanelEditNumber
          tooltip={
            'Choose the amount of brute damage prey will take per tick. Max of ' +
            digest_max +
            ' across all damage types. ' +
            digest_free +
            ' remaining.'
          }
          action="set_attribute"
          subAction="b_brute_dmg"
          editMode={editMode}
          value={digest_brute}
          minValue={0}
          step={0.001}
          stepPixel={0.1}
          digits={3}
          maxValue={digest_free + digest_brute}
          color="red"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Digest Burn Damage">
        <VorePanelEditNumber
          tooltip={
            'Choose the amount of burn damage prey will take per tick. Max of ' +
            digest_max +
            ' across all damage types. ' +
            digest_free +
            ' remaining.'
          }
          action="set_attribute"
          subAction="b_burn_dmg"
          editMode={editMode}
          value={digest_burn}
          minValue={0}
          step={0.001}
          stepPixel={0.1}
          digits={3}
          maxValue={digest_free + digest_burn}
          color="orange"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Digest Suffocation Damage">
        <VorePanelEditNumber
          tooltip={
            'Choose the amount of oxygen damage prey will take per tick. Max of ' +
            digest_max +
            ' across all damage types. ' +
            digest_free +
            ' remaining.'
          }
          action="set_attribute"
          subAction="b_oxy_dmg"
          editMode={editMode}
          value={digest_oxy}
          minValue={0}
          step={0.001}
          stepPixel={0.1}
          digits={3}
          maxValue={digest_free + digest_oxy}
          color="blue"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Digest Toxins Damage">
        <VorePanelEditNumber
          tooltip={
            'Choose the amount of toxin damage prey will take per tick. Max of ' +
            digest_max +
            ' across all damage types. ' +
            digest_free +
            ' remaining.'
          }
          action="set_attribute"
          subAction="b_tox_dmg"
          editMode={editMode}
          value={digest_tox}
          minValue={0}
          step={0.001}
          stepPixel={0.1}
          digits={3}
          maxValue={digest_free + digest_tox}
          color="green"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Digest Clone Damage">
        <VorePanelEditNumber
          tooltip={
            'Choose the amount of genetic (clone) damage prey will take per tick. Max of ' +
            digest_max +
            ' across all damage types. ' +
            digest_free +
            ' remaining.'
          }
          action="set_attribute"
          subAction="b_clone_dmg"
          editMode={editMode}
          value={digest_clone}
          minValue={0}
          step={0.001}
          stepPixel={0.1}
          digits={3}
          maxValue={digest_free + digest_clone}
          color="purple"
        />
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
          onClick={() => act('set_attribute', { attribute: 'b_grow_shrink' })}
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
  );
};
