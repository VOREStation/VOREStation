import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { OvermapFlightData } from './common/Overmap';

export const OvermapNavigation = (props, context) => {
  return (
    <Window width={380} height={530} resizable>
      <Window.Content>
        <OvermapNavigationContent />
      </Window.Content>
    </Window>
  );
};

export const OvermapNavigationContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { sector, s_x, s_y, sector_info, viewing } = data;
  return (
    <Fragment>
      <Section
        title="Current Location"
        buttons={
          <Button icon="eye" selected={viewing} onClick={() => act('viewing')}>
            Map View
          </Button>
        }>
        <LabeledList>
          <LabeledList.Item label="Current Location">{sector}</LabeledList.Item>
          <LabeledList.Item label="Coordinates">
            {s_x} : {s_y}
          </LabeledList.Item>
          <LabeledList.Item label="Additional Information">{sector_info}</LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Flight Data">
        <OvermapFlightData disableLimiterControls />
      </Section>
    </Fragment>
  );
};
