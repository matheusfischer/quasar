class QuasarPlayerController extends PlayerController;

var MaterialInstanceConstant PostProcessMaterialInstance;

var bool PlayerDebug;

function PlayerTick(float DeltaTime)
{
	local MaterialEffect MaterialEffects;
	local LocalPlayer LocalPlayer;
	
	Super.PlayerTick(DeltaTime);
	
	if (PostProcessMaterialInstance == None)
	{
		LocalPlayer = LocalPlayer(Player);
		
		if (LocalPlayer != None && LocalPlayer.PlayerPostProcess != None)
		{
		
			MaterialEffects		= MaterialEffect(LocalPlayer.PlayerPostProcess.FindPostProcessEffect('PawnPostProcessEffects'));
			
			if (MaterialEffects != None)
			{
			
				PostProcessMaterialInstance = new () class'MaterialInstanceConstant';
				
				if (PostProcessMaterialInstance != None)
				{
					PostProcessMaterialInstance.SetParent(MaterialEffects.Material);
					
					MaterialEffects.Material = PostProcessMaterialInstance;
				}
			}
		}
	}
}

exec function SetPostProcessMaterialScalarParam(name param, float scalar)
{
	if (PostProcessMaterialInstance != None)
	{
		PostProcessMaterialInstance.SetScalarParameterValue(param, scalar);
	}
	else
	{
		self.ClientMessage("Invalid material instance.");
	}
}

exec function SetPostProcessMaterialTextureParam(name param, Texture tex)
{
	if (PostProcessMaterialInstance != None)
	{
		if (tex != None)
		{
			PostProcessMaterialInstance.SetTextureParameterValue(param, tex);
		}
		else
		{
			self.ClientMessage("Invalid texture.");
		}
	}
	else
	{
		self.ClientMessage("Invalid material instance.");
	}
}

exec function SetPostProcessMaterialVectorParam(name param, LinearColor lc)
{
	if (PostProcessMaterialInstance != None)
	{
		PostProcessMaterialInstance.SetVectorParameterValue(param, lc);
	}
	else
	{
		self.ClientMessage("Invalid material instance.");
	}
}

exec function SetPlayerDebug(bool b)
{
	self.PlayerDebug = b;
}

exec function QuasarInput_Use()
{
	local QuasarPawn QPlayer;
	local QuasarPickup CurrentItem;
	local QuasarLootBox CurrentLootBox;
	local int SlotID;
	
	QPlayer = QuasarPawn(self.Pawn);
	
	if (QPlayer.CrosshairTrace.IsA('QuasarPickup'))
	{
		CurrentItem = QuasarPickup(QPlayer.CrosshairTrace);
		
		if (CurrentItem.IsInRange(self.Pawn))
		{
			self.ClientMessage(CurrentItem.ItemName$" picked up.");
			
			if (CurrentItem.ObjectArchetype != None)
			{
				self.ClientMessage(CurrentItem.ObjectArchetype);
			}
		
			if (CurrentItem.Stack && QPlayer.InventoryManager.HasItem(CurrentItem.ItemID, SlotID))
			{
				QPlayer.InventoryManager.Backpack[SlotID].Quantity++;
			}
			else
			{
				QPlayer.InventoryManager.AddItemToBackpack(CurrentItem);
			}
			
			CurrentItem.PickedUp(self);
		
			CurrentItem.Destroy();
			//CurrentItem.SetDrawScale(0.0f);
		}
	}
	
	if (QPlayer.CrosshairTrace.IsA('QuasarLootBox'))
	{
		CurrentLootBox = QuasarLootBox(QPlayer.CrosshairTrace);
		
		if (CurrentLootBox != None)
		{
			CurrentLootBox.Used();
		}
	}
}

defaultproperties
{
	PlayerDebug				= false;
	
	CameraClass				= class'Quasar.QuasarCamera';
}