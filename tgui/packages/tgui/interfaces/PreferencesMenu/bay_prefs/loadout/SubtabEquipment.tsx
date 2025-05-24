import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Stack } from 'tgui-core/components';

import {
  type LoadoutData,
  type LoadoutDataConstant,
  type LoadoutDataStatic,
} from './data';

export const SubtabEquipment = (props: {
  data: LoadoutData;
  staticData: LoadoutDataStatic;
  serverData: LoadoutDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const {
    headset_type,
    backpack_type,
    pda_type,
    communicator_visibility,
    ringtone,
    shoes,
    jacket,
  } = data;

  const { backbaglist, headsetlist, pdachoicelist } = serverData;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <LabeledList>
          {data.underwear.map((underwear, i) => (
            <LabeledList.Item
              key={underwear.category}
              label={underwear.category}
            >
              <Button
                fluid
                onClick={() =>
                  act('change_underwear', { underwear: underwear.category })
                }
              >
                {underwear.name}
              </Button>
              {underwear.tweaks.map((tweak) => (
                <Button
                  fluid
                  key={tweak.ref}
                  onClick={() =>
                    act('underwear_tweak', {
                      underwear: underwear.category,
                      tweak: tweak.ref,
                    })
                  }
                >
                  {/* eslint-disable-next-line react/no-danger */}
                  <div dangerouslySetInnerHTML={{ __html: tweak.contents }} />
                </Button>
              ))}
            </LabeledList.Item>
          ))}
          <LabeledList.Item label="Communicator Visibile">
            <Button onClick={() => act('toggle_comm_visibility')}>
              {communicator_visibility ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Ringtone">
            <Button onClick={() => act('set_ringtone')}>
              {ringtone || 'None'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Spawn With Shoes">
            <Button onClick={() => act('toggle_shoes')}>
              {shoes ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Spawn With Jacket">
            <Button onClick={() => act('toggle_jacket')}>
              {jacket ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
        <Box>
          <Box bold>Headset Type</Box>
          {headsetlist.map((item, i) => (
            <Button
              key={item}
              onClick={() => act('change_headset', { headset: i })}
              selected={item === headset_type}
            >
              {item}
            </Button>
          ))}
        </Box>
        <Box>
          <Box bold>Backpack Type</Box>
          {backbaglist.map((item, i) => (
            <Button
              key={item}
              onClick={() => act('change_backpack', { backbag: i })}
              selected={item === backpack_type}
            >
              {item}
            </Button>
          ))}
        </Box>
        <Box>
          <Box bold>PDA Type</Box>
          {pdachoicelist.map((item, i) => (
            <Button
              key={item}
              onClick={() => act('change_pda', { pda: i })}
              selected={item === pda_type}
            >
              {item}
            </Button>
          ))}
        </Box>
      </Stack.Item>
    </Stack>
  );
};
