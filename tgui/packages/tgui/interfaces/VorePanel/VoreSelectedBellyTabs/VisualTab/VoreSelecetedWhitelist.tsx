import { Divider, LabeledList, Section } from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

import { vorespawnAbsorbedColor, vorespawnAbsorbedText } from '../../constants';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditSwitch } from '../../VorePanelElements/VorePanelEditSwitch';
import { VorePanelEditTextArea } from '../../VorePanelElements/VorePanelTextArea';

export const VoreSelectedWhitelist = (props: {
  editMode: boolean;
  vorespawnBlacklist: BooleanLike;
  vorespawnWhitelist: string[];
  vorespawnAbsorbed: number;
}) => {
  const {
    editMode,
    vorespawnBlacklist,
    vorespawnWhitelist,
    vorespawnAbsorbed,
  } = props;

  const ourEntry = editMode
    ? (vorespawnWhitelist.length && vorespawnWhitelist.join(', ')) || ''
    : vorespawnWhitelist.length
      ? vorespawnWhitelist.join(', ')
      : 'Anyone!';

  return (
    <Section
      title="Vore Spawn"
      buttons={
        <VorePanelEditSwitch
          action="set_attribute"
          subAction="b_vorespawn_blacklist"
          editMode={editMode}
          active={!vorespawnBlacklist}
          content={vorespawnBlacklist ? 'Hide' : 'Show'}
          tooltip={
            (vorespawnBlacklist ? 'Hide' : 'Show') +
            " this belly from potential prey's spawn selection list."
          }
        />
      }
      width={'80%'}
    >
      {!vorespawnBlacklist && (
        <>
          <LabeledList>
            <LabeledList.Item label="Vore Spawn Absorbed">
              <VorePanelEditDropdown
                action="set_attribute"
                subAction="b_vorespawn_absorbed"
                editMode={editMode}
                color={vorespawnAbsorbedColor[vorespawnAbsorbed]}
                options={vorespawnAbsorbedText}
                entry={vorespawnAbsorbedText[vorespawnAbsorbed]}
              />
            </LabeledList.Item>
          </LabeledList>
          <Divider />
          <VorePanelEditTextArea
            disableLegacyInput
            tooltip="Input vore spawn allowed ckeys. Empty means anyone can spawn."
            editMode={editMode}
            limit={4096}
            entry={ourEntry}
            action="set_attribute"
            subAction="b_vorespawn_whitelist"
          />
        </>
      )}
    </Section>
  );
};
