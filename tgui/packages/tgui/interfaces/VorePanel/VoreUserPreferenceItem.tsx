import { useBackend } from '../../backend';
import { Button } from '../../components';
import { preferenceData } from './types';

export const VoreUserPreferenceItem = (props: {
  spec: preferenceData;
  [rest: string]: any;
}) => {
  const { act } = useBackend();

  const { spec, ...rest } = props;
  const { action, test, tooltip, content } = spec;

  return (
    <Button
      onClick={() => act(action)}
      icon={test ? 'toggle-on' : 'toggle-off'}
      selected={test}
      fluid
      tooltip={tooltip.main + ' ' + (test ? tooltip.disable : tooltip.enable)}
      {...rest}
    >
      {test ? content.enabled : content.disabled}
    </Button>
  );
};
