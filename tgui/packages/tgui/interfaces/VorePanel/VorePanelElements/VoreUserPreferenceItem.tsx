import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, type Floating } from 'tgui-core/components';
import type {
  DropdownEntry,
  PreferenceData,
  PreferenceDropdown,
} from '../types';
import { VorePanelEditDropdown } from './VorePanelEditDropdown';

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

export const VoreUserPreferenceDropdown = (props: {
  /** The currently selected entry */
  currentActive: string;
  /** The preference data object */
  spec: PreferenceDropdown;
  /** Position of the tooltip */
  tooltipPosition: ComponentProps<typeof Floating>['placement'];
}) => {
  const { currentActive, spec, tooltipPosition } = props;

  const options: DropdownEntry[] = Object.entries(spec.data).map(
    ([key, entry]) => ({
      displayText: entry.displayText,
      value: key,
    }),
  );

  return (
    <VorePanelEditDropdown
      editMode={true}
      icon={spec.data[currentActive].enabled ? 'toggle-on' : 'toggle-off'}
      action={spec.action}
      options={options}
      color={spec.data[currentActive].color}
      entry={`${spec.prefix}: ${spec.data[currentActive].displayText}`}
      tooltip={spec.tooltip}
      tooltipPosition={tooltipPosition}
    />
  );
};
