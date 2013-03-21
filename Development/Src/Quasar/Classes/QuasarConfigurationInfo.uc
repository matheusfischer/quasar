class QuasarConfigurationInfo extends Object
	config(ConfigInfo);
	
var() config int BuildNo;
	
function IncrementBuildNo()
{
	self.BuildNo++;
	
	SaveConfig();
}
	
defaultproperties
{
}