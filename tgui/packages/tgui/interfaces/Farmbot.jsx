import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const Farmbot = (props) => {
  const { act, data } = useBackend();

  const {
    on,
    locked,
    tank,
    tankVolume,
    tankMaxVolume,
    waters_trays,
    refills_water,
    uproots_weeds,
    replaces_nutriment,
    collects_produce,
    removes_dead,
  } = data;

  return (
    <Window width={450} height={540}>
      <Window.Content scrollable>
        <Section
          title="Automatic Hydroponic Assistance Unit v2.0"
          buttons={
            <Button icon="power-off" selected={on} onClick={() => act('power')}>
              {on ? 'On' : 'Off'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Water Tank">
              {(tank && (
                <ProgressBar value={tankVolume} maxValue={tankMaxVolume}>
                  {tankVolume} / {tankMaxVolume}
                </ProgressBar>
              )) || <Box color="average">No water tank detected.</Box>}
            </LabeledList.Item>
            <LabeledList.Item
              label="Behavior Controls"
              color={locked ? 'good' : 'bad'}
            >
              {locked ? 'Locked' : 'Unlocked'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(!locked && (
          <Section title="Behavior Controls">
            <Section level={2} title="Watering Controls">
              <LabeledList>
                <LabeledList.Item label="Water plants">
                  <Button
                    icon={waters_trays ? 'toggle-on' : 'toggle-off'}
                    selected={waters_trays}
                    onClick={() => act('water')}
                  >
                    {waters_trays ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Refill watertank">
                  <Button
                    icon={refills_water ? 'toggle-on' : 'toggle-off'}
                    selected={refills_water}
                    onClick={() => act('refill')}
                  >
                    {refills_water ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section level={2} title="Weeding controls">
              <LabeledList>
                <LabeledList.Item label="Weed plants">
                  <Button
                    icon={uproots_weeds ? 'toggle-on' : 'toggle-off'}
                    selected={uproots_weeds}
                    onClick={() => act('weed')}
                  >
                    {uproots_weeds ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section level={2} title="Nutriment controls">
              <LabeledList>
                <LabeledList.Item label="Replace fertilizer">
                  <Button
                    icon={replaces_nutriment ? 'toggle-on' : 'toggle-off'}
                    selected={replaces_nutriment}
                    onClick={() => act('replacenutri')}
                  >
                    {replaces_nutriment ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            {/* VOREStation Edit: No automatic hydroponics with the lagbot */}
            {/* <Section level={2} title="Plant controls">
              <LabeledList>
                <LabeledList.Item label="Collect produce">
                  <Button
                    icon={collects_produce ? "toggle-on" : "toggle-off"}
                    selected={collects_produce}
                    onClick={() => act("collect")}>
                    {collects_produce ? "Yes" : "No"}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Remove dead plants">
                  <Button
                    icon={removes_dead ? "toggle-on" : "toggle-off"}
                    selected={removes_dead}
                    onClick={() => act("removedead")}>
                    {removes_dead ? "Yes" : "No"}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section> */}
            {/* VOREStation Edit End */}
          </Section>
        )) ||
          null}
      </Window.Content>
    </Window>
  );
};
