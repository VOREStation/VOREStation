import { useBackend } from 'tgui/backend';
import { Button, Icon, Section, Stack, Tooltip } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import { gender2icon } from '../PreferencesMenu/bay_prefs/general/functions';
import { genderToColor } from './constants';
import { PaiIcon } from './PaiIcon';
import type { Data, DetailedInvitePAIData } from './types';

export const PAIDataEntry = (props: {
  paiEntry: DetailedInvitePAIData;
  detailed?: boolean;
}) => {
  const { act } = useBackend<Data>();

  const { paiEntry, detailed } = props;

  const {
    ref,
    name,
    gender,
    role,
    ad,
    eyecolor,
    chassis,
    sprite_datum_class,
    sprite_datum_size,
    description,
    comments,
  } = paiEntry;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack>
          <Stack.Item bold color="label">
            {name}
          </Stack.Item>
          <Stack.Item grow bold color={genderToColor[gender]}>
            <Tooltip content={gender}>
              <Icon name={gender2icon(capitalize(gender))} />
            </Tooltip>
          </Stack.Item>
          <Stack.Item>
            {detailed ? (
              <Button
                icon="arrow-left-long"
                onClick={() => act('clear_preview')}
              >
                Return
              </Button>
            ) : (
              <Button icon="bars" onClick={() => act('preview', { ref: ref })}>
                Details
              </Button>
            )}
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="lightbulb-o"
              onClick={() => act('select_pai', { ref: ref })}
            >
              Invite
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow={2}>
        <Stack fill>
          <PaiIcon
            color={eyecolor}
            icon={sprite_datum_class}
            size={sprite_datum_size}
            chassis={chassis}
          />
          <Stack.Divider />
          <Stack.Item grow>
            <Stack fill vertical>
              <Stack.Item grow>
                <Section scrollable={detailed} fill title="Role">
                  {role}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section scrollable={detailed} fill title="Ad">
                  {ad}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      {detailed && (
        <>
          <Stack.Item grow>
            <Section scrollable fill title="Description">
              {description}
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section scrollable fill title="OOC Notes">
              {comments}
            </Section>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};
