import { NtosWindow } from '../layouts';
import { CameraConsoleContent } from './CameraConsole';

export const NtosCameraConsole = () => {
  return (
    <NtosWindow width={870} height={708} resizable>
      <NtosWindow.Content>
        <CameraConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
