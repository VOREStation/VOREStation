import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import type { ExamineData } from '../types';

export const MedigunParts = (props: {
  examineData: ExamineData;
  maintenance: BooleanLike;
}) => {
  const { act } = useBackend();
  const { examineData, maintenance } = props;
  const { smodule, smanipulator, slaser, scapacitor, sbin } = examineData;

  return (
    <Section
      fill
      title="Installed Modules"
      buttons={
        <Button
          onClick={() => act('toggle_maintenance')}
          selected={maintenance}
          tooltip="Toggle maintenance mode"
          icon="wrench"
        />
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Scanning Module">
              {smodule ? (
                maintenance ? (
                  <Button.Confirm onClick={() => act('rem_smodule')}>
                    Remove Module
                  </Button.Confirm>
                ) : (
                  <Box>
                    {'It has a ' +
                      smodule.name +
                      ' installed, device will function within ' +
                      smodule.range +
                      ' tiles'}
                    {smodule.rating >= 5 ? ' and' : undefined}
                    {smodule.rating >= 5 ? ' through walls' : undefined}
                    {'.'}
                  </Box>
                )
              ) : (
                <Box color="red">Missing</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Manipulator">
              {smanipulator ? (
                maintenance ? (
                  <Button.Confirm onClick={() => act('rem_mani')}>
                    Remove Manipulator
                  </Button.Confirm>
                ) : (
                  <Box>
                    {'It has a ' +
                      smanipulator.name +
                      ' installed, chem digitizing is '}
                    {smanipulator.rating >= 5
                      ? '125% Efficient'
                      : `${(smanipulator.rating / 4) * 100}% Efficient`}
                    {'.'}
                  </Box>
                )
              ) : (
                <Box color="red">Missing</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Laser">
              {slaser ? (
                maintenance ? (
                  <Button.Confirm onClick={() => act('rem_laser')}>
                    Remove Laser
                  </Button.Confirm>
                ) : (
                  <Box>
                    {'It has a ' +
                      slaser.name +
                      ' installed, and can heal ' +
                      slaser.rating +
                      ' damage per cycle'}
                    {slaser.rating >= 5 ? ' and will' : undefined}
                    {slaser.rating >= 5 ? ' regenerate blood' : undefined}
                    {slaser.rating >= 5 ? ' while beam is focused' : ''}
                    {'.'}
                  </Box>
                )
              ) : (
                <Box color="red">Missing</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Capacitor">
              {scapacitor ? (
                maintenance ? (
                  <Button.Confirm onClick={() => act('rem_cap')}>
                    Remove Capacitor
                  </Button.Confirm>
                ) : (
                  <Box>
                    {'It has a ' +
                      scapacitor.name +
                      ' installed, battery Capacity is ' +
                      scapacitor.chargecap +
                      ' Units'}
                    {scapacitor.rating >= 5
                      ? ' the cell will recharge from the local power grid'
                      : ''}
                    {''}
                    {'.'}
                  </Box>
                )
              ) : (
                <Box color="red">Missing</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Matter Bin">
              {sbin ? (
                maintenance ? (
                  <Button.Confirm onClick={() => act('rem_bin')}>
                    Remove Bin
                  </Button.Confirm>
                ) : (
                  <Box>
                    {'It has a ' +
                      sbin.name +
                      ' installed, can hold ' +
                      sbin.tankmax +
                      ' charge and ' +
                      sbin.chemcap +
                      ' reserve chems'}
                    {sbin.rating >= 5
                      ? 'and will slowly generate chems in exchange for power.'
                      : '.'}
                  </Box>
                )
              ) : (
                <Box color="red">Missing</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
