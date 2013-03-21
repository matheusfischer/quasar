class QuasarInventoryManager extends Actor
	HideCategories(Object);

var array<QuasarInventorySlot> Backpack;

var int Capacity;
var int Gold;

simulated event PostBeginPlay()
{
}

function bool HasItem(int ID, out int SlotID)
{
	local int i;
	
	for(i = 0; i < self.Backpack.Length; i++)
	{
		if (self.Backpack[i].Item.ItemID == ID)
		{
			SlotID = i;
			return true;
		}
	}
	
	return false;
}

function CleanInventory()
{

}

function AddItemToBackpack(QuasarPickup Item)
{
	local QuasarInventorySlot Slot;
	
	Slot = new () class'QuasarInventorySlot';
	
	Slot.Item = Item;
	Slot.Quantity = 1;
	
	self.Backpack.AddItem(Slot);
}
	
defaultproperties
{
	Gold				= 500;
	Capacity			= 24;
}