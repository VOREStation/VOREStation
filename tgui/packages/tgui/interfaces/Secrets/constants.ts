import { DebuggingTab } from './Tabs/DebuggingTab';
import { FunForYouTab } from './Tabs/FunForYouTab';
import { FunTab } from './Tabs/FunTab';
import { HelpfulTab } from './Tabs/HelpfulTab';

export const TAB2NAME = [
  {
    title: 'Debugging',
    blurb: 'Where useless shit goes to die',
    gauge: 5,
    component: () => DebuggingTab,
  },
  {
    title: 'Helpful',
    blurb: 'Where fuckwits put logging',
    gauge: 25,
    component: () => HelpfulTab,
  },
  {
    title: 'Fun',
    blurb: 'How I ran an """event"""',
    gauge: 75,
    component: () => FunTab,
  },
  {
    title: 'Only Fun For You',
    blurb: 'How I spent my last day adminning',
    gauge: 95,
    component: () => FunForYouTab,
  },
];

export const lineHeightNormal = 2.79;
export const buttonWidthNormal = 12.9;
export const lineHeightDebug = 6.09;
