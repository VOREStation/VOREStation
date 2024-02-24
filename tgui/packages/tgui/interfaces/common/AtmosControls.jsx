import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Button, LabeledList, NumberInput, Section } from '../../components';

export const Vent = (props) => {
  const { vent } = props;
  const { act } = useBackend();
  const {
    id_tag,
    long_name,
    power,
    checks,
    excheck,
    incheck,
    direction,
    external,
    internal,
    extdefault,
    intdefault,
  } = vent;
  return (
    <Section
      level={2}
      title={decodeHtmlEntities(long_name)}
      buttons={
        <Button
          icon={power ? 'power-off' : 'times'}
          selected={power}
          content={power ? 'On' : 'Off'}
          onClick={() =>
            act('power', {
              id_tag,
              val: Number(!power),
            })
          }
        />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button
            icon="sign-in-alt"
            content={direction !== 'siphon' ? 'Pressurizing' : 'Siphoning'}
            color={direction === 'siphon' && 'danger'}
            onClick={() =>
              act('direction', {
                id_tag,
                val: Number(direction === 'siphon'),
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Pressure Regulator">
          <Button
            icon="sign-in-alt"
            content="Internal"
            selected={incheck}
            onClick={() =>
              act('incheck', {
                id_tag,
                val: checks,
              })
            }
          />
          <Button
            icon="sign-out-alt"
            content="External"
            selected={excheck}
            onClick={() =>
              act('excheck', {
                id_tag,
                val: checks,
              })
            }
          />
        </LabeledList.Item>
        {!!incheck && (
          <LabeledList.Item label="Internal Target">
            <NumberInput
              value={Math.round(internal)}
              unit="kPa"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(e, value) =>
                act('set_internal_pressure', {
                  id_tag,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={intdefault}
              content="Reset"
              onClick={() =>
                act('reset_internal_pressure', {
                  id_tag,
                })
              }
            />
          </LabeledList.Item>
        )}
        {!!excheck && (
          <LabeledList.Item label="External Target">
            <NumberInput
              value={Math.round(external)}
              unit="kPa"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(e, value) =>
                act('set_external_pressure', {
                  id_tag,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={extdefault}
              content="Reset"
              onClick={() =>
                act('reset_external_pressure', {
                  id_tag,
                })
              }
            />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

export const Scrubber = (props) => {
  const { scrubber } = props;
  const { act } = useBackend();
  const { long_name, power, scrubbing, id_tag, widenet, filters } = scrubber;
  return (
    <Section
      level={2}
      title={decodeHtmlEntities(long_name)}
      buttons={
        <Button
          icon={power ? 'power-off' : 'times'}
          content={power ? 'On' : 'Off'}
          selected={power}
          onClick={() =>
            act('power', {
              id_tag,
              val: Number(!power),
            })
          }
        />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button
            icon={scrubbing ? 'filter' : 'sign-in-alt'}
            color={scrubbing || 'danger'}
            content={scrubbing ? 'Scrubbing' : 'Siphoning'}
            onClick={() =>
              act('scrubbing', {
                id_tag,
                val: Number(!scrubbing),
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Filters">
          {(scrubbing &&
            filters.map((filter) => (
              <Button
                key={filter.name}
                icon={filter.val ? 'check-square-o' : 'square-o'}
                content={filter.name}
                title={filter.name}
                selected={filter.val}
                onClick={() =>
                  act(filter.command, {
                    id_tag,
                    val: !filter.val,
                  })
                }
              />
            ))) ||
            'N/A'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
