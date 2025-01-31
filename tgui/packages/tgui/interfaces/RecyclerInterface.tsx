import { resolveAsset } from 'tgui/assets';

import { useBackend } from '../backend';
import { Box, Button, Flex, Image, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  heldItemName: string;
  heldItemValue: string;
  itemIcon: string;
  userName: string;
  userBalance: number;

};

export const RecyclerInterface = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    heldItemName,
    heldItemValue,
    itemIcon,
    userName,
    userBalance,

  } = data;

  return (
    <Window theme="crtsoul" title="Recycler">
      <style>
        @import url(&quot;https://fonts.googleapis.com/css2?family=VT323&display=swap&quot;);
      </style>

      <Window.Content>
        <Section title="Temporary Name Co Branded Recycling Interface">
          <Flex align="center" direction="column">
            <Flex.Item align="center">
              <Image
                src={resolveAsset(
                  "recycle.gif",
                )}
                style={{

                  maxWidth: '152px',
                }}
              />
            </Flex.Item>

            <Flex.Item align="center" style={{ width: '100%', maxWidth: '152px', marginTop: '-8vh' }}>
              <Box as="logo-container"
                inline
                style={{
                  width: '100%',
                  overflow: 'hidden',
                  // outline: '2px solid #4972a1',
                }}
              >
                <Image
                  src={resolveAsset("logo.png")}
                  style={{
                    width: '100%',
                  }}
                />
              </Box>
            </Flex.Item>


          </Flex>

          <Section title=" " style={{

          }}>
            <h1>Welcome back, {userName}!</h1>
            <h1>Your Balance Is: {userBalance}!</h1>
            <Flex align="center" direction="Row">

              <Flex.Item>
                <Box as="image-container"
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
              </Flex.Item>
              <Flex.Item>
                <Flex align="left" direction="column">
                  <Flex.Item> Current Object: {heldItemName || "Empty"} </Flex.Item>
                  <Flex.Item> Estimated Recycle Value: {heldItemValue || "???"} </Flex.Item>
                </Flex>
              </Flex.Item>
            </Flex>
            <Flex align="left" direction="row" wrap="wrap-reverse">
              <Flex.Item>
                <Button
                  content="Open the door"
                  onClick={() => act('open')} />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Close the door"
                  onClick={() => act('close')} />
              </Flex.Item>
              <Flex.Item>            <Button
                content="Eject the current item"
                onClick={() => act('eject')} />
              </Flex.Item>
              <Flex.Item><Button
                content="Recycle the current item"
                onClick={() => act('eject')} />
              </Flex.Item>
            </Flex>
          </Section>


        </Section>
      </Window.Content>
    </Window >
  );
};
