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
      <style>
        @import
        url(&quot;https://fonts.googleapis.com/css2?family=VT323&display=swap&quot;);
      </style>

      <Window.Content>
        <Section title="RSG Recycling Interface Input Terminal">
          <Stack align="center" direction="row">
            <Stack.Item justify-content="center">
              <Image
                src={resolveAsset('recycle.gif')}
                style={{
                  maxWidth: '152px',
                }}
              />
            </Stack.Item>

            <Stack.Item
              align="center"
              style={{ width: '100%', maxWidth: '152px', marginTop: '-8vh' }}
            >
              <Box
                as="logo-container"
                inline
                style={{
                  width: '100%',
                  overflow: 'hidden',
                  // outline: '2px solid #4972a1',
                }}
              >
                <Image
                  src={resolveAsset('logo.png')}
                  style={{
                    width: '100%',
                  }}
                />
              </Box>
            </Stack.Item>
          </Stack>

          <Section title=" " style={{}}>
            <h1>Welcome back, {userName}!</h1>
            <h1>Your Balance Is: {userBalance}!</h1>
            <Stack align="center" direction="Row">
              <Stack.Item>
                <Box
                  as="image-container"
                  inline
                  style={{
                    width: '101px',
                    height: '101px',
                    overflow: 'hidden',
                    outline: '2px solidrgb(7, 77, 14)',
                  }}
                >
                  <Image
                    src={itemIcon.substring(1, itemIcon.length - 1)}
                    style={{
                      width: '100%',
                    }}
                  />
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Stack align="left" direction="column">
                  <Stack.Item>
                    {' '}
                    Current Object: {heldItemName || 'Empty'}{' '}
                  </Stack.Item>
                  <Stack.Item>
                    {' '}
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
                {' '}
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
