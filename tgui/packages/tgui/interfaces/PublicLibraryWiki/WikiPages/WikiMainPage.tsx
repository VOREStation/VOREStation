import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

export const WikiMainPage = (props: { displayedAds: string[] }) => {
  const { act } = useBackend();

  const { displayedAds } = props;

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Box fontSize="18px" bold>
            The galaxys 18th most tollerated
            {
              <Tooltip
                position="bottom"
                content="At least according to our own studies!"
              >
                <Box inline>*</Box>
              </Tooltip>
            }{' '}
            infocore dispenser!
          </Box>
        </Stack.Item>
        <Divider />
        <Stack.Item>
          <Stack fill vertical mt="50px" ml="100px" mr="100px">
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('foodsearch')}>
                Food Recipes
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('drinksearch')}>
                Drink Recipes
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('chemsearch')}>
                Chemistry
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('botsearch')}>
                Botany
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('oresearch')}>
                Ores
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('matsearch')}>
                Materials
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('smashsearch')}>
                Particle Physics
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="search" onClick={() => act('catalogsearch')}>
                Catalogs
              </Button>
            </Stack.Item>
            <Stack.Item />
            <Stack.Item>
              <Button
                fluid
                icon="download"
                onClick={() => act('crash')}
                color={displayedAds[2]}
              >
                {displayedAds[0]}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="download"
                onClick={() => act('crash')}
                color={displayedAds[3]}
              >
                {displayedAds[1]}
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
