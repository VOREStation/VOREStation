import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Dropdown,
  LabeledList,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  drones: {
    name: string;
    active: BooleanLike;
    charge: number;
    maxCharge: number;
    loc: string;
    ref: string;
  }[];
  fabricator: string;
  fabPower: BooleanLike;
  areas: string[];
  selected_area: string;
};

export const DroneConsole = (props) => {
  const { act, data } = useBackend<Data>();

  const { drones, areas, selected_area, fabricator, fabPower } = data;

  return (
    <Window width={600} height={350}>
      <Window.Content scrollable>
        <Section
          title="Drone Fabricator"
          buttons={
            <Button
              disabled={!fabricator}
              selected={fabPower}
              icon="power-off"
              onClick={() => act('toggle_fab')}
            >
              {fabPower ? 'Enabled' : 'Disabled'}
            </Button>
          }
        >
          {!fabricator ? (
            <Box color="bad">
              Fabricator not detected.
              <Button icon="sync" onClick={() => act('search_fab')}>
                Search for Fabricator
              </Button>
            </Box>
          ) : (
            <Box color="good">Linked.</Box>
          )}
        </Section>
        <Section title="Request Drone">
          <Dropdown
            autoScroll={false}
            options={areas ? areas.sort() : []}
            selected={selected_area}
            width="100%"
            onSelected={(val) => act('set_dcall_area', { area: val })}
          />
          <Button icon="share-square" onClick={() => act('ping')}>
            Send Ping
          </Button>
        </Section>
        <Section title="Maintenance Units">
          {drones && drones.length ? (
            <LabeledList>
              {drones.map((drone) => (
                <LabeledList.Item
                  key={drone.name}
                  label={drone.name}
                  buttons={
                    <>
                      <Button
                        icon="sync"
                        onClick={() => act('resync', { ref: drone.ref })}
                      >
                        Resync
                      </Button>
                      <Button.Confirm
                        icon="exclamation-triangle"
                        color="red"
                        onClick={() => act('shutdown', { ref: drone.ref })}
                      >
                        Shutdown
                      </Button.Confirm>
                    </>
                  }
                >
                  <LabeledList>
                    <LabeledList.Item label="Location">
                      {drone.loc}
                    </LabeledList.Item>
                    <LabeledList.Item label="Charge">
                      {drone.charge} / {drone.maxCharge}
                    </LabeledList.Item>
                    <LabeledList.Item label="Active">
                      {drone.active ? 'Yes' : 'No'}
                    </LabeledList.Item>
                  </LabeledList>
                </LabeledList.Item>
              ))}
            </LabeledList>
          ) : (
            <Box color="bad">No drones detected.</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
