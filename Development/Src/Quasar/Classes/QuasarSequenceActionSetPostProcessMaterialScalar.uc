class QuasarSequenceActionSetPostProcessMaterialScalar extends SequenceAction;

var() Object Target;

var(MaterialParameters) array<QuasarMaterialParameterScalar> Parameters;

function Activated()
{
	local QuasarPlayerController PC;
	local int i;
	local QuasarMaterialParameterScalar CurrentParam;
	
	PC = QuasarPlayerController(PlayerController(Target));
	
	if (PC != None)
	{
		if (PC.PostProcessMaterialInstance != None)
		{
			for(i = 0; i < Parameters.Length; i++)
			{
				CurrentParam = Parameters[i];
				if (CurrentParam != None)
				{
					PC.SetPostProcessMaterialScalarParam(CurrentParam.ParameterName, CurrentParam.ParameterValue);
				}
			}
		}
		else
		{
			PC.ClientMessage("Invalid Material!");
		}
	}
	else
	{
		return;
	}
}

defaultproperties
{
	ObjName			= "Set Post Process Material Scalar Value"
	ObjCategory		= "Quasar"
	ObjColor		= ( R=180, G=230, B=30, A=255 )
	
	bCallHandler	= false
	
	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target",PropertyName=Target)
}