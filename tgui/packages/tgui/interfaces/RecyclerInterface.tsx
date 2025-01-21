import { resolveAsset } from 'tgui/assets';

import { useBackend } from '../backend';
import { Box, Button, Flex, Image, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  heldItemName: string;
  heldItemValue: string;
  itemIcon: string;

};

export const RecyclerInterface = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    heldItemName,
    heldItemValue,
    itemIcon,
  } = data;

  return (
    <Window theme="crtsoul" title="Recycler">
      <style>
        @import url(&quot;https://fonts.googleapis.com/css2?family=VT323&display=swap&quot;);
      </style>

      <Window.Content>
        <Section title="Temporary Name Co Branded Recycling Interface">
          <Flex align="center" direction="column">
            <Flex.Item>
              <Box key="1" width="100%" align="center">
                <Image
                  src={resolveAsset(
                    "recycle.gif",
                  )}
                  style={{
                    width: '100%',
                  }}
                />
                fsdfsdfsdfsd
              </Box>
            </Flex.Item>
          </Flex>
          <Flex align="center" direction="column">
            <Flex.Item>{heldItemName}</Flex.Item>
            <Box
              inline
              style={{
                width: '101px',
                height: '101px',
                overflow: 'hidden',
                outline: '2px solid #4972a1',
              }}
            >
              <Image
                src={itemIcon.substring(1, itemIcon.length - 1)}
                style={{
                  filter: 'blur(444px)',
                  width: '100%',
                }}
              />
            </Box>
            <Flex.Item>{heldItemValue}</Flex.Item>
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
      </Window.Content>
    </Window >
  );
};
