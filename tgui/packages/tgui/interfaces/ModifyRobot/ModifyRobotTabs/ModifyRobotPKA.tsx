import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, NoticeBox } from 'tgui/components';

import { NoSpriteWarning } from '../components';
import { Target } from '../types';

export const ModifyRobotPKA = (props: { target: Target }) => {
  const { act } = useBackend();
  const { target } = props;

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      {!target.pka ? (
        <NoticeBox danger>{target.name} has no PKA installed.</NoticeBox>
      ) : (
        <Flex height={!target.active ? '80%' : '85%'}>
          <Flex.Item width="45%" fill>
            <Box>Remaining Capacity: {target.pka.capacity}</Box>
            {target.pka.modkits.map((modkit, i) => {
              return (
                <Button
                  fluid
                  key={i}
                  disabled={modkit.denied}
                  color="green"
                  tooltip={
                    modkit.denied_by
                      ? 'Modul incompatible with: ' + modkit.denied_by
                      : ''
                  }
                  onClick={() =>
                    act('install_modkit', {
                      modkit: modkit.path,
                    })
                  }
                >
                  {modkit.name} {modkit.costs}
                </Button>
              );
            })}
          </Flex.Item>
          <Flex.Item width="10%" />
          <Flex.Item width="45%" fill>
            <Box>
              Used Capacity: {target.pka.max_capacity - target.pka.capacity}
            </Box>
            {target.pka.installed_modkits.map((modkit, i) => {
              return (
                <Button
                  fluid
                  key={i}
                  color="red"
                  onClick={() =>
                    act('remove_modkit', {
                      modkit: modkit.ref,
                    })
                  }
                >
                  {modkit.name} {modkit.costs}
                </Button>
              );
            })}
          </Flex.Item>
        </Flex>
      )}
    </>
  );
};
