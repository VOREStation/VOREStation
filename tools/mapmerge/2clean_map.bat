SET z_levels=6
cd 

FOR /L %%i IN (1,1,%z_levels%) DO (
  java -jar MapPatcher.jar -clean ../../maps/exodus-%%i.dmm.backup ../../maps/exodus-%%i.dmm ../../maps/exodus-%%i.dmm
  java -jar MapPatcher.jar -clean ../../maps/colony-%%i.dmm.backup ../../maps/colony-%%i.dmm ../../maps/colony-%%i.dmm
)

pause