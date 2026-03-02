import { useBackend } from 'tgui/backend';
import { Section, Stack } from 'tgui-core/components';
import { PAIDataEntry } from './PAIDataEntry';
import type { Data, InvitePAIData } from './types';

export const PAIFindCompanion = (props: { availablePais: InvitePAIData[] }) => {
  const { data, act } = useBackend<Data>();

  const { waiting_for_response, selected, selected_pai_data } = data;
  const { availablePais } = props;

  return (
    <Section fill scrollable title="Find Companion">
      {!waiting_for_response ? (
        !selected_pai_data ? (
          <Stack vertical>
            {availablePais.map((paiEntry) => (
              <Stack.Item grow key={paiEntry.ref}>
                <PAIDataEntry paiEntry={paiEntry} />
              </Stack.Item>
            ))}
          </Stack>
        ) : (
          <PAIDataEntry detailed paiEntry={selected_pai_data} />
        )
      ) : (
        'Awaiting Response...'
      )}
    </Section>
  );
};
