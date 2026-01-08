import {
  Button,
  Collapsible,
  Dropdown,
  LabeledList,
  Section,
} from 'tgui-core/components';

import { MESSAGE_TYPES } from '../../chat/constants';
import { useSettings } from '../use-settings';

export const TTSSettings = (props) => {
  const { settings, updateSettings, toggleInObject } = useSettings();

  const voices = window.speechSynthesis.getVoices();

  return (
    <>
      <Section>
        <LabeledList>
          <LabeledList.Item label="Voice">
            <Dropdown
              options={voices.map((voice) => voice.name)}
              onSelected={(option) => {
                updateSettings({
                  ttsVoice: option,
                });
              }}
              selected={settings.ttsVoice}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Enabled Message Types">
        {MESSAGE_TYPES.filter((typeDef) => !typeDef.admin).map((typeDef) => (
          <Button.Checkbox
            key={typeDef.type}
            checked={settings.ttsCategories[typeDef.type]}
            onClick={() =>
              updateSettings({
                ttsCategories: toggleInObject(
                  settings.ttsCategories,
                  typeDef.type,
                ),
              })
            }
          >
            {typeDef.name}
          </Button.Checkbox>
        ))}
        <Collapsible mt={1} color="transparent" title="Admin stuff">
          {MESSAGE_TYPES.filter(
            (typeDef) => !typeDef.important && typeDef.admin,
          ).map((typeDef) => (
            <Button.Checkbox
              key={typeDef.type}
              checked={settings.ttsCategories[typeDef.type]}
              onClick={() =>
                updateSettings({
                  ttsCategories: toggleInObject(
                    settings.ttsCategories,
                    typeDef.type,
                  ),
                })
              }
            >
              {typeDef.name}
            </Button.Checkbox>
          ))}
        </Collapsible>
      </Section>
    </>
  );
};
