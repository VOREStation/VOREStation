import { Box, Flex, LabeledList, Section, Icon } from '../components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { RankIcon } from './common/RankIcon';

export const IDCard = (props) => {
  const { data } = useBackend();

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

  const dataIter = [
    { name: 'Sex', val: sex },
    { name: 'Species', val: species },
    { name: 'Age', val: age },
    { name: 'Blood Type', val: blood_type },
    { name: 'Fingerprint', val: fingerprint_hash },
    { name: 'DNA Hash', val: dna_hash },
  ];

  return (
    <Window width={470} height={250} resizable>
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
                }}>
                {(photo_front && (
                  <img
                    src={photo_front.substr(1, photo_front.length - 1)}
                    style={{
                      width: '300px',
                      'margin-left': '-94px',
                      '-ms-interpolation-mode': 'nearest-neighbor',
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
            justify="space-around">
            <Flex.Item>
              <Box textAlign="center">{registered_name}</Box>
            </Flex.Item>
            <Flex.Item>
              <Box textAlign="center">
                <RankIcon rank={assignment} />
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
