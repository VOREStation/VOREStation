import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type PAIRequest = {
  key: string;
  name: string | null;
  description: string | null;
  ad: string | null;
  eyecolor: string;
  chassis: string;
  emotion: string;
  gender: string;
};

type Data = {
  has_pai: BooleanLike;
  available_pais: PAIRequest[];
  name: string;
  color: string;
  chassis: string;
  health: number;
  law_zero: string;
  law_extra: string;
  master_name: string | null;
  master_dna: string | null;
  radio: BooleanLike;
  radio_transmit: BooleanLike;
  radio_recieve: BooleanLike;
  screen_msg: string | null;
};

export const pAICard = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    has_pai,
    name,
    health,
    law_zero,
    law_extra,
    master_name,
    master_dna,
    available_pais,
    radio,
    radio_transmit,
    radio_recieve,
    screen_msg,
  } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content scrollable>
        {(has_pai && (
          <Box>
            <Section title={name}>{screen_msg}</Section>
            <Section title="Integrity">{health}</Section>
            <Section
              title="Owner"
              buttons={
                <Button
                  icon="lightbulb-o"
                  disabled={!!master_name && !!master_dna}
                  onClick={() => act('setdna')}
                >
                  Imprint DNA
                </Button>
              }
            >
              {(!!master_name && !!master_dna) ??
                (`${master_name} : ${master_dna}` || 'unbound')}
            </Section>
            <Section title="Prime directive:">{law_zero}</Section>
            <Section
              title="Additional directives:"
              buttons={
                <Button icon="lightbulb-o" onClick={() => act('setlaws')}>
                  Configure
                </Button>
              }
            >
              {law_extra}
            </Section>
            <Section title="Radio Uplink">
              {
                // don't obliterate me kash, this is intentionally temp as hell, replace with the actual radio headset buttons, maybe we add frequency?
                radio ??
                  (`Radio settings ${radio_recieve} | ${radio_transmit}` ||
                    'Radio firmware not loaded. Please install a pAI personality to load firmware.')
              }
            </Section>
          </Box>
        )) || (
          <Section title="Find Companion">
            <LabeledList>
              {available_pais.map((data) => (
                <LabeledList.Item
                  key={data.key}
                  label={data.name}
                  buttons={
                    <Button
                      icon="lightbulb-o"
                      onClick={() => act('select_pai', { key: data.key })}
                    >
                      Invite
                    </Button>
                  }
                >
                  INFO:
                  {data.key}
                  {data.name}
                  {data.ad}
                  {data.description}
                  {data.eyecolor}
                  {data.chassis}
                  {data.emotion}
                  {data.gender}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
