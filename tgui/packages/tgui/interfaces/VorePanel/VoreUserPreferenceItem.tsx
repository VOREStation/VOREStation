import { useBackend } from 'tgui/backend';
import { Button } from 'tgui-core/components';

import { preferenceData } from './types';

export const VoreUserPreferenceItem = (props: {
  spec: preferenceData;
  [rest: string]: any;
}) => {
  const { act } = useBackend();

  const { spec, ...rest } = props;
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
      tooltip={tooltip.main + ' ' + (test ? tooltip.disable : tooltip.enable)}
      {...rest}
    >
      {test ? content.enabled : content.disabled}
    </Button>
  );
};
