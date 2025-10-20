import { useBackend } from 'tgui/backend';
import { ChemDispenserSettings } from '../ChemDispenser/ChemDispenserSettings';
import type { Data } from './types';

export const BorgHypoSettings = (props) => {
  const { act, data } = useBackend<Data>();
  const { amount, minTransferAmount, maxTransferAmount, transferAmounts } =
    data;
  return (
    <ChemDispenserSettings
      selectedAmount={amount}
      availableAmounts={transferAmounts}
      minAmount={minTransferAmount}
      maxAmount={maxTransferAmount}
      amountAct={(amt) => act('set_amount', { amount: amt })}
    />
  );
};
