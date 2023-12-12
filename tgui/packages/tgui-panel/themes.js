/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const THEMES = ['light', 'dark', 'vchatlight', 'vchatdark'];

const COLOR_DARK_BG = '#202020';
const COLOR_DARK_BG_DARKER = '#171717';
const COLOR_DARK_TEXT = '#a4bad6';

let setClientThemeTimer = null;

/**
 * Darkmode preference, originally by Kmc2000.
 *
 * This lets you switch client themes by using winset.
 *
 * If you change ANYTHING in interface/skin.dmf you need to change it here.
 *
 * There's no way round it. We're essentially changing the skin by hand.
 * It's painful but it works, and is the way Lummox suggested.
 */
export const setClientTheme = (name) => {
  // Transmit once for fast updates and again in a little while in case we won
  // the race against statbrowser init.
  clearInterval(setClientThemeTimer);
  Byond.command(`.output statbrowser:set_theme ${name}`);
  setClientThemeTimer = setTimeout(() => {
    Byond.command(`.output statbrowser:set_theme ${name}`);
  }, 1500);

  if (name === 'light' || name === 'vchatlight') {
    // VOREStation Specific Winsets
    Byond.winset({
      'rpane.background-color': 'none',
      'rpane.text-color': '#000000',
      'rpanewindow.background-color': 'none',
      'rpanewindow.text-color': '#000000',
      'mainvsplit.background-color': 'none',
      'info.tab-background-color': 'none',
      'info.tab-text-color': '#000000',
      'discord.background-color': 'none',
      'discord.text-color': '#000000',
      'mapb.background-color': 'none',
      'mapb.text-color': '#000000',
      'rulesb.background-color': 'none',
      'rulesb.text-color': '#000000',
      'wikib.background-color': 'none',
      'wikib.text-color': '#000000',
      'forumb.background-color': 'none',
      'forumb.text-color': '#000000',
      'hotkey_toggle.background-color': 'none',
      'hotkey_toggle.text-color': '#000000',
      'status_bar.background-color': '#FFFFFF',
      'status_bar.text-color': '#000000',
    });

    return Byond.winset({
      // Main windows
      'infowindow.background-color': 'none',
      'infowindow.text-color': '#000000',
      'info.background-color': 'none',
      'info.text-color': '#000000',
      'browseroutput.background-color': 'none',
      'browseroutput.text-color': '#000000',
      'outputwindow.background-color': 'none',
      'outputwindow.text-color': '#000000',
      'mainwindow.background-color': 'none',
      'split.background-color': 'none',
      // Buttons
      'changelog.background-color': 'none',
      'changelog.text-color': '#000000',
      'rules.background-color': 'none',
      'rules.text-color': '#000000',
      'wiki.background-color': 'none',
      'wiki.text-color': '#000000',
      'forum.background-color': 'none',
      'forum.text-color': '#000000',
      'github.background-color': 'none',
      'github.text-color': '#000000',
      'report-issue.background-color': 'none',
      'report-issue.text-color': '#000000',
      // Status and verb tabs
      'output.background-color': 'none',
      'output.text-color': '#000000',
      'statwindow.background-color': 'none',
      'statwindow.text-color': '#000000',
      'stat.background-color': '#FFFFFF',
      'stat.tab-background-color': 'none',
      'stat.text-color': '#000000',
      'stat.tab-text-color': '#000000',
      'stat.prefix-color': '#000000',
      'stat.suffix-color': '#000000',
      // Say, OOC, me Buttons etc.
      'saybutton.background-color': 'none',
      'saybutton.text-color': '#000000',
      'oocbutton.background-color': 'none',
      'oocbutton.text-color': '#000000',
      'mebutton.background-color': 'none',
      'mebutton.text-color': '#000000',
      'asset_cache_browser.background-color': 'none',
      'asset_cache_browser.text-color': '#000000',
      'tooltip.background-color': 'none',
      'tooltip.text-color': '#000000',
      'input.background-color': '#FFFFFF',
      'input.text-color': '#000000',
    });
  }
  if (name === 'dark' || name === 'vchatdark') {
    // VOREStation Specific Winsets
    Byond.winset({
      'rpane.background-color': COLOR_DARK_BG_DARKER,
      'rpane.text-color': COLOR_DARK_TEXT,
      'rpanewindow.background-color': COLOR_DARK_BG_DARKER,
      'rpanewindow.text-color': COLOR_DARK_TEXT,
      'mainvsplit.background-color': COLOR_DARK_BG,
      'info.tab-background-color': COLOR_DARK_BG,
      'info.tab-text-color': COLOR_DARK_TEXT,
      'mapb.background-color': '#494949',
      'mapb.text-color': COLOR_DARK_TEXT,
      'discord.background-color': '#494949',
      'discord.text-color': COLOR_DARK_TEXT,
      'rulesb.background-color': '#494949',
      'rulesb.text-color': COLOR_DARK_TEXT,
      'wikib.background-color': '#494949',
      'wikib.text-color': COLOR_DARK_TEXT,
      'forumb.background-color': '#494949',
      'forumb.text-color': COLOR_DARK_TEXT,
      'hotkey_toggle.background-color': COLOR_DARK_BG,
      'hotkey_toggle.text-color': COLOR_DARK_TEXT,
      'status_bar.background-color': COLOR_DARK_BG_DARKER,
      'status_bar.text-color': COLOR_DARK_TEXT,
    });

    Byond.winset({
      // Main windows
      'infowindow.background-color': COLOR_DARK_BG,
      'infowindow.text-color': COLOR_DARK_TEXT,
      'info.background-color': COLOR_DARK_BG,
      'info.text-color': COLOR_DARK_TEXT,
      'browseroutput.background-color': COLOR_DARK_BG,
      'browseroutput.text-color': COLOR_DARK_TEXT,
      'outputwindow.background-color': COLOR_DARK_BG,
      'outputwindow.text-color': COLOR_DARK_TEXT,
      'mainwindow.background-color': COLOR_DARK_BG,
      'split.background-color': COLOR_DARK_BG,
      // Buttons
      'changelog.background-color': '#494949',
      'changelog.text-color': COLOR_DARK_TEXT,
      'rules.background-color': '#494949',
      'rules.text-color': COLOR_DARK_TEXT,
      'wiki.background-color': '#494949',
      'wiki.text-color': COLOR_DARK_TEXT,
      'forum.background-color': '#494949',
      'forum.text-color': COLOR_DARK_TEXT,
      'github.background-color': '#3a3a3a',
      'github.text-color': COLOR_DARK_TEXT,
      'report-issue.background-color': '#492020',
      'report-issue.text-color': COLOR_DARK_TEXT,
      // Status and verb tabs
      'output.background-color': COLOR_DARK_BG_DARKER,
      'output.text-color': COLOR_DARK_TEXT,
      'statwindow.background-color': COLOR_DARK_BG_DARKER,
      'statwindow.text-color': COLOR_DARK_TEXT,
      'stat.background-color': COLOR_DARK_BG_DARKER,
      'stat.tab-background-color': COLOR_DARK_BG,
      'stat.text-color': COLOR_DARK_TEXT,
      'stat.tab-text-color': COLOR_DARK_TEXT,
      'stat.prefix-color': COLOR_DARK_TEXT,
      'stat.suffix-color': COLOR_DARK_TEXT,
      // Say, OOC, me Buttons etc.
      'saybutton.background-color': COLOR_DARK_BG,
      'saybutton.text-color': COLOR_DARK_TEXT,
      'oocbutton.background-color': COLOR_DARK_BG,
      'oocbutton.text-color': COLOR_DARK_TEXT,
      'mebutton.background-color': COLOR_DARK_BG,
      'mebutton.text-color': COLOR_DARK_TEXT,
      'asset_cache_browser.background-color': COLOR_DARK_BG,
      'asset_cache_browser.text-color': COLOR_DARK_TEXT,
      'tooltip.background-color': COLOR_DARK_BG,
      'tooltip.text-color': COLOR_DARK_TEXT,
      'input.background-color': COLOR_DARK_BG_DARKER,
      'input.text-color': COLOR_DARK_TEXT,
    });
  }
};
