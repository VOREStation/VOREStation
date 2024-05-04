import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Holodeck = (props) => {
  const { act, data } = useBackend();

  const {
    supportedPrograms,
    restrictedPrograms,
    currentProgram,
    isSilicon,
    safetyDisabled,
    emagged,
    gravity,
  } = data;

  let programsToShow = supportedPrograms;

  if (safetyDisabled) {
    programsToShow = programsToShow.concat(restrictedPrograms);
  }

  return (
    <Window width={400} height={610}>
      <Window.Content scrollable>
        <Section title="Programs">
          {programsToShow.map((prog) => (
            <Button
              key={prog}
              color={restrictedPrograms.indexOf(prog) !== -1 ? 'bad' : null}
              icon="eye"
              content={prog}
              selected={currentProgram === prog}
              fluid
              onClick={() => act('program', { program: prog })}
            />
          ))}
        </Section>
        {!!isSilicon && (
          <Section title="Override">
            <Button
              icon="exclamation-triangle"
              fluid
              disabled={emagged}
              color={safetyDisabled ? 'good' : 'bad'}
              onClick={() => act('AIoverride')}
            >
              {!!emagged && 'Error, unable to control. '}
              {safetyDisabled ? 'Enable Safeties' : 'Disable Safeties'}
            </Button>
          </Section>
        )}
        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Safeties">
              {safetyDisabled ? (
                <Box color="bad">DISABLED</Box>
              ) : (
                <Box color="good">ENABLED</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Gravity">
              <Button
                icon="user-astronaut"
                selected={gravity}
                onClick={() => act('gravity')}
              >
                {gravity ? 'Enabled' : 'Disabled'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
