import { useBackend } from 'tgui/backend';
import { COLORS } from 'tgui/constants';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import type { Data, modalData } from './types';

export const viewRecordModalBodyOverride = (modal: modalData) => {
  const { act, data } = useBackend<Data>();

  const { disk, podready } = data;

  const { activerecord, realname, health, unidentity, strucenzymes } =
    modal.args;
  const damages = health.split(' - ');
  return (
    <Section m="-1rem" pb="1rem" title={'Records of ' + realname}>
      <LabeledList>
        <LabeledList.Item label="Name">{realname}</LabeledList.Item>
        <LabeledList.Item label="Damage">
          {damages.length > 1 ? (
            <>
              <Box color={COLORS.damageType.oxy} inline>
                {damages[0]}
              </Box>
              &nbsp;|&nbsp;
              <Box color={COLORS.damageType.toxin} inline>
                {damages[2]}
              </Box>
              &nbsp;|&nbsp;
              <Box color={COLORS.damageType.brute} inline>
                {damages[3]}
              </Box>
              &nbsp;|&nbsp;
              <Box color={COLORS.damageType.burn} inline>
                {damages[1]}
              </Box>
            </>
          ) : (
            <Box color="bad">Unknown</Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="UI" className="LabeledList__breakContents">
          {unidentity}
        </LabeledList.Item>
        <LabeledList.Item label="SE" className="LabeledList__breakContents">
          {strucenzymes}
        </LabeledList.Item>
        <LabeledList.Item label="Disk">
          <Button.Confirm
            disabled={!disk}
            icon="arrow-circle-down"
            onClick={() =>
              act('disk', {
                option: 'load',
              })
            }
          >
            Import
          </Button.Confirm>
          <Button
            disabled={!disk}
            icon="arrow-circle-up"
            onClick={() =>
              act('disk', {
                option: 'save',
                savetype: 'ui',
              })
            }
          >
            Export UI
          </Button>
          <Button
            disabled={!disk}
            icon="arrow-circle-up"
            onClick={() =>
              act('disk', {
                option: 'save',
                savetype: 'ue',
              })
            }
          >
            Export UI and UE
          </Button>
          <Button
            disabled={!disk}
            icon="arrow-circle-up"
            onClick={() =>
              act('disk', {
                option: 'save',
                savetype: 'se',
              })
            }
          >
            Export SE
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Actions">
          <Button
            disabled={!podready}
            icon="user-plus"
            onClick={() =>
              act('clone', {
                ref: activerecord,
              })
            }
          >
            Clone
          </Button>
          <Button icon="trash" onClick={() => act('del_rec')}>
            Delete
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
