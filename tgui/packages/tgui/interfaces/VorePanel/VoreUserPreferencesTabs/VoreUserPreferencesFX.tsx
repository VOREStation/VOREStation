import { LabeledList, Section } from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

import { type localPrefs } from '../types';
import { VorePanelEditNumber } from '../VorePanelElements/VorePanelEditNumber';
import { VoreUserPreferenceItem } from '../VorePanelElements/VoreUserPreferenceItem';

export const VoreUserPreferencesFX = (props: {
  preferences: localPrefs;
  show_vore_fx: BooleanLike;
  max_voreoverlay_alpha: number;
}) => {
  const { preferences, show_vore_fx, max_voreoverlay_alpha } = props;

  return (
    <Section
      title="Vore FX"
      buttons={
        <VoreUserPreferenceItem
          spec={preferences.vore_fx}
          tooltipPosition="right"
        />
      }
    >
      {show_vore_fx ? (
        <LabeledList>
          <LabeledList.Item label="Max Overlay Alpha">
            <VorePanelEditNumber
              editMode
              action="set_max_voreoverlay_alpha"
              value={max_voreoverlay_alpha}
              minValue={0}
              maxValue={255}
              tooltip="Sets the maximum opacity of vore overlays, so that you can always have them be transparent if you want."
            />
          </LabeledList.Item>
        </LabeledList>
      ) : null}
    </Section>
  );
};
