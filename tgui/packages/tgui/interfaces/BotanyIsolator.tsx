import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  geneMasks: { tag: string; mask: string }[];
  activity: BooleanLike;
  degradation: number;
  disk: BooleanLike;
  loaded: string | number;
  hasGenetics: BooleanLike;
  sourceName: string;
};

export const BotanyIsolator = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    geneMasks,
    activity,
    degradation,
    disk,
    loaded,
    hasGenetics,
    sourceName,
  } = data;

  if (activity) {
    return (
      <Window width={470} height={500}>
        <Window.Content scrollable>
          <NoticeBox info>Scanning...</NoticeBox>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={470} height={500}>
      <Window.Content scrollable>
        <Section title="Buffered Genetic Data">
          {(hasGenetics && (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Source">{sourceName}</LabeledList.Item>
                <LabeledList.Item label="Gene decay">
                  {degradation}%
                </LabeledList.Item>
                {(disk &&
                  geneMasks.length &&
                  geneMasks.map((mask) => (
                    <LabeledList.Item key={mask.mask} label={mask.mask}>
                      <Button
                        mb={-1}
                        icon="download"
                        onClick={() => act('get_gene', { get_gene: mask.tag })}
                      >
                        Extract
                      </Button>
                    </LabeledList.Item>
                  ))) ||
                  null}
              </LabeledList>
              {(disk && (
                <Box mt={1}>
                  <Button icon="eject" onClick={() => act('eject_disk')}>
                    Eject Loaded Disk
                  </Button>
                  <Button icon="trash" onClick={() => act('clear_buffer')}>
                    Clear Genetic Buffer
                  </Button>
                </Box>
              )) || (
                <NoticeBox mt={1} warning>
                  No disk inserted.
                </NoticeBox>
              )}
            </Box>
          )) || (
            <Box>
              <NoticeBox warning>No Data Buffered.</NoticeBox>
              {(disk && (
                <Button icon="eject" onClick={() => act('eject_disk')}>
                  Eject Loaded Disk
                </Button>
              )) || (
                <NoticeBox mt={1} warning>
                  No disk inserted.
                </NoticeBox>
              )}
            </Box>
          )}
        </Section>
        <Section title="Loaded Material">
          {(loaded && (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Packet Loaded">
                  {loaded}
                </LabeledList.Item>
              </LabeledList>
              <Button mt={1} icon="cog" onClick={() => act('scan_genome')}>
                Process Genome
              </Button>
              <Button icon="eject" onClick={() => act('eject_packet')}>
                Eject Packet
              </Button>
            </Box>
          )) || <NoticeBox warning>No packet loaded.</NoticeBox>}
        </Section>
      </Window.Content>
    </Window>
  );
};
