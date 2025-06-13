import { useDispatch, useSelector } from 'tgui/backend';
import {
  Button,
  Collapsible,
  Dropdown,
  LabeledList,
  Section,
} from 'tgui-core/components';

import { MESSAGE_TYPES } from '../../chat/constants';
import { toggleTTSSetting, updateSettings } from '../actions';
import { selectSettings } from '../selectors';

export const TTSSettings = (props) => {
  const dispatch = useDispatch();
  const { ttsCategories, ttsVoice } = useSelector(selectSettings);

  const voices = window.speechSynthesis.getVoices();

  return (
    <>
      <Section>
        <LabeledList>
          <LabeledList.Item label="Voice">
            <Dropdown
              options={voices.map((voice) => voice.name)}
              onSelected={(option) => {
                dispatch(
                  updateSettings({
                    ttsVoice: option,
                  }),
                );
              }}
              selected={ttsVoice}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Enabled Message Types">
        {MESSAGE_TYPES.filter((typeDef) => !typeDef.admin).map((typeDef) => (
          <Button.Checkbox
            key={typeDef.type}
            checked={ttsCategories[typeDef.type]}
            onClick={() => dispatch(toggleTTSSetting({ type: typeDef.type }))}
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
              checked={ttsCategories[typeDef.type]}
              onClick={() => dispatch(toggleTTSSetting({ type: typeDef.type }))}
            >
              {typeDef.name}
            </Button.Checkbox>
          ))}
        </Collapsible>
      </Section>
    </>
  );
};
