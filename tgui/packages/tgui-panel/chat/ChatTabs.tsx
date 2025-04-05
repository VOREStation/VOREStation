/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useDispatch, useSelector } from 'tgui/backend';
import { Box, Button, Stack, Tabs } from 'tgui-core/components';

import { openChatSettings } from '../settings/actions';
import { addChatPage, changeChatPage } from './actions';
import { selectChatPages, selectCurrentChatPage } from './selectors';
import type { Page } from './types';

const UnreadCountWidget = ({ value }: { value: number }) => (
  <Box
    style={{
      fontSize: '0.7em',
      borderRadius: '0.25em',
      width: '1.7em',
      lineHeight: '1.55em',
      backgroundColor: 'crimson',
      color: '#fff',
    }}
  >
    {Math.min(value, 99)}
  </Box>
);

export const ChatTabs = (props) => {
  const pages = useSelector(selectChatPages);
  const currentPage = useSelector(selectCurrentChatPage);
  const dispatch = useDispatch();
  return (
    <Stack align="center">
      <Stack.Item>
        <Tabs textAlign="center">
          {pages.map((page: Page) => (
            <Tabs.Tab
              key={page.id}
              selected={page === currentPage}
              rightSlot={
                !page.hideUnreadCount &&
                page.unreadCount > 0 && (
                  <UnreadCountWidget value={page.unreadCount} />
                )
              }
              onClick={() =>
                dispatch(
                  changeChatPage({
                    pageId: page.id,
                  }),
                )
              }
            >
              {page.name}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      <Stack.Item ml={1}>
        <Button
          color="transparent"
          icon="plus"
          onClick={() => {
            dispatch(addChatPage());
            dispatch(openChatSettings());
          }}
        />
      </Stack.Item>
    </Stack>
  );
};
