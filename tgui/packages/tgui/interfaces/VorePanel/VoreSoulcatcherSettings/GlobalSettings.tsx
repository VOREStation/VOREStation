import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

export const GlobalSettings = (props: {
  ext_hearing: BooleanLike;
  ext_vision: BooleanLike;
  mind_backups: BooleanLike;
  sr_projecting: BooleanLike;
  see_sr_projecting: BooleanLike;
  show_vore_sfx: BooleanLike;
}) => {
  const { act } = useBackend();

  const {
    ext_hearing,
    ext_vision,
    mind_backups,
    sr_projecting,
    see_sr_projecting,
    show_vore_sfx,
  } = props;

  return (
    <LabeledList.Item label="Global Settings">
      <Box>
        <Button
          icon={ext_hearing ? 'ear-listen' : 'ear-deaf'}
          tooltip={
            (ext_hearing ? 'Allow' : 'Disallow') +
            ' your captured souls to hear.'
          }
          tooltipPosition="bottom"
          color={ext_hearing ? 'green' : 'red'}
          onClick={() => act('toggle_ext_hearing')}
        >
          Ext. Hearing
        </Button>
        <Button
          icon={ext_vision ? 'eye' : 'eye-slash'}
          tooltip={
            (ext_vision ? 'Allow' : 'Disallow') + ' your captured souls to see.'
          }
          tooltipPosition="bottom"
          color={ext_vision ? 'green' : 'red'}
          onClick={() => act('toggle_ext_vision')}
        >
          Ext. Vision
        </Button>
        <Button
          icon="database"
          tooltip={
            (mind_backups ? 'Allow' : 'Disallow') +
            ' your captured souls to have regular mind backups.'
          }
          tooltipPosition="bottom"
          color={mind_backups ? 'green' : 'red'}
          onClick={() => act('toggle_mind_backup')}
        >
          Mind Backups
        </Button>
        <Button
          icon="street-view"
          tooltip={
            (sr_projecting ? 'Allow' : 'Disallow') +
            ' your captured souls to SR project themselves.'
          }
          tooltipPosition="bottom"
          color={sr_projecting ? 'green' : 'red'}
          onClick={() => act('toggle_sr_projecting')}
        >
          SR Projecting
        </Button>
        <Button
          icon="eye-low-vision"
          tooltip={
            (see_sr_projecting ? 'Enable' : 'Disable') +
            ' SR vision to ' +
            (see_sr_projecting ? 'see' : 'hide') +
            ' projecting souls.'
          }
          tooltipPosition="bottom"
          color={see_sr_projecting ? 'green' : 'red'}
          onClick={() => act('toggle_sr_vision')}
        >
          SR Vision
        </Button>
        <Button
          icon={show_vore_sfx ? 'circle-play' : 'circle-pause'}
          tooltip={
            (show_vore_sfx ? 'Show' : 'Hide') +
            ' the selected interior SFX to your captured souls.'
          }
          tooltipPosition="bottom"
          color={show_vore_sfx ? 'green' : 'red'}
          onClick={() => act('toggle_vore_sfx')}
        >
          Show SFX
        </Button>
      </Box>
    </LabeledList.Item>
  );
};
