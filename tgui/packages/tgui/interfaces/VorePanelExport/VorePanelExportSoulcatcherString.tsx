import { SoulcatcherSettingsFlag } from './constants';
import type { Soulcatcher } from './types';

// prettier-ignore
export const generateSoulcatcherString = (soulcatcher: Soulcatcher) => {
  const { name, inside_flavor, capture_message, transit_message, release_message, transfer_message, delete_message, linked_belly, setting_flags } = soulcatcher;

  const index = "sc_1";

  let result = '';
  result += '<div class="accordion-item"><h2 class="accordion-header" id="heading' + index + '">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse' + index + '" aria-expanded="false" aria-controls="collapse' + index + '">';
  result += name + " (Soulcatcher)";
  result += '</button></h2>';

  result += '<div id="collapse' + index + '" class="accordion-collapse collapse" aria-labelledby="heading' + index + '" data-bs-parent="#accordionBellies">';
  result += '<div class="accordion-body">';

  result += '<b>== Settings ==</b><br>';
  const arr = new Array();
  let parsedFlag = setting_flags;
  while(parsedFlag !== 0) {
    arr.push(String(parsedFlag));
    parsedFlag = Math.floor(parsedFlag / 2);
  }
  for(const flag in SoulcatcherSettingsFlag) {
    if(arr.includes(flag)) {
      result += '<span class="badge text-bg-success">' + SoulcatcherSettingsFlag[flag] + '</span>';
    } else {
      result += '<span class="badge text-bg-danger">' + SoulcatcherSettingsFlag[flag] + '</span>';

    }

  }

  result += '<br><hr>';
  result += '<b>== Descriptions ==</b><br>';
  result += 'Inside Flavor:<br>' + inside_flavor + '<br><br>';
  result += 'Capture Message:<br>' + capture_message + '<br><br>';
  result += 'Transit Message:<br>' + transit_message + '<br><br>';
  result += 'Release Message:<br>' + release_message + '<br><br>';
  result += 'Transfer Message:<br>' + transfer_message + '<br><br>';
  result += 'Delete Message:<br>' + delete_message + '<br><br>';
  result += 'Linked Belly:<br>' + linked_belly + '<br><br>';


  result += '</div></div>';
  result += '</div>'; // End Div messagesTabpanel

  result += '</div></div></div>';

  return result;
};
