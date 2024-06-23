import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, NoticeBox } from '../../components';

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
 * @param {object} _properties
 */
export const TemporaryNotice = (_properties) => {
  const { decode } = _properties;
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
