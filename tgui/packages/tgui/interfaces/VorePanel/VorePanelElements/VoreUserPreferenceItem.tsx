import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, type Floating } from 'tgui-core/components';
import type { PreferenceData } from '../types';

export const VoreUserPreferenceItem = (props: {
  /** The preference data object */
  spec: PreferenceData;
  /** Position of the tooltip */
  tooltipPosition: ComponentProps<typeof Floating>['placement'];
}) => {
  const { act } = useBackend();

  const { spec, tooltipPosition } = props;
  const { action, test, tooltip, content, fluid = true, back_color } = spec;

  return (
    <Button
      onClick={() => act(action)}
      icon={test ? 'toggle-on' : 'toggle-off'}
      selected={test}
      fluid={fluid}
      backgroundColor={
        back_color ? (test ? back_color.enabled : back_color.disabled) : ''
      }
      tooltip={`${tooltip.main} ${test ? tooltip.disable : tooltip.enable}`}
      tooltipPosition={tooltipPosition}
    >
      {test ? content.enabled : content.disabled}
    </Button>
  );
};
