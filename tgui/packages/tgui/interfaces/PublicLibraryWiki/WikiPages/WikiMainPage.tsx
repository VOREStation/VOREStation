import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
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
          <LabeledList>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('foodsearch')}>
                Food Recipes
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('drinksearch')}>
                Drink Recipes
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('chemsearch')}>
                Chemistry
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('botsearch')}>
                Botany
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('oresearch')}>
                Ores
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('matsearch')}>
                Materials
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('smashsearch')}>
                Particle Physics
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button icon="search" onClick={() => act('catalogsearch')}>
                Catalogs
              </Button>
            </LabeledList.Item>
            <LabeledList.Item />
            <LabeledList.Item>
              <Button
                icon="download"
                onClick={() => act('crash')}
                color={displayedAds[2]}
              >
                {displayedAds[0]}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item>
              <Button
                icon="download"
                onClick={() => act('crash')}
                color={displayedAds[3]}
              >
                {displayedAds[1]}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
