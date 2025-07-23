import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';

import { ban_types } from '../constants';
import type { Data } from '../types';
import { InputHelper } from './Helpers/InputHelper';

export const BanningSection = (props: { possibleJobs: string[] }) => {
  const { act } = useBackend<Data>();

  const { possibleJobs } = props;

  const [banType, setBanType] = useState('');
  const [banIP, setBanIP] = useState('');
  const [banDuration, setBanDuration] = useState(0);
  const [banCkey, setBanCkey] = useState('');
  const [banCID, setBanCID] = useState('');
  const [banJob, setBanJob] = useState('');
  const [banReason, setBanReason] = useState('');

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            <Stack.Item basis="30%">
              <LabeledList>
                <LabeledList.Item label="Ban Type">
                  <Dropdown
                    fluid
                    onSelected={(value) => {
                      setBanType(value);
                    }}
                    options={ban_types}
                    selected={banType}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="IP">
                  <Input
                    fluid
                    value={banIP}
                    onBlur={(value) => setBanIP(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Duration">
                  <NumberInput
                    fluid
                    value={banDuration}
                    minValue={0}
                    step={1}
                    maxValue={Infinity}
                    unit="min"
                    onChange={(value) => setBanDuration(value)}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item basis="30%">
              <LabeledList>
                <LabeledList.Item label="Ckey">
                  <Input
                    fluid
                    value={banCkey}
                    onBlur={(value) => setBanCkey(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="CID">
                  <Input
                    fluid
                    value={banCID}
                    onBlur={(value) => setBanCID(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Job">
                  <Dropdown
                    fluid
                    onSelected={(value) => {
                      setBanJob(value);
                    }}
                    options={possibleJobs}
                    selected={banJob}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item basis="30%">
              <InputHelper
                banType={banType}
                banCkey={banCkey}
                banDuration={banDuration}
                banJob={banJob}
                banReason={banReason}
              />
              <Button.Confirm
                position="absolute"
                top="60px"
                onClick={() => {
                  act('confirmBan', {
                    type: ban_types.indexOf(banType) + 1,
                    ip: banIP,
                    duration: banDuration,
                    ckey: banCkey,
                    cid: banCID,
                    job: banJob,
                    reason: banReason,
                  });
                  setBanType('');
                  setBanIP('');
                  setBanDuration(0);
                  setBanCkey('');
                  setBanCID('');
                  setBanJob('');
                }}
              >
                Add ban
              </Button.Confirm>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <Box color="label">Reason:</Box>
        </Stack.Item>
        <Stack.Item grow>
          <TextArea
            fluid
            height="100%"
            value={banReason}
            onBlur={(value) => setBanReason(value)}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
