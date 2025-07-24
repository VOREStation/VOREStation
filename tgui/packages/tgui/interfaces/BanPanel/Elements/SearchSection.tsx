import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import { ban_types } from '../constants';
import type { Data } from '../types';

export const SearchSection = (props: {
  searchedCkey: string;
  searchedAdminCkey: string;
  searchedIp: string;
  searchedCid: string;
  searchedBanType: string;
  minimumMatch: boolean;
}) => {
  const { act } = useBackend<Data>();

  const {
    searchedCkey,
    searchedAdminCkey,
    searchedIp,
    searchedCid,
    searchedBanType,
    minimumMatch,
  } = props;

  const [ckey, setCkey] = useState(searchedCkey);
  const [adminCkey, setAdminCkey] = useState(searchedAdminCkey);
  const [ip, setIp] = useState(searchedIp);
  const [cid, setCid] = useState(searchedCid);
  const [banType, setBanType] = useState(searchedBanType);
  const [minMatch, setMinMatch] = useState(minimumMatch);

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            <Stack.Item basis="30%">
              <LabeledList>
                <LabeledList.Item label="Ckey">
                  <Input
                    fluid
                    value={ckey}
                    onBlur={(value) => setCkey(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="IP">
                  <Input fluid value={ip} onBlur={(value) => setIp(value)} />
                </LabeledList.Item>
                <LabeledList.Item label="Ban Type">
                  <Dropdown
                    fluid
                    onSelected={(value) => {
                      setBanType(value);
                    }}
                    options={['Select...', ...ban_types]}
                    selected={banType}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item basis="30%">
              <LabeledList>
                <LabeledList.Item label="Admin Ckey">
                  <Input
                    fluid
                    value={adminCkey}
                    onBlur={(value) => setAdminCkey(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="CID">
                  <Input fluid value={cid} onBlur={(value) => setCid(value)} />
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    onClick={() =>
                      act('searchBans', {
                        ckey: ckey,
                        aCkey: adminCkey,
                        ip: ip,
                        cid: cid,
                        minMatch: minMatch,
                        banType: ban_types.indexOf(banType) + 1,
                      })
                    }
                  >
                    Search
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              <Stack vertical g={1.5}>
                <Stack.Item>
                  <Button.Checkbox
                    fluid
                    checked={minMatch}
                    onClick={() => setMinMatch(!minMatch)}
                  >
                    Match (min. 3 characters to search by key or ip, and 7 to
                    search by cid)
                  </Button.Checkbox>
                </Stack.Item>
                <Stack.Item>
                  <Box color="red">
                    Please note that all jobban bans are in-effect the following
                    round.
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Box>This search shows only the last 100 bans.</Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
