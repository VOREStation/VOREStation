import { LabeledList } from 'tgui-core/components';

import { digestModeToColor, selectiveBellyOptions } from '../../constants';
import type { bellyOptionData } from '../../types';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../../VorePanelElements/VorePanelEditSwitch';
import { VorePanelEditText } from '../../VorePanelElements/VorePanelEditText';

export const BellyOptionsRight = (props: {
  editMode: boolean;
  bellyOptionData: bellyOptionData;
}) => {
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
    egg_name_length,
    egg_size,
    recycling,
    storing_nutrition,
    selective_preference,
    drainmode_options,
    drainmode,
  } = bellyOptionData;

  const displayedEggName = editMode
    ? egg_name || ''
    : egg_name
      ? egg_name
      : 'Default';

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
        <VorePanelEditDropdown
          action="set_attribute"
          subAction="b_drainmode"
          editMode={editMode}
          options={drainmode_options}
          entry={drainmode}
          tooltip="Event trigger once prey is fully drained of nutrition."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Shrink/Grow Size">
        <VorePanelEditNumber
          tooltip="Choose the size that prey will be grown/shrunk to, ranging from 25% to 200%"
          action="set_attribute"
          subAction="b_grow_shrink"
          editMode={editMode}
          value={shrink_grow_size * 100}
          minValue={25}
          maxValue={200}
          unit="%"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Egg Type">
        <VorePanelEditDropdown
          tooltip="Select the displayed egg type when you encase prey in one."
          action="set_attribute"
          subAction="b_egg_type"
          editMode={editMode}
          options={egg_types}
          entry={egg_type}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Custom Egg Name">
        <VorePanelEditText
          action="set_attribute"
          subAction="b_egg_name"
          editMode={editMode}
          limit={egg_name_length}
          entry={displayedEggName}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Custom Egg Size">
        {!egg_size && !editMode ? (
          'Automatic'
        ) : (
          <VorePanelEditNumber
            tooltip="Custom Egg Size 25% to 200% (0 for automatic item depending egg size from 25% to 200%)"
            action="set_attribute"
            subAction="b_egg_size"
            editMode={editMode}
            value={egg_size * 100}
            minValue={0}
            maxValue={200}
            unit="%"
          />
        )}
      </LabeledList.Item>
      <LabeledList.Item label="Recycling">
        <VorePanelEditSwitch
          action="set_attribute"
          subAction="b_recycling"
          editMode={editMode}
          tooltip="Allows you to recycle items into small amounts of resources during digestion."
          active={!!recycling}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Storing Nutrition">
        <VorePanelEditSwitch
          action="set_attribute"
          subAction="b_storing_nutrition"
          editMode={editMode}
          content={storing_nutrition ? 'Storing' : 'Absorbing'}
          active={!!storing_nutrition}
          tooltip={
            'Toggle nutirion ' +
            (storing_nutrition ? 'storing' : 'absorbing') +
            '. Currently nutrition will be ' +
            (storing_nutrition ? 'stored as items' : 'absorbed') +
            '.'
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="Selective Mode Preference">
        <VorePanelEditDropdown
          action="set_attribute"
          subAction="b_selective_mode_pref_toggle"
          editMode={editMode}
          options={selectiveBellyOptions}
          entry={selective_preference}
          color={digestModeToColor[selective_preference]}
        />
      </LabeledList.Item>
    </LabeledList>
  );
};
