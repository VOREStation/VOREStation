import { Stack } from 'tgui-core/components';
import { intentMappings } from '../../constants';
import type { IntentData } from '../../types';
import { VorePanelTooltip } from '../../VorePanelElements/VorePanelTooltip';

export const VoreContentIntent = (props: { intent_data: IntentData }) => {
  const { intent_data } = props;

  return (
    !!intent_data.active &&
    intentMappings.map(({ key, label, color, tooltip }) => (
      <Stack.Item key={key}>
        <VorePanelTooltip
          tooltip={tooltip(!!intent_data[key])}
          displayText={label}
          color={intent_data[key] ? color : 'transparent'}
          selected={intent_data.current_intent === key}
        />
      </Stack.Item>
    ))
  );
};
