import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { Data } from './types';

export const CommunicatorMessageSubTab = (props: {
  clipboardMode: boolean;
  onClipboardMode: Function;
}) => {
  const { act, data } = useBackend<Data>();

  const { clipboardMode, onClipboardMode } = props;

  const { targetAddress, targetAddressName, imList } = data;

  return clipboardMode ? (
    <Section
      title={
        <Box
          inline
          style={{
            whiteSpace: 'nowrap',
            overflowX: 'hidden',
          }}
          width="90%"
        >
          {enforceLengthLimit(
            'Conversation with ',
            decodeHtmlEntities(targetAddressName),
            30,
          )}
        </Box>
      }
      buttons={
        <Button
          icon="eye"
          selected={clipboardMode}
          tooltip="Exit Clipboard Mode"
          tooltipPosition="bottom-end"
          onClick={() => onClipboardMode(!clipboardMode)}
        />
      }
      height="100%"
      stretchContents
    >
      <Section
        style={{
          height: '95%',
          overflowY: 'auto',
        }}
      >
        {imList.map(
          (im, i) =>
            (im.to_address === targetAddress ||
              im.address === targetAddress) && (
              <Box
                key={i}
                className={
                  IsIMOurs(im, targetAddress)
                    ? 'ClassicMessage_Sent'
                    : 'ClassicMessage_Received'
                }
              >
                {IsIMOurs(im, targetAddress) ? 'You' : 'Them'}: {im.im}
              </Box>
            ),
        )}
      </Section>
      <Button
        icon="comment"
        onClick={() => act('message', { message: targetAddress })}
      >
        Message
      </Button>
    </Section>
  ) : (
    <Section
      title={
        <Box
          inline
          style={{
            whiteSpace: 'nowrap',
            overflowX: 'hidden',
          }}
          width="100%"
        >
          {enforceLengthLimit(
            'Conversation with ',
            decodeHtmlEntities(targetAddressName),
            30,
          )}
        </Box>
      }
      buttons={
        <Button
          icon="eye"
          selected={clipboardMode}
          tooltip="Enter Clipboard Mode"
          tooltipPosition="bottom-end"
          onClick={() => onClipboardMode(!clipboardMode)}
        />
      }
      height="100%"
      stretchContents
    >
      <Section
        style={{
          height: '95%',
          overflowY: 'auto',
        }}
      >
        {imList.map(
          (im, i, filterArr) =>
            (im.to_address === targetAddress ||
              im.address === targetAddress) && (
              <Box
                textAlign={IsIMOurs(im, targetAddress) ? 'right' : 'left'}
                mb={1}
                key={i}
              >
                <Box
                  maxWidth="75%"
                  className={findClassMessage(
                    im,
                    targetAddress,
                    i - 1,
                    filterArr,
                  )}
                  inline
                >
                  {decodeHtmlEntities(im.im)}
                </Box>
              </Box>
            ),
        )}
      </Section>
      <Button
        icon="comment"
        onClick={() => act('message', { message: targetAddress })}
      >
        Message
      </Button>
    </Section>
  );
};

/* Actual messaging conversation */
const IsIMOurs = (
  im: { address: string; to_address: string; im: string },
  targetAddress: string,
) => {
  return im.address !== targetAddress;
};

const enforceLengthLimit = (prefix: string, name: string, length: number) => {
  if ((prefix + name).length > length) {
    if (name.length > length) {
      return name.slice(0, length) + '...';
    }
    return name;
  }
  return prefix + name;
};

const findClassMessage = (
  im: { address: string; to_address: string; im: string },
  targetAddress: string,
  lastIndex: number,
  filterArray: {
    address: string;
    to_address: string;
    im: string;
  }[],
) => {
  if (lastIndex < 0 || lastIndex > filterArray.length) {
    return IsIMOurs(im, targetAddress)
      ? 'TinderMessage_First_Sent'
      : 'TinderMessage_First_Received';
  }

  let thisSent = IsIMOurs(im, targetAddress);
  let lastSent = IsIMOurs(filterArray[lastIndex], targetAddress);
  if (thisSent && lastSent) {
    return 'TinderMessage_Subsequent_Sent';
  } else if (!thisSent && !lastSent) {
    return 'TinderMessage_Subsequent_Received';
  }
  return thisSent ? 'TinderMessage_First_Sent' : 'TinderMessage_First_Received';
};
