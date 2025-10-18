import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { Data, RobotChem } from '../types';

export const InjectorPanel = (props: { robotChems: RobotChem[] }) => {
  const { act, data } = useBackend<Data>();
  const { our_patient } = data;
  const { robotChems } = props;

  return (
    <Section fill title="Injector">
      {robotChems.length ? (
        <Stack wrap="wrap">
          {robotChems.map((chem) => (
            <Stack.Item basis="49%" key={chem.id}>
              <Button
                fluid
                disabled={!our_patient || our_patient.stat === 2}
                onClick={() => act('inject', { value: chem.id })}
              >
                Inject {chem.name}
              </Button>
            </Stack.Item>
          ))}
        </Stack>
      ) : (
        <Box color="red">No chems found.</Box>
      )}
    </Section>
  );
};
