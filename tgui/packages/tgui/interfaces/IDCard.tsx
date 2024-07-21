import { useBackend } from '../backend';
import { Box, Flex, Icon, Image, LabeledList, Section } from '../components';
import { Window } from '../layouts';
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
          <Flex>
            <Flex.Item basis="25%" textAlign="left">
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
            </Flex.Item>
            <Flex.Item basis={0} grow={1}>
              <LabeledList>
                {dataIter.map((data) => (
                  <LabeledList.Item key={data.name} label={data.name}>
                    {data.val}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Flex.Item>
          </Flex>
          <Flex
            className="IDCard__NamePlate"
            align="center"
            justify="space-around"
          >
            <Flex.Item>
              <Box textAlign="center">{registered_name}</Box>
            </Flex.Item>
            <Flex.Item>
              <Box textAlign="center">
                <RankIcon color="" rank={assignment} />
              </Box>
            </Flex.Item>
            <Flex.Item>
              <Box textAlign="center">{assignment}</Box>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
