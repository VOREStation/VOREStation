import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';

import { SMESItem } from './RCONSMESItem';
import type { Data } from './types';

export const RCONSmesList = (props) => {
  const { act, data } = useBackend<Data>();

  const { smes_info, pages, current_page } = data;

  const runCallback = (cb: Function) => {
    return cb();
  };

  return (
    <Section title={'SMESs (Page ' + current_page + ')'}>
      <Stack vertical>
        {smes_info.map((smes) => (
          <Stack.Item key={smes.RCON_tag}>
            <SMESItem smes={smes} />
          </Stack.Item>
        ))}
      </Stack>
      Page Selection:
      <br />
      {runCallback(() => {
        const row: React.JSX.Element[] = [];
        for (let i: number = 1; i < pages; i++) {
          row.push(
            <Button
              selected={current_page === i}
              key={i}
              onClick={() =>
                act('set_smes_page', {
                  index: i,
                })
              }
            >
              {i}
            </Button>,
          );
        }
        return row;
      })}
    </Section>
  );
};
