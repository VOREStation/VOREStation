import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  activity: BooleanLike;
  degradation: number;
  disk: BooleanLike;
  loaded: string | number;
  sourceName: string;
  locus: string[];
};

export const BotanyEditor = (props) => {
  const { act, data } = useBackend<Data>();

  const { activity, degradation, disk, sourceName, locus, loaded } = data;

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
          {(disk && (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Source">{sourceName}</LabeledList.Item>
                <LabeledList.Item label="Gene Decay">
                  {degradation}%
                </LabeledList.Item>
                <LabeledList.Item label="Locus">{locus}</LabeledList.Item>
              </LabeledList>
              <Button mt={1} icon="eject" onClick={() => act('eject_disk')}>
                Eject Loaded Disk
              </Button>
            </Box>
          )) || <NoticeBox warning>No disk loaded.</NoticeBox>}
        </Section>
        <Section title="Loaded Material">
          {(loaded && (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Target">{loaded}</LabeledList.Item>
              </LabeledList>
              <Button mt={1} icon="cog" onClick={() => act('apply_gene')}>
                Apply Gene Mods
              </Button>
              <Button mt={1} icon="eject" onClick={() => act('eject_packet')}>
                Eject Target
              </Button>
            </Box>
          )) || <NoticeBox warning>No target seed packet loaded.</NoticeBox>}
        </Section>
      </Window.Content>
    </Window>
  );
};
