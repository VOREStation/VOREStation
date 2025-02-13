import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';

import type { Data } from './types';

export const CloningConsoleTemp = (props) => {
  const { act, data } = useBackend<Data>();
  const { temp } = data;
  if (!temp || !temp.text || temp.text.length <= 0) {
    return;
  }

  const tempProp = { [temp.style]: true };
  return (
    <NoticeBox {...tempProp}>
      <Box inline verticalAlign="middle">
        {temp.text}
      </Box>
      <Button
        icon="times-circle"
        style={{
          float: 'right',
        }}
        onClick={() => act('cleartemp')}
      />
      <Box
        style={{
          clear: 'both',
        }}
      />
    </NoticeBox>
  );
};

export const CloningConsoleStatus = (props) => {
  const { act, data } = useBackend<Data>();
  const { scanner, numberofpods, autoallowed, autoprocess, disk } = data;
  return (
    <Section
      title="Status"
      buttons={
        <>
          {!!autoallowed && (
            <>
              <Box inline color="label">
                Auto-processing:&nbsp;
              </Box>
              <Button
                selected={autoprocess}
                icon={autoprocess ? 'toggle-on' : 'toggle-off'}
                onClick={() =>
                  act('autoprocess', {
                    on: autoprocess ? 0 : 1,
                  })
                }
              >
                {autoprocess ? 'Enabled' : 'Disabled'}
              </Button>
            </>
          )}
          <Button
            disabled={!disk}
            icon="eject"
            onClick={() =>
              act('disk', {
                option: 'eject',
              })
            }
          >
            Eject Disk
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Scanner">
          {scanner ? (
            <Box color="good">Connected</Box>
          ) : (
            <Box color="bad">Not connected!</Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Pods">
          {numberofpods ? (
            <Box color="good">{numberofpods} connected</Box>
          ) : (
            <Box color="bad">None connected!</Box>
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
