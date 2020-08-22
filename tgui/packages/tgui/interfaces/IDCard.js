import { Box, Flex, LabeledList, Section, Icon } from "../components";
import { useBackend } from "../backend";
import { Window } from "../layouts";
import { Fragment } from "inferno";

const rank2icon = {
  // Command
  'Colony Director': 'user-tie',
  'Site Manager': 'user-tie',
  'Overseer': 'user-tie',
  'Head of Personnel': 'briefcase',
  'Crew Resources Officer': 'briefcase',
  'Deputy Director': 'briefcase',
  'Command Secretary': 'user-tie',
  // Security
  'Head of Security': 'user-shield',
  'Security Commander': 'user-shield',
  'Chief of Security': 'user-shield',
  'Warden': ['city', 'shield-alt'],
  'Detective': 'search',
  'Forensic Technician': 'search',
  'Security Officer': 'user-shield',
  'Junior Officer': 'user-shield',
  // Engineering
  'Chief Engineer': 'toolbox',
  'Atmospheric Technician': 'wind',
  'Station Engineer': 'toolbox',
  'Maintenance Technician': 'wrench',
  'Engine Technician': 'toolbox',
  'Electrician': 'toolbox',
  // Medical
  'Chief Medical Officer': 'user-md',
  'Chemist': 'mortar-pestle',
  'Pharmacist': 'mortar-pestle',
  'Medical Doctor': 'user-md',
  'Surgeon': 'user-md',
  'Emergency Physician': 'user-md',
  'Nurse': 'user-md',
  'Virologist': 'disease',
  'Paramedic': 'ambulance',
  'Emergency Medical Technician': 'ambulance',
  'Psychiatrist': 'couch',
  'Psychologist': 'couch',
  // Science
  'Research Director': 'user-graduate',
  'Research Supervisor': 'user-graduate',
  'Roboticist': 'robot',
  'Biomechanical Engineer': ['wrench', 'heartbeat'],
  'Mechatronic Engineer': 'wrench',
  'Scientist': 'flask',
  'Xenoarchaeologist': 'flask',
  'Anomalist': 'flask',
  'Phoron Researcher': 'flask',
  'Circuit Designer': 'car-battery',
  'Xenobiologist': 'meteor',
  'Xenobotanist': ['biohazard', 'seedling'],
  // Cargo
  'Quartermaster': 'box-open',
  'Supply Chief': 'warehouse',
  'Cargo Technician': 'box-open',
  'Shaft Miner': 'hard-hat',
  'Drill Technician': 'hard-hat',
  // Exploration
  'Pathfinder': 'binoculars',
  'Explorer': 'user-astronaut',
  'Field Medic': ['user-md', 'user-astronaut'],
  'Pilot': 'space-shuttle',
  // Civvies
  'Bartender': 'glass-martini',
  'Barista': 'coffee',
  'Botanist': 'leaf',
  'Gardener': 'leaf',
  'Chaplain': 'place-of-worship',
  'Counselor': 'couch',
  'Chef': 'utensils',
  'Cook': 'utensils',
  'Entertainer': 'smile-beam',
  'Performer': 'smile-beam',
  'Musician': 'guitar',
  'Stagehand': 'smile-beam',
  // All of the interns
  'Intern': 'school',
  'Apprentice Engineer': ['school', 'wrench'],
  'Medical Intern': ['school', 'user-md'],
  'Lab Assistant': ['school', 'flask'],
  'Security Cadet': ['school', 'shield-alt'],
  'Jr. Cargo Tech': ['school', 'box'],
  'Jr. Explorer': ['school', 'user-astronaut'],
  'Server': ['school', 'utensils'],
  // Back to civvies
  'Internal Affairs Agent': 'balance-scale',
  'Janitor': 'broom',
  'Custodian': 'broom',
  'Sanitation Technician': 'hand-sparkles',
  'Maid': 'broom',
  'Librarian': 'book',
  'Journalist': 'newspaper',
  'Writer': 'book',
  'Historian': 'chalkboard-teacher',
  'Professor': 'chalkboard-teacher',
  'Visitor': 'user',
  // Special roles
  'Emergency Responder': 'fighter-jet',
};
const RankIcon = (props, context) => {
  const {
    rank,
  } = props;

  let rankObj = rank2icon[rank];
  if (typeof rankObj === "string") {
    return <Icon inline color="label" name={rankObj} size={2} />;
  } else if (Array.isArray(rankObj)) {
    return rankObj.map(icon => (
      <Icon inline key={icon} color="label" name={icon} size={2} />
    ));
  } else {
    return <Icon inline color="label" name="user" size={2} />;
  }
};

export const IDCard = (props, context) => {
  const { data } = useBackend(context);

  const {
    registered_name,
    sex,
    age,
    assignment,
    fingerprint_hash,
    blood_type,
    dna_hash,
    photo_front,
  } = data;

  const dataIter = [
    { name: "Sex", val: sex },
    { name: "Age", val: age },
    { name: "Blood Type", val: blood_type },
    { name: "Fingerprint", val: fingerprint_hash },
    { name: "DNA Hash", val: dna_hash },
  ];

  return (
    <Window
      width={470}
      height={250}
      resizable>
      <Window.Content>
        <Section>
          <Flex>
            <Flex.Item basis="25%" textAlign="left">
              <Box
                inline
                style={{
                  width: '101px',
                  height: '120px',
                  overflow: "hidden",
                  outline: "2px solid #4972a1",
                }}>
                {photo_front && (
                  <img
                    src={photo_front.substr(1, photo_front.length - 1)}
                    style={{
                      width: '300px',
                      'margin-left': '-94px',
                      '-ms-interpolation-mode': 'nearest-neighbor',
                    }}
                  />
                ) || (
                  <Icon name="user" size={8} ml={1.5} mt={2.5} />
                )}
              </Box>
            </Flex.Item>
            <Flex.Item basis={0} grow={1}>
              <LabeledList>
                {dataIter.map(data => (
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
              <Box textAlign="center">
                {registered_name}
              </Box>
            </Flex.Item>
            <Flex.Item>
              <Box textAlign="center">
                <RankIcon rank={assignment} />
              </Box>
            </Flex.Item>
            <Flex.Item>
              <Box textAlign="center">
                {assignment}
              </Box>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
