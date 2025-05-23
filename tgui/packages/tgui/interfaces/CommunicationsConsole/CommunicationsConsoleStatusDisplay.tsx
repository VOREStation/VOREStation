import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

import type { Data } from './types';

export const CommunicationsConsoleStatusDisplay = (props) => {
  const { act, data } = useBackend<Data>();

  const { stat_display, authenticated } = data;

  let presetButtons = stat_display['presets'].map((pb) => {
    return (
      <Button
        key={pb.name}
        selected={pb.name === stat_display.type}
        disabled={!authenticated}
        onClick={() => act('setstat', { statdisp: pb.name })}
      >
        {pb.label}
      </Button>
    );
  });
  return (
    <Section
      title="Modify Status Screens"
      buttons={
        <Button icon="arrow-circle-left" onClick={() => act('main')}>
          Back To Main Menu
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Presets">{presetButtons}</LabeledList.Item>
        <LabeledList.Item label="Message Line 1">
          <Button
            icon="pencil-alt"
            disabled={!authenticated}
            onClick={() => act('setmsg1')}
          >
            {stat_display.line_1}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Message Line 2">
          <Button
            icon="pencil-alt"
            disabled={!authenticated}
            onClick={() => act('setmsg2')}
          >
            {stat_display.line_2}
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
