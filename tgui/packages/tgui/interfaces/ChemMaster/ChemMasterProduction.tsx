import { useBackend } from 'tgui/backend';
import { Button, Icon, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { ChemMasterProductionChemical } from './ChemMasterProductionChemical';
import { ChemMasterProductionCondiment } from './ChemMasterProductionCondiment';

export const ChemMasterProduction = (props: {
  bufferNonEmpty: boolean;
  isCondiment: BooleanLike;
  loaded_pill_bottle: BooleanLike;
  loaded_pill_bottle_name: string;
  loaded_pill_bottle_contents_len: number;
  loaded_pill_bottle_storage_slots: number;
  pillsprite: string;
  bottlesprite: string;
}) => {
  const { act } = useBackend();

  const {
    bufferNonEmpty,
    isCondiment,
    loaded_pill_bottle,
    loaded_pill_bottle_name,
    loaded_pill_bottle_contents_len,
    loaded_pill_bottle_storage_slots,
    pillsprite,
    bottlesprite,
  } = props;

  if (!bufferNonEmpty) {
    return (
      <Section
        title="Production"
        flexGrow
        buttons={
          <Button
            disabled={!loaded_pill_bottle}
            icon="eject"
            mb="0.5rem"
            onClick={() => act('ejectp')}
          >
            {loaded_pill_bottle
              ? loaded_pill_bottle_name +
                ' (' +
                loaded_pill_bottle_contents_len +
                '/' +
                loaded_pill_bottle_storage_slots +
                ')'
              : 'No pill bottle loaded'}
          </Button>
        }
      >
        <Stack height="100%">
          <Stack.Item grow align="center" textAlign="center" color="label">
            <Icon name="tint-slash" mt="0.5rem" mb="0.5rem" size={5} />
            <br />
            Buffer is empty.
          </Stack.Item>
        </Stack>
      </Section>
    );
  }

  return (
    <Section
      title="Production"
      flexGrow
      buttons={
        <Button
          disabled={!loaded_pill_bottle}
          icon="eject"
          mb="0.5rem"
          onClick={() => act('ejectp')}
        >
          {loaded_pill_bottle
            ? loaded_pill_bottle_name +
              ' (' +
              loaded_pill_bottle_contents_len +
              '/' +
              loaded_pill_bottle_storage_slots +
              ')'
            : 'No pill bottle loaded'}
        </Button>
      }
    >
      {!isCondiment ? (
        <ChemMasterProductionChemical
          pillsprite={pillsprite}
          bottlesprite={bottlesprite}
        />
      ) : (
        <ChemMasterProductionCondiment />
      )}
    </Section>
  );
};
