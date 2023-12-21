import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, NumberInput } from '../components';
import { TemporaryNotice } from './common/TemporaryNotice';
import { Window } from '../layouts';

export const TelecommsMultitoolMenu = (props) => {
  const { act, data } = useBackend();

  const {
    // All
    temp,
    on,
    id,
    network,
    autolinkers,
    shadowlink,
    options,
    linked,
    filter,
    multitool,
    multitool_buffer,
  } = data;

  return (
    <Window width={520} height={540} resizable>
      <Window.Content scrollable>
        <TemporaryNotice />
        <TelecommsMultitoolMenuStatus />
        <TelecommsMultitoolMenuPolymorphicOptions options={options} />
      </Window.Content>
    </Window>
  );
};

const TelecommsMultitoolMenuStatus = (props) => {
  const { act, data } = useBackend();

  const {
    // All
    temp,
    on,
    id,
    network,
    autolinkers,
    shadowlink,
    options,
    linked,
    filter,
    multitool,
    multitool_buffer,
  } = data;

  return (
    <Section
      title="Status"
      buttons={
        <Button
          icon="power-off"
          selected={on}
          content={on ? 'On' : 'Off'}
          onClick={() => act('toggle')}
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Identification String">
          <Button icon="pen" content={id} onClick={() => act('id')} />
        </LabeledList.Item>
        <LabeledList.Item label="Network">
          <Button icon="pen" content={network} onClick={() => act('network')} />
        </LabeledList.Item>
        <LabeledList.Item label="Prefabrication">
          {autolinkers ? 'TRUE' : 'FALSE'}
        </LabeledList.Item>
        {shadowlink ? (
          <LabeledList.Item label="Shadow Link">Active.</LabeledList.Item>
        ) : null}
        {multitool ? (
          <LabeledList.Item label="Multitool Buffer">
            {multitool_buffer ? (
              <Fragment>
                {multitool_buffer.name} ({multitool_buffer.id})
              </Fragment>
            ) : null}
            <Button
              color={multitool_buffer ? 'green' : null}
              content={
                multitool_buffer
                  ? 'Link (' + multitool_buffer.id + ')'
                  : 'Add Machine'
              }
              icon={multitool_buffer ? 'link' : 'plus'}
              onClick={
                multitool_buffer ? () => act('link') : () => act('buffer')
              }
            />
            {multitool_buffer ? (
              <Button
                color="red"
                content="Flush"
                icon="trash"
                onClick={() => act('flush')}
              />
            ) : null}
          </LabeledList.Item>
        ) : null}
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
      <Section title="Filtering Frequencies" mt={1}>
        {filter.map((f) => (
          <Button.Confirm
            key={f.index}
            content={f.name + ' GHz'}
            confirmContent="Delete?"
            confirmColor="red"
            confirmIcon="trash"
            onClick={() => act('delete', { delete: f.freq })}
          />
        ))}
        {!filter || filter.length === 0 ? (
          <Box color="label">No filters.</Box>
        ) : null}
      </Section>
    </Section>
  );
};

const TelecommsMultitoolMenuPolymorphicOptions = (props) => {
  const { act, data } = useBackend();

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
              content={listening_level ? 'Yes' : 'No'}
              onClick={() => act('change_listening')}
            />
          </LabeledList.Item>
        ) : null}
        {use_broadcasting ? (
          <LabeledList.Item label="Broadcasting">
            <Button
              icon="power-off"
              selected={broadcasting}
              content={broadcasting ? 'Yes' : 'No'}
              onClick={() => act('broadcast')}
            />
          </LabeledList.Item>
        ) : null}
        {use_receiving ? (
          <LabeledList.Item label="Receving">
            <Button
              icon="power-off"
              selected={receiving}
              content={receiving ? 'Yes' : 'No'}
              onClick={() => act('receive')}
            />
          </LabeledList.Item>
        ) : null}
        {use_change_freq ? (
          <LabeledList.Item label="Change Signal Frequency">
            <Button
              icon="wave-square"
              selected={!!change_freq}
              content={change_freq ? 'Yes (' + change_freq + ')' : 'No'}
              onClick={() => act('change_freq')}
            />
          </LabeledList.Item>
        ) : null}
        {use_broadcast_range || use_receive_range ? (
          <LabeledList.Item
            label={(use_broadcast_range ? 'Broadcast' : 'Receive') + ' Range'}>
            <NumberInput
              value={range}
              minValue={minRange}
              maxValue={maxRange}
              unit="gigameters"
              stepPixelSize={4}
              format={(val) => val + 1}
              onDrag={(e, val) => act('range', { range: val })}
            />
          </LabeledList.Item>
        ) : null}
      </LabeledList>
    </Section>
  );
};
