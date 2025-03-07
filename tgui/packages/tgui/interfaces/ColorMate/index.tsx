import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Image,
  NoticeBox,
  Section,
  Table,
  Tabs,
} from 'tgui-core/components';

import { ColorMateHSV, ColorMateTint } from './ColorMateColor';
import { ColorMateMatrix } from './ColorMateMatrix';
import type { Data } from './types';

export const ColorMate = (props) => {
  const { act, data } = useBackend<Data>();

  const { activemode, temp, item } = data;

  const tab: React.JSX.Element[] = [];

  tab[1] = <ColorMateTint />;
  tab[2] = <ColorMateHSV />;
  tab[3] = <ColorMateMatrix />;

  return (
    <Window width={980} height={720}>
      <Window.Content overflow="auto">
        <Section>
          {temp ? <NoticeBox>{temp}</NoticeBox> : null}
          {item && Object.keys(item).length ? (
            <>
              <Table>
                <Table.Cell width="50%">
                  <Section>
                    <center>Item:</center>
                    <Image
                      src={'data:image/jpeg;base64, ' + item.sprite}
                      style={{
                        width: '100%',
                        height: '100%',
                      }}
                    />
                  </Section>
                </Table.Cell>
                <Table.Cell>
                  <Section>
                    <center>Preview:</center>
                    <Image
                      src={'data:image/jpeg;base64, ' + item.preview}
                      style={{
                        width: '100%',
                        height: '100%',
                      }}
                    />
                  </Section>
                </Table.Cell>
              </Table>
              <Tabs fluid>
                <Tabs.Tab
                  key="1"
                  selected={activemode === 1}
                  onClick={() =>
                    act('switch_modes', {
                      mode: 1,
                    })
                  }
                >
                  Tint coloring (Simple)
                </Tabs.Tab>
                <Tabs.Tab
                  key="2"
                  selected={activemode === 2}
                  onClick={() =>
                    act('switch_modes', {
                      mode: 2,
                    })
                  }
                >
                  HSV coloring (Normal)
                </Tabs.Tab>
                <Tabs.Tab
                  key="3"
                  selected={activemode === 3}
                  onClick={() =>
                    act('switch_modes', {
                      mode: 3,
                    })
                  }
                >
                  Matrix coloring (Advanced)
                </Tabs.Tab>
              </Tabs>
              <center>Coloring: {item.name}</center>
              <Table mt={1}>
                <Table.Cell width="33%">
                  <Button fluid icon="fill" onClick={() => act('paint')}>
                    Paint
                  </Button>
                  <Button fluid icon="eraser" onClick={() => act('clear')}>
                    Clear
                  </Button>
                  <Button fluid icon="eject" onClick={() => act('drop')}>
                    Eject
                  </Button>
                </Table.Cell>
                <Table.Cell width="66%">
                  {tab[activemode] || <Box textColor="red">Error</Box>}
                </Table.Cell>
              </Table>
            </>
          ) : (
            <center>No item inserted.</center>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
