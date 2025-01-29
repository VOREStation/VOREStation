import { NtosWindow } from 'tgui/layouts';

import { CrewManifestContent } from './CrewManifest';

export const NtosCrewManifest = () => {
  return (
    <NtosWindow width={800} height={600}>
      <NtosWindow.Content>
        <CrewManifestContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
