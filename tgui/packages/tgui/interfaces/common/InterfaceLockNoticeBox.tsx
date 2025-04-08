import { useBackend } from 'tgui/backend';
import { Button, NoticeBox, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  siliconUser: BooleanLike;
  locked: BooleanLike;
  preventLocking: BooleanLike;
};

/**
 * This component by expects the following fields to be returned
 * from ui_data:
 *
 * - siliconUser: boolean
 * - locked: boolean
 *
 * And expects the following ui_act action to be implemented:
 *
 * - lock - for toggling the lock as a silicon user.
 *
 * All props can be redefined if you want custom behavior, but
 * it's preferred to stick to defaults.
 */
export const InterfaceLockNoticeBox = (props: {
  readonly siliconUser?: BooleanLike;
  readonly locked?: BooleanLike;
  readonly onLockStatusChange?: (status: BooleanLike) => void;
  readonly accessText?: string;
  readonly preventLocking?: BooleanLike;
  readonly deny?: BooleanLike;
  readonly denialMessage?: React.JSX.Element | string;
}) => {
  const { act, data } = useBackend<Data>();
  const {
    siliconUser = data.siliconUser,
    locked = data.locked,
    onLockStatusChange = () => act('lock'),
    accessText = 'an ID card',
    preventLocking = data.preventLocking,
    deny = false,
    denialMessage = 'Error.',
  } = props;
  if (deny) {
    return denialMessage;
  }
  // For silicon users
  if (siliconUser) {
    return (
      <NoticeBox color="grey">
        <Stack align="center">
          <Stack.Item>Interface lock status:</Stack.Item>
          <Stack.Item grow />
          <Stack.Item>
            <Button
              m={0}
              color={locked ? 'red' : 'green'}
              icon={locked ? 'lock' : 'unlock'}
              disabled={preventLocking}
              onClick={() => {
                if (onLockStatusChange) {
                  onLockStatusChange(!locked);
                }
              }}
            >
              {locked ? 'Locked' : 'Unlocked'}
            </Button>
          </Stack.Item>
        </Stack>
      </NoticeBox>
    );
  }
  // For everyone else
  return (
    <NoticeBox>
      Swipe {accessText} to {locked ? 'unlock' : 'lock'} this interface.
    </NoticeBox>
  );
};
