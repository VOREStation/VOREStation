import { useBackend } from '../backend';
import { Box, Button, Dropdown, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const DroneConsole = (props) => {
  const { act, data } = useBackend();

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
              content={fabPower ? 'Enabled' : 'Disabled'}
              onClick={() => act('toggle_fab')}
            />
          }
        >
          {!fabricator ? (
            <Box color="bad">
              Fabricator not detected.
              <Button
                icon="sync"
                content="Search for Fabricator"
                onClick={() => act('search_fab')}
              />
            </Box>
          ) : (
            <Box color="good">Linked.</Box>
          )}
        </Section>
        <Section title="Request Drone">
          <Dropdown
            options={areas ? areas.sort() : null}
            selected={selected_area}
            width="100%"
            onSelected={(val) => act('set_dcall_area', { area: val })}
          />
          <Button
            icon="share-square"
            content="Send Ping"
            onClick={() => act('ping')}
          />
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
                        content="Resync"
                        onClick={() => act('resync', { ref: drone.ref })}
                      />
                      <Button.Confirm
                        icon="exclamation-triangle"
                        color="red"
                        content="Shutdown"
                        onClick={() => act('shutdown', { ref: drone.ref })}
                      />
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
