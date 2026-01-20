/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Stack } from 'tgui-core/components';

export function Notifications(props) {
  const { children } = props;
  return <div className="Notifications">{children}</div>;
}

function NotificationsItem(props) {
  const { rightSlot, children } = props;
  return (
    <Stack align="center" className="Notification">
      <Stack.Item className="Notification__content" grow>
        {children}
      </Stack.Item>
      {rightSlot && (
        <Stack.Item className="Notification__rightSlot">{rightSlot}</Stack.Item>
      )}
    </Stack>
  );
}

Notifications.Item = NotificationsItem;
