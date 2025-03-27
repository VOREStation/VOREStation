import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

import type { Icon, ReactionData } from './PublicLibraryWiki/types';
import { WikiChemistryPage } from './PublicLibraryWiki/WikiPages/WikiSubPages/WikiChemistryPage';

type Data = {
  amount: number;
  title: string;
  description: string | null;
  addictive?: number;
  industrial_use?: string;
  supply_points?: number;
  market_price?: number;
  sintering?: string | null;
  overdose: number;
  flavor: string | null;
  allergen: string[] | null;
} & ReactionData &
  Icon;

export const ChemAnalyzerPro = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={300} height={700}>
      <Window.Content>
        <WikiChemistryPage chems={data} beakerFill={0.25} />
      </Window.Content>
    </Window>
  );
};
