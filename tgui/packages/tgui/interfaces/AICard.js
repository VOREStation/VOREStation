import { useBackend } from '../backend';
import { Button, ProgressBar, LabeledList, Box, Section } from '../components';
import { Window } from '../layouts';

export const AICard = (props, context) => {
  const { act, data } = useBackend(context);

  const { has_ai, integrity, backup_capacitor, flushing, has_laws, laws, wireless, radio } = data;

  if (has_ai === 0) {
    return (
      <Window width={600} height={470} resizable>
        <Window.Content>
          <Section title="Stored AI">
            <Box>
              <h3>No AI detected.</h3>
            </Box>
          </Section>
        </Window.Content>
      </Window>
    );
  } else {
    let integrityColor = null; // Handles changing color of the integrity bar
    if (integrity >= 75) {
      integrityColor = 'green';
    } else if (integrity >= 25) {
      integrityColor = 'yellow';
    } else {
      integrityColor = 'red';
    }

    let powerColor = null;
    if (backup_capacitor >= 75) {
      powerColor = 'green';
    }
    if (backup_capacitor >= 25) {
      powerColor = 'yellow';
    } else {
      powerColor = 'red';
    }

    return (
      <Window width={600} height={470} resizable>
        <Window.Content scrollable>
          <Section title="Stored AI">
            <Box bold display="inline-block">
              <h3>{name}</h3>
            </Box>
            <Box>
              <LabeledList>
                <LabeledList.Item label="Integrity">
                  <ProgressBar color={integrityColor} value={integrity / 100} />
                </LabeledList.Item>
                <LabeledList.Item label="Power">
                  <ProgressBar color={powerColor} value={backup_capacitor / 100} />
                </LabeledList.Item>
              </LabeledList>
            </Box>
            <Box color="red">
              <h2>{flushing === 1 ? 'Wipe of AI in progress...' : ''}</h2>
            </Box>
          </Section>

          <Section title="Laws">
            {(!!has_laws && (
              <Box>
                {laws.map((value, key) => (
                  <Box key={key} display="inline-block">
                    {value}
                  </Box>
                ))}
              </Box>
            )) || ( // Else, no laws.
              <Box color="red">
                <h3>No laws detected.</h3>
              </Box>
            )}
          </Section>

          <Section title="Actions">
            <LabeledList>
              <LabeledList.Item label="Wireless Activity">
                <Button
                  icon={wireless ? 'check' : 'times'}
                  content={wireless ? 'Enabled' : 'Disabled'}
                  color={wireless ? 'green' : 'red'}
                  onClick={() => act('wireless')}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Subspace Transceiver">
                <Button
                  icon={radio ? 'check' : 'times'}
                  content={radio ? 'Enabled' : 'Disabled'}
                  color={radio ? 'green' : 'red'}
                  onClick={() => act('radio')}
                />
              </LabeledList.Item>
              <LabeledList.Item label="AI Power">
                <Button.Confirm
                  icon="radiation"
                  confirmIcon="radiation"
                  disabled={flushing || integrity === 0}
                  confirmColor="red"
                  content="Shutdown"
                  onClick={() => act('wipe')}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Window.Content>
      </Window>
    );
  }
};
