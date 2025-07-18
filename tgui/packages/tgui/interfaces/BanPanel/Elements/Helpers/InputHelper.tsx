import { Box, Stack } from 'tgui-core/components';

export const InputHelper = (props: {
  banType: string;
  banCkey: string;
  banDuration: number;
  banJob: string;
  banReason: string;
}) => {
  const { banType, banCkey, banDuration, banJob, banReason } = props;

  switch (banType) {
    case 'PERMABAN':
      if (!banCkey || !banReason) {
        return <InputError banCkey={banCkey} banReason={banReason} />;
      }
      break;
    case 'TEMPBAN':
      if (!banCkey || !banReason || !banDuration) {
        return (
          <InputError
            banCkey={banCkey}
            banReason={banReason}
            banDuration={banDuration}
          />
        );
      }
      break;
    case 'JOB PERMABAN':
      if (!banCkey || banReason || !banJob) {
        return (
          <InputError banCkey={banCkey} banReason={banReason} banJob={banJob} />
        );
      }
      break;
    case 'JOB TEMPBAN':
      if (!banCkey || !banReason || !banDuration || !banJob) {
        return (
          <InputError
            banCkey={banCkey}
            banReason={banReason}
            banDuration={banDuration}
            banJob={banJob}
          />
        );
      }
      break;
    default:
      return null;
  }

  return <Box color="green">Valid Ban Input</Box>;
};

export const InputError = (props: {
  banCkey: string;
  banReason: string;
  banDuration?: number;
  banJob?: string;
}) => {
  const { banCkey, banReason, banDuration, banJob } = props;

  const allMisisng: string[] = [];
  if (!banCkey) {
    allMisisng.push('Ckey');
  }
  if (!banReason) {
    allMisisng.push('Reason');
  }
  if (banDuration !== undefined && !banDuration) {
    allMisisng.push('Duration');
  }
  if (banJob !== undefined && !banJob) {
    allMisisng.push('Job');
  }
  const formatter = new Intl.ListFormat('en', {
    style: 'long',
    type: 'conjunction',
  });
  return (
    <Stack vertical g={1.5}>
      <Stack.Item>
        <Box color="red">Invalid Ban Input</Box>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <Box color="label">Missing:</Box>
          </Stack.Item>
          <Stack.Item>
            <Box>{formatter.format(allMisisng)}</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
