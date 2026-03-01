import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';
import type { Data, InvitePAIData } from './types';

export const PAIFindCompanion = (props: { availablePais: InvitePAIData[] }) => {
  const { data, act } = useBackend<Data>();

  const { waiting_for_response } = data;
  const { availablePais } = props;

  const {
    ref,
    name,
    ad,
    eyecolor,
    chassis,
    sprite_datum_class,
    sprite_datum_size,
  } = availablePais;

  return (
    <Section fill scrollable title="Find Companion">
      {(!waiting_for_response && (
        <LabeledList>
          {availablePais.map((data) => (
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
      )) ||
        'Awaiting Response...'}
    </Section>
  );
};
