export function exportChatSettings(settings: Record<string, any>) {
    const opts: SaveFilePickerOptions = {
      id: `ss13-chatprefs-${Date.now()}`,
      suggestedName: `ss13-chatsettings-${new Date().toJSON().slice(0, 10)}.json`,
      types: [
        {
          description: 'SS13 file',
          accept: { 'application/json': ['.json'] },
        },
      ],
    };

    window
      .showSaveFilePicker(opts)
      .then((fileHandle) => {
        try {
          fileHandle.createWritable().then((writableHandle) => {
            writableHandle.write(JSON.stringify(settings));
            writableHandle.close();
          });
        } catch (e) {
          console.error(e);
        }
      })
      .catch((e) => {
        // Log the error if the error has nothing to do with the user aborting the download
        if (e.name !== 'AbortError') {
          console.error(e);
        }
      });
  }

  export function importChatSettings(settings: string) {
    return JSON.parse(settings);
  }
