import 'tgui/styles/interfaces/Recyclers.scss';

import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Image, Section, Stack } from 'tgui-core/components';

type Data = {
  heldItemName: string | null;
  heldItemValue: string | null;
  itemIcon: string;
  userName: string;
  userBalance: number;
};

export const RecyclerInterface = (props) => {
  const { act, data } = useBackend<Data>();

  const { heldItemName, heldItemValue, itemIcon, userName, userBalance } = data;

  return (
    <Window theme="crtsoul" title="Recycler">
      <Window.Content>
        <Section title="RSG Recycling Interface Input Terminal">
          <Stack align="center" direction="row">
            <Stack.Item justify-content="center">
              <Image src={resolveAsset('recycle.gif')} maxWidth="152px" />
            </Stack.Item>

            <Stack.Item align="center">
              <Box as="logo-container" inline>
                <Image src={resolveAsset('logo.png')} />
              </Box>
            </Stack.Item>
          </Stack>

          <Section title=" ">
            <Box className="RecyclerProductLabel">
              Welcome back, {userName}!
            </Box>
            <Box className="RecyclerProductLabel">
              Your Balance Is: {userBalance}!
            </Box>
            <Stack align="center" direction="Row">
              <Stack.Item>
                <Box className="image-container" inline>
                  <Image src={itemIcon.substring(1, itemIcon.length - 1)} />
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Stack align="left" direction="column">
                  <Stack.Item>
                    Current Object: {heldItemName || 'Empty'}{' '}
                  </Stack.Item>
                  <Stack.Item>
                    Estimated Recycle Value: {heldItemValue || '???'}{' '}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
            <Stack align="left" direction="row" wrap="wrap-reverse">
              <Stack.Item>
                <Button content="Open the door" onClick={() => act('open')} />
              </Stack.Item>
              <Stack.Item>
                <Button content="Close the door" onClick={() => act('close')} />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Eject the current item"
                  onClick={() => act('eject')}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Recycle the current item"
                  onClick={() => act('recycle')}
                />
              </Stack.Item>
            </Stack>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
