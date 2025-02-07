import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { TemporaryNotice } from './common/TemporaryNotice';

type Data = {
  temp: { color: string; text: string } | null;
  on: BooleanLike;
  id: string | null;
  network: string | null;
  autolinkers: BooleanLike;
  shadowlink: BooleanLike;
  options: options;
  linked: { ref: string; name: string; id: string; index: number }[];
  filter: { name: string; freq: string }[];
  multitool: BooleanLike;
  multitool_buffer: { name: string; id: string } | null;
};

type options = {
  use_listening_level: BooleanLike;
  use_broadcasting: BooleanLike;
  use_receiving: BooleanLike;
  listening_level: BooleanLike;
  broadcasting: BooleanLike;
  receiving: BooleanLike;
  use_change_freq: BooleanLike;
  change_freq: number | undefined;
  use_broadcast_range: BooleanLike;
  range: number | undefined;
  minRange: number | undefined;
  maxRange: number | undefined;
  use_receive_range: BooleanLike;
};

export const TelecommsMultitoolMenu = (props) => {
  const { data } = useBackend<Data>();

  const { options } = data;

  return (
    <Window width={520} height={540}>
      <Window.Content scrollable>
        <TemporaryNotice />
        <TelecommsMultitoolMenuStatus />
        <TelecommsMultitoolMenuPolymorphicOptions options={options} />
      </Window.Content>
    </Window>
  );
};

const TelecommsMultitoolMenuStatus = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    // All
    on,
    id,
    network,
    autolinkers,
    shadowlink,
    linked,
    filter,
    multitool,
    multitool_buffer,
  } = data;

  return (
    <Section
      title="Status"
      buttons={
        <Button icon="power-off" selected={on} onClick={() => act('toggle')}>
          {on ? 'On' : 'Off'}
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Identification String">
          <Button icon="pen" onClick={() => act('id')}>
            {id}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Network">
          <Button icon="pen" onClick={() => act('network')}>
            {network}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Prefabrication">
          {autolinkers ? 'TRUE' : 'FALSE'}
        </LabeledList.Item>
        {shadowlink ? (
          <LabeledList.Item label="Shadow Link">Active.</LabeledList.Item>
        ) : (
          ''
        )}
        {multitool ? (
          <LabeledList.Item label="Multitool Buffer">
            {multitool_buffer ? (
              <>
                {multitool_buffer.name} ({multitool_buffer.id})
              </>
            ) : (
              ''
            )}
            <Button
              color={multitool_buffer ? 'green' : undefined}
              icon={multitool_buffer ? 'link' : 'plus'}
              onClick={
                multitool_buffer ? () => act('link') : () => act('buffer')
              }
            >
              {multitool_buffer
                ? 'Link (' + multitool_buffer.id + ')'
                : 'Add Machine'}
            </Button>
            {multitool_buffer ? (
              <Button color="red" icon="trash" onClick={() => act('flush')}>
                Flush
              </Button>
            ) : (
              ''
            )}
          </LabeledList.Item>
        ) : (
          ''
        )}
      </LabeledList>
      <Section title="Linked network Entities" mt={1}>
        <LabeledList>
          {linked.map((link) => (
            <LabeledList.Item
              key={link.ref}
              label={link.ref + ' ' + link.name + ' (' + link.id + ')'}
              buttons={
                <Button.Confirm
                  color="red"
                  icon="trash"
                  onClick={() => act('unlink', { unlink: link.index })}
                />
              }
            />
          ))}
        </LabeledList>
      </Section>
      <Section
        title="Filtering Frequencies"
        mt={1}
        buttons={
          <Button icon="pen" onClick={() => act('freq')}>
            Add Frequency
          </Button>
        }
      >
        {filter.map((f, i) => (
          <Button.Confirm
            key={i}
            confirmContent="Delete?"
            confirmColor="red"
            confirmIcon="trash"
            onClick={() => act('delete', { delete: f.freq })}
          >
            {f.name + ' GHz'}
          </Button.Confirm>
        ))}
        {!filter || filter.length === 0 ? (
          <Box color="label">No filters.</Box>
        ) : (
          ''
        )}
      </Section>
    </Section>
  );
};

const TelecommsMultitoolMenuPolymorphicOptions = (props: {
  options: options;
}) => {
  const { act } = useBackend();

  const {
    // Relay
    use_listening_level,
    use_broadcasting,
    use_receiving,
    listening_level,
    broadcasting,
    receiving,
    // Bus
    use_change_freq,
    change_freq,
    // Broadcaster & Receiver
    use_broadcast_range,
    use_receive_range,
    range,
    minRange,
    maxRange,
  } = props.options;

  // If absolutely nothing is active, we tell the user there ain't no shit here.
  if (
    !use_listening_level &&
    !use_broadcasting &&
    !use_receiving &&
    !use_change_freq &&
    !use_broadcast_range &&
    !use_receive_range
  ) {
    return <Section title="No Options Found" />;
  }

  return (
    <Section title="Options">
      <LabeledList>
        {use_listening_level ? (
          <LabeledList.Item label="Signal Locked to Station">
            <Button
              icon={listening_level ? 'lock-closed' : 'lock-open'}
              onClick={() => act('change_listening')}
            >
              {listening_level ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
        ) : (
          ''
        )}
        {use_broadcasting ? (
          <LabeledList.Item label="Broadcasting">
            <Button
              icon="power-off"
              selected={broadcasting}
              onClick={() => act('broadcast')}
            >
              {broadcasting ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
        ) : (
          ''
        )}
        {use_receiving ? (
          <LabeledList.Item label="Receving">
            <Button
              icon="power-off"
              selected={receiving}
              onClick={() => act('receive')}
            >
              {receiving ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
        ) : (
          ''
        )}
        {use_change_freq ? (
          <LabeledList.Item label="Change Signal Frequency">
            <Button
              icon="wave-square"
              selected={!!change_freq}
              onClick={() => act('change_freq')}
            >
              {change_freq ? 'Yes (' + change_freq + ')' : 'No'}
            </Button>
          </LabeledList.Item>
        ) : (
          ''
        )}
        {use_broadcast_range || use_receive_range ? (
          <LabeledList.Item
            label={(use_broadcast_range ? 'Broadcast' : 'Receive') + ' Range'}
          >
            <NumberInput
              step={1}
              value={range!}
              minValue={minRange!}
              maxValue={maxRange!}
              unit="gigameters"
              stepPixelSize={4}
              format={(val) => (val + 1).toString()}
              onDrag={(val) => act('range', { range: val })}
            />
          </LabeledList.Item>
        ) : (
          ''
        )}
      </LabeledList>
    </Section>
  );
};
