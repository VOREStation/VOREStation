import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';
import { SMESItem } from './RCONSMESItem';
import type { Data } from './types';

export const RCONSmesList = () => {
  const { act, data } = useBackend<Data>();
  const { smes_info, pages, current_page } = data;

  return (
    <Section fill title={`SMESs (Page ${current_page})`}>
      <Stack fill vertical>
        <Stack.Item grow>
          <Section scrollable fill>
            <Stack fill vertical>
              {smes_info.map((smes) => (
                <Stack.Item key={smes.RCON_tag}>
                  <SMESItem smes={smes} />
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item>Page Selection:</Stack.Item>
        <Stack.Item>
          <Stack>
            {Array.from({ length: pages }, (_, i) => (
              <Stack.Item key={i + 1}>
                <Button
                  selected={current_page === i + 1}
                  onClick={() => act('set_smes_page', { index: i + 1 })}
                  style={{ marginRight: '0.25em' }}
                >
                  {i + 1}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
