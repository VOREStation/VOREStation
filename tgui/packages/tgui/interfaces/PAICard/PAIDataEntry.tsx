import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { genderToColor, genderToIcon } from './constants';
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
              <Icon name={genderToIcon[gender]} />
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
      <Stack.Item grow>
        <Stack fill>
          <PaiIcon
            color={eyecolor}
            icon={sprite_datum_class}
            size={sprite_datum_size}
            chassis={chassis}
          />
          <Stack.Divider />
          <Stack.Item grow>
            <Section scrollable={detailed} fill>
              <Stack vertical>
                <Stack.Item>
                  <Box inline preserveWhitespace color="label">
                    {'Role: '}
                  </Box>
                  {role}
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item>
                  <Box inline preserveWhitespace color="label">
                    {'Ad: '}
                  </Box>
                  {ad}
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      {detailed && (
        <Stack.Item grow>
          <Section scrollable fill>
            <Box inline preserveWhitespace color="label">
              {'Description: '}
            </Box>
            {description}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};
