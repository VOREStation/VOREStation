import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { single_scrubber, single_vent } from './CommonTypes';

type vent = { vent: single_vent };
type scrubber = { scrubber: single_scrubber };

export const Vent = (props: vent) => {
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
      title={decodeHtmlEntities(long_name)}
      buttons={
        <Button
          icon={power ? 'power-off' : 'times'}
          selected={power}
          onClick={() =>
            act('power', {
              id_tag,
              val: Number(!power),
            })
          }
        >
          {power ? 'On' : 'Off'}
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button
            icon="sign-in-alt"
            color={direction === 'siphon' && 'danger'}
            onClick={() =>
              act('direction', {
                id_tag,
                val: Number(direction === 'siphon'),
              })
            }
          >
            {direction !== 'siphon' ? 'Pressurizing' : 'Siphoning'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Pressure Regulator">
          <Button
            icon="sign-in-alt"
            selected={incheck}
            onClick={() =>
              act('incheck', {
                id_tag,
                val: checks,
              })
            }
          >
            Internal
          </Button>
          <Button
            icon="sign-out-alt"
            selected={excheck}
            onClick={() =>
              act('excheck', {
                id_tag,
                val: checks,
              })
            }
          >
            External
          </Button>
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
              onChange={(value) =>
                act('set_internal_pressure', {
                  id_tag,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={intdefault}
              onClick={() =>
                act('reset_internal_pressure', {
                  id_tag,
                })
              }
            >
              Reset
            </Button>
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
              onChange={(value) =>
                act('set_external_pressure', {
                  id_tag,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={extdefault}
              onClick={() =>
                act('reset_external_pressure', {
                  id_tag,
                })
              }
            >
              Reset
            </Button>
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

export const Scrubber = (props: scrubber) => {
  const { scrubber } = props;
  const { act } = useBackend();
  const { long_name, power, scrubbing, id_tag, filters } = scrubber;
  return (
    <Section
      title={decodeHtmlEntities(long_name)}
      buttons={
        <Button
          icon={power ? 'power-off' : 'times'}
          selected={power}
          onClick={() =>
            act('power', {
              id_tag,
              val: Number(!power),
            })
          }
        >
          {power ? 'On' : 'Off'}
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button
            icon={scrubbing ? 'filter' : 'sign-in-alt'}
            color={scrubbing || 'danger'}
            onClick={() =>
              act('scrubbing', {
                id_tag,
                val: Number(!scrubbing),
              })
            }
          >
            {scrubbing ? 'Scrubbing' : 'Siphoning'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Filters">
          {(scrubbing &&
            filters.map((filter) => (
              <Button
                key={filter.name}
                icon={filter.val ? 'check-square-o' : 'square-o'}
                selected={filter.val}
                onClick={() =>
                  act(filter.command, {
                    id_tag,
                    val: !filter.val,
                  })
                }
              >
                {filter.name}
              </Button>
            ))) ||
            'N/A'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
