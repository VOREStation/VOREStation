import { NtosWindow } from '../layouts';
import { OvermapNavigationContent } from './OvermapNavigation';

export const NtosOvermapNavigation = () => {
  return (
    <NtosWindow width={380} height={530} resizable>
      <NtosWindow.Content scrollable>
        <OvermapNavigationContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
