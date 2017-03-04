SET z_levels=7
cd 

FOR %%f IN (../../maps/virgo/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/virgo/%%f.backup ../../maps/virgo/%%f ../../maps/virgo/%%f
)

pause
