import { NtosWindow } from '../layouts';
import { CommunicationsConsoleContent } from './CommunicationsConsole';

export const NtosCommunicationsConsole = () => {
  return (
    <NtosWindow width={400} height={600} resizable>
      <NtosWindow.Content scrollable>
        <CommunicationsConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
