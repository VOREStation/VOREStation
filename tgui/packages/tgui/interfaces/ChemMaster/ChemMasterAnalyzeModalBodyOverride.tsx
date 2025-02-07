import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import { Data, modalData } from './types';

export const analyzeModalBodyOverride = (modal: modalData) => {
  const { act, data } = useBackend<Data>();
  const result = modal.args.analysis;
  return (
    <Section
      m="-1rem"
      pb="1rem"
      title={data.condi ? 'Condiment Analysis' : 'Reagent Analysis'}
    >
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Name">{result.name}</LabeledList.Item>
          <LabeledList.Item label="Description">
            {(result.desc || '').length > 0 ? result.desc : 'N/A'}
          </LabeledList.Item>
          {result.blood_type && (
            <>
              <LabeledList.Item label="Blood type">
                {result.blood_type}
              </LabeledList.Item>
              <LabeledList.Item
                label="Blood DNA"
                className="LabeledList__breakContents"
              >
                {result.blood_dna}
              </LabeledList.Item>
            </>
          )}
          {!data.condi && (
            <Button
              icon={data.printing ? 'spinner' : 'print'}
              disabled={data.printing}
              iconSpin={!!data.printing}
              ml="0.5rem"
              onClick={() =>
                act('print', {
                  idx: result.idx,
                  beaker: modal.args.beaker,
                })
              }
            >
              Print
            </Button>
          )}
        </LabeledList>
      </Box>
    </Section>
  );
};
