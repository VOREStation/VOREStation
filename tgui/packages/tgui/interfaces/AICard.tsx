import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  name: string;
  has_ai: BooleanLike;
  integrity: number;
  backup_capacitor: number;
  flushing: BooleanLike;
  has_laws: BooleanLike;
  laws: string[];
  wireless: BooleanLike;
  radio: BooleanLike;
};

export const AICard = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    name,
    has_ai,
    integrity,
    backup_capacitor,
    flushing,
    has_laws,
    laws,
    wireless,
    radio,
  } = data;

  if (!has_ai) {
    return (
      <Window width={600} height={470}>
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
    let integrityColor: string | undefined; // Handles changing color of the integrity bar
    if (integrity >= 75) {
      integrityColor = 'green';
    } else if (integrity >= 25) {
      integrityColor = 'yellow';
    } else {
      integrityColor = 'red';
    }

    let powerColor: string | undefined;
    if (backup_capacitor >= 75) {
      powerColor = 'green';
    }
    if (backup_capacitor >= 25) {
      powerColor = 'yellow';
    } else {
      powerColor = 'red';
    }

    return (
      <Window width={600} height={470}>
        <Window.Content scrollable>
          <Section title="Stored AI">
            <Box bold inline>
              <h3>{name}</h3>
            </Box>
            <Box>
              <LabeledList>
                <LabeledList.Item label="Integrity">
                  <ProgressBar color={integrityColor} value={integrity / 100} />
                </LabeledList.Item>
                <LabeledList.Item label="Power">
                  <ProgressBar
                    color={powerColor}
                    value={backup_capacitor / 100}
                  />
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
                  <Box key={key} inline>
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
                  color={wireless ? 'green' : 'red'}
                  onClick={() => act('wireless')}
                >
                  {wireless ? 'Enabled' : 'Disabled'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Subspace Transceiver">
                <Button
                  icon={radio ? 'check' : 'times'}
                  color={radio ? 'green' : 'red'}
                  onClick={() => act('radio')}
                >
                  {radio ? 'Enabled' : 'Disabled'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="AI Power">
                <Button.Confirm
                  icon="radiation"
                  confirmIcon="radiation"
                  disabled={flushing || integrity === 0}
                  confirmColor="red"
                  onClick={() => act('wipe')}
                >
                  Shutdown
                </Button.Confirm>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Window.Content>
      </Window>
    );
  }
};
