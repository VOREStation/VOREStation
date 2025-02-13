import { useBackend } from 'tgui/backend';
import { Box, Button, NoticeBox } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { decodeHtmlEntities } from 'tgui-core/string';

type Data = { temp: { style: string; text: string } };

/**
 * Displays a notice box with text and style dictated by the
 * `temp` data field if it exists.
 *
 * A valid `temp` object contains:
 *
 * - `style` — The style of the NoticeBox
 * - `text` — The text to display
 *
 * Allows clearing the notice through the `cleartemp` TGUI act
 * @param {object} props
 */
export const TemporaryNotice = (props: { decode?: BooleanLike }) => {
  const { decode } = props;
  const { act, data } = useBackend<Data>();
  const { temp } = data;
  if (!temp) {
    return;
  }
  const temporaryProperty = { [temp.style]: true };
  return (
    <NoticeBox {...temporaryProperty}>
      <Box inline verticalAlign="middle">
        {decode ? decodeHtmlEntities(temp.text) : temp.text}
      </Box>
      <Button icon="times-circle" onClick={() => act('cleartemp')} />
    </NoticeBox>
  );
};
