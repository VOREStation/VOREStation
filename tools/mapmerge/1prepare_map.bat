cd ../../maps/virgo

FOR %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

pause
