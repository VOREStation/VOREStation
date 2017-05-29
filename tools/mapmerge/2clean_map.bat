SET z_levels=10
cd 

FOR %%f IN (../../maps/tether/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/tether/%%f.backup ../../maps/tether/%%f ../../maps/tether/%%f
)

pause
