import { useBackend } from "../backend";
import { NtosWindow } from "../layouts";
import { IdentificationComputerContent } from "./IdentificationComputer";

export const NtosIdentificationComputer = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <NtosWindow width={600} height={700} resizable>
      <NtosWindow.Content scrollable>
        <IdentificationComputerContent ntos />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
