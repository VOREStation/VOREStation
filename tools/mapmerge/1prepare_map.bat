cd ../../maps/northern_star

FOR %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

cd ../../maps/southern_cross

FOR %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

pause
