import { Box, LabeledList, Section } from 'tgui-core/components';

import { robotBellyOptions } from '../../constants';
import type { hostMob, siliconeBellyControls } from '../../types';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';

export const VoreSelectedMobTypeBellyButtons = (props: {
  editMode: boolean;
  bellyControl: siliconeBellyControls;
  host_mobtype: hostMob;
}) => {
  const { editMode, bellyControl, host_mobtype } = props;
  const {
    silicon_belly_overlay_preference,
    belly_sprite_option_shown,
    belly_sprite_to_affect,
  } = bellyControl;

  const { is_cyborg, is_vore_simple_mob } = host_mobtype;

  if (is_cyborg) {
    if (belly_sprite_option_shown && belly_sprite_to_affect === 'sleeper') {
      return (
        <Section title={'Cyborg Controls'}>
          <LabeledList>
            <LabeledList.Item label="Toggle Belly Overlay Mode">
              <VorePanelEditDropdown
                tooltip="Choose whether you'd like your belly overlay to show from sleepers, normal vore bellies, or an average of the two. NOTE: This ONLY applies to silicons, not human mobs!"
                action="set_attribute"
                subAction="b_silicon_belly"
                editMode={editMode}
                options={robotBellyOptions}
                entry={silicon_belly_overlay_preference}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      );
    } else {
      return (
        <Section title={'Cyborg Controls'}>
          <Box color="red">
            Your module does either not support vore sprites or you&apos;ve
            selected a belly sprite other than the sleeper within the Visuals
            section.
          </Box>
        </Section>
      );
    }
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
