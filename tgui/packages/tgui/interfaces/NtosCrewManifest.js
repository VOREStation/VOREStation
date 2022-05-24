import { NtosWindow } from '../layouts';
import { CrewManifestContent } from './CrewManifest';

export const NtosCrewManifest = () => {
  return (
    <NtosWindow
      width={800}
      height={600}
      resizable>
      <NtosWindow.Content>
        <CrewManifestContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
