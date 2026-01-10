import type { ComponentProps, ReactNode } from 'react';
import { Box, type Floating, Tooltip } from 'tgui-core/components';

export const VorePanelTooltip = (
  props: {
    /** Our displayed tooltip displayed the text */
    tooltip: ReactNode;
    /** Text of the button */
    displayText: string;
  } & Partial<{
    /** The position of the tooltip if static */
    tooltipPosition: ComponentProps<typeof Floating>['placement'];
    /** Color of the button */
    color: string;
    /** Event based selection, usually not used */
    selected: boolean;
  }>,
) => {
  const { tooltip, tooltipPosition, displayText, color, selected } = props;

  return (
    <Tooltip content={tooltip} position={tooltipPosition}>
      <Box
        backgroundColor={color}
        className={`VorePanel__floatingButton VorePanel__noCursor${selected ? ' VorePanel__selected' : ''}`}
      >
        {displayText}
      </Box>
    </Tooltip>
  );
};
