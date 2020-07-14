import { NtosWindow } from '../layouts';
import { CameraConsoleContent } from './CameraConsole';

export const NtosPowerMonitor = () => {
  return (
    <NtosWindow resizable>
      <CameraConsoleContent />
    </NtosWindow>
  );
};