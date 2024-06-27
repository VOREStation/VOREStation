import { useBackend } from '../../backend';
import { Box, Button, Input, LabeledList, Section } from '../../components';
import { paginationTitle } from './constants';
import { PaginationChevrons } from './ResearchConsoleBuildMenu';
import { d_disk, Data, t_disk } from './types';

export const TechDisk = (props) => {
  const { act, data } = useBackend<Data>();

  const { tech } = data;

  const { disk, saveDialog, onSaveDialog } = props;

  if (!disk || !disk.present) {
    return null;
  }

  if (saveDialog) {
    return (
      <Section
        title="Load Technology to Disk"
        buttons={
          <Button icon="arrow-left" onClick={() => onSaveDialog(false)}>
            Back
          </Button>
        }
      >
        <LabeledList>
          {tech.map((level) => (
            <LabeledList.Item label={level.name} key={level.name}>
              <Button
                icon="save"
                onClick={() => {
                  onSaveDialog(false);
                  act('copy_tech', { copy_tech_ID: level.id });
                }}
              >
                Copy To Disk
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    );
  }

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Disk Contents">
          (Technology Data Disk)
        </LabeledList.Item>
      </LabeledList>
      {(disk.stored && (
        <Box mt={2}>
          <Box>{disk.name}</Box>
          <Box>Level: {disk.level}</Box>
          <Box>Description: {disk.desc}</Box>
          <Box mt={1}>
            <Button icon="save" onClick={() => act('updt_tech')}>
              Upload to Database
            </Button>
            <Button icon="trash" onClick={() => act('clear_tech')}>
              Clear Disk
            </Button>
            <Button icon="eject" onClick={() => act('eject_tech')}>
              Eject Disk
            </Button>
          </Box>
        </Box>
      )) || (
        <Box>
          <Box>This disk has no data stored on it.</Box>
          <Button icon="save" onClick={() => onSaveDialog(true)}>
            Load Tech To Disk
          </Button>
          <Button icon="eject" onClick={() => act('eject_tech')}>
            Eject Disk
          </Button>
        </Box>
      )}
    </Box>
  );
};

const DataDisk = (props) => {
  const { act, data } = useBackend<Data>();

  const { designs } = data;

  const { disk, saveDialog, onSaveDialog } = props;

  if (!disk || !disk.present) {
    return null;
  }

  if (saveDialog) {
    return (
      <Section
        title={paginationTitle('Load Design to Disk', data['design_page'])}
        buttons={
          <>
            <Button icon="arrow-left" onClick={() => onSaveDialog(false)}>
              Back
            </Button>
            {<PaginationChevrons target={'design_page'} /> || null}
          </>
        }
      >
        <Input
          fluid
          placeholder="Search for..."
          value={data.search}
          onInput={(e, v: string) => act('search', { search: v })}
          mb={1}
        />
        {(designs && designs.length && (
          <LabeledList>
            {designs.map((item) => (
              <LabeledList.Item label={item.name} key={item.name}>
                <Button
                  icon="save"
                  onClick={() => {
                    onSaveDialog(false);
                    act('copy_design', { copy_design_ID: item.id });
                  }}
                >
                  Copy To Disk
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        )) || <Box color="warning">No designs found.</Box>}
      </Section>
    );
  }

  return (
    <Box>
      {(disk.stored && (
        <Box>
          <LabeledList>
            <LabeledList.Item label="Name">{disk.name}</LabeledList.Item>
            <LabeledList.Item label="Lathe Type">
              {disk.build_type}
            </LabeledList.Item>
            <LabeledList.Item label="Required Materials">
              {Object.keys(disk.materials).map((mat) => (
                <Box key={mat}>
                  {mat} x {disk.materials[mat]}
                </Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>
            <Button icon="save" onClick={() => act('updt_design')}>
              Upload to Database
            </Button>
            <Button icon="trash" onClick={() => act('clear_design')}>
              Clear Disk
            </Button>
            <Button icon="eject" onClick={() => act('eject_design')}>
              Eject Disk
            </Button>
          </Box>
        </Box>
      )) || (
        <Box>
          <Box mb={0.5}>This disk has no data stored on it.</Box>
          <Button icon="save" onClick={() => onSaveDialog(true)}>
            Load Design To Disk
          </Button>
          <Button icon="eject" onClick={() => act('eject_design')}>
            Eject Disk
          </Button>
        </Box>
      )}
    </Box>
  );
};

export const ResearchConsoleDisk = (props: {
  saveDialogTech: boolean;
  saveDialogDesign: boolean;
  onSaveDialogTech: Function;
  onSaveDialogDesign: Function;
  d_disk: d_disk;
  t_disk: t_disk;
}) => {
  const { d_disk, t_disk } = props;

  const {
    saveDialogTech,
    onSaveDialogTech,
    saveDialogDesign,
    onSaveDialogDesign,
  } = props;

  if (!d_disk.present && !t_disk.present) {
    return <Section title="Disk Operations">No disk inserted.</Section>;
  }

  return (
    <Section title="Disk Operations">
      <TechDisk
        disk={t_disk}
        saveDialog={saveDialogTech}
        onSaveDialog={onSaveDialogTech}
      />
      <DataDisk
        disk={d_disk}
        saveDialog={saveDialogDesign}
        onSaveDialog={onSaveDialogDesign}
      />
    </Section>
  );
};
