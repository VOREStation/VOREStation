import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';
import type { Data } from './types';

export const PAIFindCompanion = (props) => {
  const { act, data } = useBackend<Data>();

  const { waiting_for_response, available_pais } = data;

  return (
    <Section title="Find Companion">
      {(!waiting_for_response && (
        <LabeledList>
          {available_pais?.map((data) => (
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
