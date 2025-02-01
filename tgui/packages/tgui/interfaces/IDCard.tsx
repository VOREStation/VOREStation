import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Icon,
  Image,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import { RankIcon } from './common/RankIcon';

type Data = {
  registered_name: string;
  sex: string;
  species: string;
  age: string | number;
  assignment: string;
  fingerprint_hash: string;
  blood_type: string;
  dna_hash: string;
  photo_front: string;
};

export const IDCard = (props) => {
  const { data } = useBackend<Data>();

  const {
    registered_name,
    sex,
    species,
    age,
    assignment,
    fingerprint_hash,
    blood_type,
    dna_hash,
    photo_front,
  } = data;

  const dataIter: {
    name: string;
    val: string | number;
  }[] = [
    { name: 'Sex', val: sex },
    { name: 'Species', val: species },
    { name: 'Age', val: age },
    { name: 'Blood Type', val: blood_type },
    { name: 'Fingerprint', val: fingerprint_hash },
    { name: 'DNA Hash', val: dna_hash },
  ];

  return (
    <Window width={470} height={250}>
      <Window.Content>
        <Section>
          <Stack>
            <Stack.Item basis="25%" textAlign="left">
              <Box
                inline
                style={{
                  width: '101px',
                  height: '120px',
                  overflow: 'hidden',
                  outline: '2px solid #4972a1',
                }}
              >
                {(photo_front && (
                  <Image
                    src={photo_front.substring(1, photo_front.length - 1)}
                    style={{
                      width: '300px',
                      marginLeft: '-94px',
                    }}
                  />
                )) || <Icon name="user" size={8} ml={1.5} mt={2.5} />}
              </Box>
            </Stack.Item>
            <Stack.Item basis={0} grow>
              <LabeledList>
                {dataIter.map((data) => (
                  <LabeledList.Item key={data.name} label={data.name}>
                    {data.val}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Stack.Item>
          </Stack>
          <Stack
            className="IDCard__NamePlate"
            align="center"
            justify="space-around"
          >
            <Stack.Item>
              <Box textAlign="center">{registered_name}</Box>
            </Stack.Item>
            <Stack.Item>
              <Box textAlign="center">
                <RankIcon color="" rank={assignment} />
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box textAlign="center">{assignment}</Box>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
