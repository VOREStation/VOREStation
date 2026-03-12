import { useAtomValue } from 'jotai';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Input,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { chatRenderer } from '../../chat/renderer';
import { settingsAtom } from '../atoms';
import { MAX_HIGHLIGHT_SETTINGS } from '../constants';
import { useHighlights } from '../use-highlights';

export const TextHighlightSettings = (props) => {
  const {
    highlights: { highlightSettings },
    addHighlight,
  } = useHighlights();
  const settings = useAtomValue(settingsAtom);

  return (
    <Section fill scrollable height="235px">
      <Section p={0}>
        <Stack direction="column">
          {highlightSettings.map((id, i) => (
            <TextHighlightSetting
              key={i}
              id={id}
              mb={i + 1 === highlightSettings.length ? 0 : '10px'}
            />
          ))}
          {highlightSettings.length < MAX_HIGHLIGHT_SETTINGS && (
            <Stack.Item>
              <Button
                color="transparent"
                icon="plus"
                onClick={() => addHighlight()}
              >
                Add Highlight Setting
              </Button>
            </Stack.Item>
          )}
        </Stack>
      </Section>
      <Divider />
      <Box>
        <Button
          icon="check"
          onClick={() => chatRenderer.rebuildChat(settings.visibleMessageLimit)}
        >
          Apply now
        </Button>
        <Box inline fontSize="0.9em" ml={1} color="label">
          Can freeze the chat for a while.
        </Box>
      </Box>
    </Section>
  );
};

const TextHighlightSetting = (props) => {
  const { id, ...rest } = props;
  const {
    highlights: { highlightSettingById },
    updateHighlight,
    removeHighlight,
  } = useHighlights();
  const {
    highlightColor,
    highlightText,
    blacklistText,
    highlightWholeMessage,
    highlightBlacklist,
    matchWord,
    matchCase,
  } = highlightSettingById[id];
  return (
    <Stack.Item {...rest}>
      <Stack mb={1} color="label" align="baseline">
        <Button.Confirm
          icon="times"
          color="transparent"
          onClick={() =>
            updateHighlight({
              id,
              highlightText: '',
              blacklistText: '',
            })
          }
        >
          Reset
        </Button.Confirm>
        {id !== 'default' && (
          <Stack.Item>
            <Button.Confirm
              color="transparent"
              icon="times"
              onClick={() => removeHighlight(id)}
            >
              Delete
            </Button.Confirm>
          </Stack.Item>
        )}
        <Stack.Item grow />
        <Stack.Item>
          <Button.Checkbox
            checked={highlightBlacklist}
            tooltip="If this option is selected, you can blacklist senders not to highlight their messages."
            mr="5px"
            onClick={() =>
              updateHighlight({
                id,
                highlightBlacklist: !highlightBlacklist,
              })
            }
          >
            Highlight Blacklist
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={highlightWholeMessage}
            tooltip="If this option is selected, the entire message will be highlighted in yellow."
            mr="5px"
            onClick={() =>
              updateHighlight({
                id,
                highlightWholeMessage: !highlightWholeMessage,
              })
            }
          >
            Whole Message
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={matchWord}
            tooltipPosition="bottom-start"
            tooltip="If this option is selected, only exact matches (no extra letters before or after) will trigger. Not compatible with punctuation. Overriden if regex is used."
            onClick={() =>
              updateHighlight({
                id,
                matchWord: !matchWord,
              })
            }
          >
            Exact
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            tooltip="If this option is selected, the highlight will be case-sensitive."
            checked={matchCase}
            onClick={() =>
              updateHighlight({
                id,
                matchCase: !matchCase,
              })
            }
          >
            Case
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item shrink={0}>
          <ColorBox mr={1} color={highlightColor} />
          <Input
            width="5em"
            monospace
            placeholder="#ffffff"
            value={highlightColor}
            onBlur={(value) =>
              updateHighlight({
                id,
                highlightColor: value,
              })
            }
          />
        </Stack.Item>
      </Stack>
      <TextArea
        fluid
        height="3em"
        value={highlightText}
        placeholder="Put words to highlight here. Separate terms with commas, i.e. (term1, term2, term3)"
        onBlur={(value) =>
          updateHighlight({
            id,
            highlightText: value,
          })
        }
      />
      {!!highlightBlacklist && (
        <TextArea
          fluid
          height="3em"
          value={blacklistText}
          placeholder="Put names of senders you don't want highlighted here. Separate names with commas, i.e. (name1, name2, name3)"
          onBlur={(value) =>
            updateHighlight({
              id,
              blacklistText: value,
            })
          }
        />
      )}
    </Stack.Item>
  );
};
