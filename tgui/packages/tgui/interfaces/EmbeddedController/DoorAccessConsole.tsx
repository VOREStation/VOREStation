import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

import { PanelOpen } from './PanelOpen';
import type { DoorAccessConsoleData } from './types';

/**
 * Airlock but without anything other than doors. Separates clean rooms.
 * Replaces door_access_console.tmpl
 */
export const DoorAccessConsole = (props) => {
  const { act, data } = useBackend<DoorAccessConsoleData>();

  const { interior_status, exterior_status, panel_open } = data;

  const interiorOpen =
    interior_status.state === 'open' || exterior_status.state === 'closed';
  const exteriorOpen =
    exterior_status.state === 'open' || interior_status.state === 'closed';

  return (
    <>
      <Section
        title="Status"
        buttons={
          <>
            {/* Interior Button */}
            <Button
              icon={interiorOpen ? 'arrow-left' : 'exclamation-triangle'}
              onClick={() => {
                act(interiorOpen ? 'cycle_ext_door' : 'force_ext');
              }}
            >
              {interiorOpen ? 'Cycle To Exterior' : 'Lock Exterior Door'}
            </Button>
            {/* Exterior Button */}
            <Button
              icon={exteriorOpen ? 'arrow-right' : 'exclamation-triangle'}
              onClick={() => {
                act(exteriorOpen ? 'cycle_int_door' : 'force_int');
              }}
            >
              {exteriorOpen ? 'Cycle To Interior' : 'Lock Interior Door'}
            </Button>
          </>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Exterior Door Status">
            {exterior_status.state === 'closed' ? 'Locked' : 'Open'}
          </LabeledList.Item>
          <LabeledList.Item label="Interior Door Status">
            {interior_status.state === 'closed' ? 'Locked' : 'Open'}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      {!!panel_open && <PanelOpen />}
    </>
  );
};
