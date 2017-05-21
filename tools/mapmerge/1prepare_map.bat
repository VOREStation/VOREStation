cd ../../maps/tether

FOR %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

pause
