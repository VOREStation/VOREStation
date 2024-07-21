import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';
import { Data } from './types';

export const RCONBreakerList = (props) => {
  const { act, data } = useBackend<Data>();

  const { breaker_info } = data;

  return (
    <Section title="Breakers">
      <LabeledList>
        {breaker_info ? (
          breaker_info.map((breaker) => (
            <LabeledList.Item
              key={breaker.RCON_tag}
              label={breaker.RCON_tag}
              buttons={
                <Button
                  icon="power-off"
                  selected={breaker.enabled}
                  color={breaker.enabled ? null : 'bad'}
                  onClick={() =>
                    act('toggle_breaker', {
                      breaker: breaker.RCON_tag,
                    })
                  }
                >
                  {breaker.enabled ? 'Enabled' : 'Disabled'}
                </Button>
              }
            />
          ))
        ) : (
          <LabeledList.Item color="bad">No breakers detected.</LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
