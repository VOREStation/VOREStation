import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, NoticeBox } from '../components';
import { Window } from '../layouts';

export const BotanyEditor = (props, context) => {
  const { act, data } = useBackend(context);

  const { activity, degradation, disk, sourceName, locus, loaded } = data;

  if (activity) {
    return (
      <Window width={470} height={500} resizable>
        <Window.Content scrollable>
          <NoticeBox info>Scanning...</NoticeBox>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={470} height={500} resizable>
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
