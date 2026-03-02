import type { BooleanLike } from 'tgui-core/react';

export type Data = {
  locked: BooleanLike;
  cash_locked?: BooleanLike;
  linked_account: string | null;
  machine_id: string;
  transaction_logs: {
    log_id: number;
    customer: string;
    payment_method: string;
    trans_time: string;
    items: Record<string, number>;
    prices: Record<string, number>;
    amount: number;
  }[];
  current_transactioon: {
    items?: Record<string, number>;
    prices?: Record<string, number>;
    amount?: number;
  };
};
