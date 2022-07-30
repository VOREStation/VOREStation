import { NtosWindow } from '../layouts';
import { IdentificationComputerContent } from './IdentificationComputer';

export const NtosIdentificationComputer = () => {
  return (
    <NtosWindow width={600} height={700} resizable>
      <NtosWindow.Content scrollable>
        <IdentificationComputerContent ntos />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
