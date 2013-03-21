class QuasarLootBox extends KAssetSpawnable
	ClassGroup(Quasar)
	placeable;
	
var (Lootbox) const name ItemSpawnSocket;
var (Lootbox) const QuasarPickup ItemSpawn;
var const class<QuasarPickup> ItemSpawnClass;

var QuasarPickup CurrentItem;

simulated event PostBeginPlay()
{
	local vector SocketLocation;
	local Rotator SocketRotation;
	local vector Addition;
	
	Addition.Z += 2.0f;
	
	Super.PostBeginPlay();

	if (self.ItemSpawnClass != None && self.SkeletalMeshComponent.GetSocketByName(self.ItemSpawnSocket) != None)
	{
		if (self.SkeletalMeshComponent.GetSocketWorldLocationAndRotation(self.ItemSpawnSocket, SocketLocation, SocketRotation))
		{
			SocketLocation = SocketLocation + Addition;
			
			if (self.ItemSpawn != None)
			{
				self.CurrentItem = Spawn(self.ItemSpawn.class, self,, SocketLocation, SocketRotation, self.ItemSpawn);
			}
			else
			{
				self.CurrentItem = Spawn(self.ItemSpawnClass, self,, SocketLocation, self.Rotation);
			}
		}
	}
}

event Used()
{
	
}
	
defaultproperties
{
	ItemSpawnSocket			= name'ItemSpawnPoint'
	ItemSpawnClass			= class'Quasar.QuasarPickup'
	ItemSpawn				= QuasarPickup'QuasarPickups.Misc.SampleItem'
	
	bCollideActors			= true;
	bBlockActors			= true;
}