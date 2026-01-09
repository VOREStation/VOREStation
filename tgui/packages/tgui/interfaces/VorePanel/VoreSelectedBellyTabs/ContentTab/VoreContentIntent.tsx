import { Stack } from 'tgui-core/components';
import type { IntentData } from '../../types';
import { VorePanelTooltip } from '../../VorePanelElements/VorePanelTooltip';

export const VoreContentIntent = (props: { intent_data: IntentData }) => {
  const { intent_data } = props;

  return (
    !!intent_data.active && (
      <>
        <Stack.Item>
          <VorePanelTooltip
            tooltip={
              intent_data.help
                ? 'Struggling in help intent might cause auto transfer interactions.'
                : 'Help intent struggle auto transfer chance disabled.'
            }
            displayText="Help"
            color={intent_data.help ? 'green' : 'transparent'}
          />
        </Stack.Item>
        <Stack.Item>
          <VorePanelTooltip
            tooltip={
              intent_data.disarm
                ? 'Struggling in disarm intent might cause belch interactions.'
                : 'Disarm intent struggle belch chance disabled.'
            }
            displayText="Disarm"
            color={intent_data.disarm ? 'blue' : 'transparent'}
          />
        </Stack.Item>
        <Stack.Item>
          <VorePanelTooltip
            tooltip={
              intent_data.grab
                ? 'Struggling in grab intent might cause digest mode change interactions.'
                : 'Grab intent struggle digest mode change disabled.'
            }
            displayText="Grab"
            color={intent_data.grab ? 'yellow' : 'transparent'}
          />
        </Stack.Item>
        <Stack.Item>
          <VorePanelTooltip
            tooltip={
              intent_data.harm
                ? 'Struggling in harm intent might cause escape interactions.'
                : 'Harm intent struggle escape chance disabled.'
            }
            displayText="Harm"
            color={intent_data.harm ? 'red' : 'transparent'}
          />
        </Stack.Item>
      </>
    )
  );
};
