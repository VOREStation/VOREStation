import { NtosWindow } from '../layouts';
import { CameraConsoleContent } from './CameraConsole';

export const NtosCameraConsole = () => {
  return (
    <NtosWindow resizable>
      <NtosWindow.Content>
        <CameraConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};