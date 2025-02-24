import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  material: string;
  identifier: string;
  adjective: string;
  tint: string;
  t: BooleanLike;
  target: string;
  able_to_unpetrify: BooleanLike;
  discard_clothes: BooleanLike;
  can_remote: BooleanLike;
};

export const PetrificationInterface = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    material,
    identifier,
    adjective,
    tint,
    t,
    able_to_unpetrify,
    discard_clothes,
    target,
    can_remote,
  } = data;

  return (
    <Window width={425} height={313}>
      <Window.Content scrollable>
        <Section title="Interface">
          <LabeledList>
            <LabeledList.Item label="Identifier">
              <Button
                fluid
                tooltip="The identifier for the petrification. ie. 'A statue of (target)'"
                tooltipPosition="top"
                onClick={() => act('set_option', { option: 'identifier' })}
              >
                {'Change Identifier: "' + identifier + '"'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Material">
              <Button
                fluid
                tooltip={
                  'The material for the petrification. ie. "(name)' +
                  "'" +
                  's skin rapidly (adjective) as they turn to (material)!"'
                }
                tooltipPosition="top"
                onClick={() => act('set_option', { option: 'material' })}
              >
                {'Change Material: "' + material + '"'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Adjective">
              <Button
                fluid
                tooltip={
                  'The adjective for the petrification. ie. "(name)' +
                  "'" +
                  's skin rapidly (adjective) as they turn to (material)!"'
                }
                tooltipPosition="top"
                onClick={() => act('set_option', { option: 'adjective' })}
              >
                {'Change Adjective: "' + adjective + '"'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Color">
              <Button
                fluid
                backgroundColor={tint}
                textColor={t ? '#000000' : '#ffffff'}
                tooltip="The color of the statue. Pure white is direct greyscale."
                tooltipPosition="top"
                onClick={() => act('set_option', { option: 'tint' })}
              >
                Change Color
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Can Unpetrify">
              <Button
                fluid
                selected={able_to_unpetrify}
                tooltip="Whether or not the statue can be unpetrified. If yes, they will get a verb letting them turn back- if not, even if they're a gargoyle, it will be taken away. OOC Escape is always an option though."
                tooltipPosition="top"
                onClick={() =>
                  act('set_option', { option: 'able_to_unpetrify' })
                }
              >
                {able_to_unpetrify ? 'Yes' : 'No'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Discard Clothes">
              <Button
                fluid
                selected={discard_clothes}
                tooltip="Whether the target's clothing falls off before the petrification happens. (Clothes do not change color when petrified, and cannot be removed while being a statue)"
                tooltipPosition="top"
                onClick={() => act('set_option', { option: 'discard_clothes' })}
              >
                {discard_clothes ? 'Enabled' : 'Disabled'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Target">
              <Button
                fluid
                onClick={() => act('set_option', { option: 'target' })}
              >
                {target}
              </Button>
            </LabeledList.Item>
          </LabeledList>
          <br />
          <Button
            ml={1}
            disabled={!can_remote}
            tooltip={
              'Turn the target to ' +
              material +
              ". This is meant for roleplay/scene purposes. Please don't abuse it."
            }
            tooltipPosition="top"
            onClick={() => act('petrify')}
          >
            Petrify
          </Button>
          <Button
            mr={1}
            disabled={!can_remote}
            tooltip="Create a remote that will petrify the target with the given options when the button is pressed. It must be within 4 tiles of the target when pressed to work.. This is meant for roleplay/scene purposes. Please don't abuse it."
            tooltipPosition="top"
            onClick={() => act('remote')}
          >
            Create Remote
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
