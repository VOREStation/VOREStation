import { Activity } from 'react';

export type ActivityTabProps<P extends object> = {
  hasData?: boolean;
  Component: React.ComponentType<P>;
  props?: P;
};

export function ActivityTab<P extends object>({
  hasData = true,
  Component,
  props = {} as P,
}: ActivityTabProps<P>) {
  if (!hasData) return null;

  return (
    <Activity mode="visible">
      <Component {...props} />
    </Activity>
  );
}
