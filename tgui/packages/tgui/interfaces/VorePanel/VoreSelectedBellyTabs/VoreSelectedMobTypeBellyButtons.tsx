import { capitalize } from 'common/string';

import { useBackend } from '../../../backend';
import { Button, LabeledList, Section } from '../../../components';
import { hostMob, selectedData } from '../types';

export const VoreSelectedMobTypeBellyButtons = (props: {
  belly: selectedData;
  host_mobtype: hostMob;
}) => {
  const { act } = useBackend();

  const { belly, host_mobtype } = props;
  const {
    silicon_belly_overlay_preference,
    belly_mob_mult,
    belly_item_mult,
    belly_overall_mult,
  } = belly;

  const { is_cyborg, is_vore_simple_mob } = host_mobtype;

  if (is_cyborg) {
    return (
      <Section title={'Cyborg Controls'} width={'80%'}>
        <LabeledList>
          <LabeledList.Item label="Toggle Belly Overlay Mode">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_silicon_belly' })
              }
            >
              {capitalize(silicon_belly_overlay_preference)}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Mob Vorebelly Size Mult">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_belly_mob_mult' })
              }
            >
              {belly_mob_mult}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Item Vorebelly Size Mult">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_belly_item_mult' })
              }
            >
              {belly_item_mult}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Belly Size Multiplier">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_belly_overall_mult',
                })
              }
            >
              {belly_overall_mult}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  } else if (is_vore_simple_mob) {
    return (
      // For now, we're only returning empty. TODO: Simple mob belly controls
      <LabeledList>
        <LabeledList.Item />
      </LabeledList>
    );
  } else {
    return (
      // Returning Empty element
      <LabeledList>
        <LabeledList.Item />
      </LabeledList>
    );
  }
};
