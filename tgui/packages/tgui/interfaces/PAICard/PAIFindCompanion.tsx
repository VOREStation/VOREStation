import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { PaiPreview } from '../PaiChoose/PaiPreview';
import { PaiIcon } from './PaiIcon';
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
        <Stack>
          {availablePais.map((paiEntry) => (
            <Stack.Item grow key={paiEntry.ref} height="200px">
              <Stack vertical fill>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow bold color="label">
                      {paiEntry.name}
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="lightbulb-o"
                        onClick={() => act('select_pai', { key: paiEntry.ref })}
                      >
                        Invite
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item grow>
                  <Stack fill>
                    <PaiIcon
                      color={paiEntry.eyecolor}
                      icon={paiEntry.sprite_datum_class}
                      size={paiEntry.sprite_datum_size}
                      chassis={paiEntry.chassis}
                    />
                    <Stack.Divider />
                    <Stack.Item grow>
                      <Section scrollable fill>
                        <Stack vertical>
                          <Stack.Item>
                            <LabeledList>
                              <LabeledList.Item label="Role">
                                {paiEntry.role}
                              </LabeledList.Item>
                            </LabeledList>
                          </Stack.Item>
                          <Stack.Divider />
                          <Stack.Item>{paiEntry.ad}</Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Divider />
              </Stack>
            </Stack.Item>
          ))}
        </Stack>
      )) ||
        'Awaiting Response...'}
    </Section>
  );
};
