class genericstatsystemGR expands GameRules;

var genericstatsystem MutatorPtr;

// pass kills data
function NotifyKilled(Pawn Killed, Pawn Killer, name DamageType)
{
MutatorPtr.xscoreKilled(Killed,Killer,DamageType);
}


//pass chat data
function bool AllowChat( PlayerPawn Chatting, out string Msg )
{
   if  (MutatorPtr!= none)
   {
    return MutatorPtr.handleChat(Chatting,Msg);
   }else{
    return true;
   }
}


// catch some brodcasts like deaths or level messages
function bool AllowBroadcast( Actor Broadcasting, string Msg )
{
if  (MutatorPtr!= none)
   {
    return MutatorPtr.handleChat(none,Msg);
    }else{
    return true;
   }


}


//watch level switches
function bool CanCoopTravel( Pawn Ender, out string NextURL )
{
local string bs;
    bs = mutatorptr.mutatecooptravel(ender,nexturl);
    // fail
    if (bs == "")
    {
     return false;
    }

    //pass
    if (bs != "")
    {
    nexturl = bs;
     return true;
    }
}

//player spawn
function ModifyPlayer(Pawn Other)
{
	if (PlayerPawn(Other) == none || Other.IsA('Spectator'))
		return;

mutatorptr.mutaterespwan(other);
}


// damage occured
function ModifyDamage( Pawn Injured, Pawn EventInstigator, out int Damage, vector HitLocation, name DamageType, out vector Momentum )
{
MutatorPtr.checkdamage(Injured,EventInstigator,Damage,HitLocation,DamageType,Momentum);
}

// use to allow / disallow pivking up invemtory
function bool CanPickupInventory( Pawn Other, Inventory Inv )
{
MutatorPtr.mutateCanPickupInventory(Other,Inv);
}

//get url with password
function OverridePrelogin( string Options, string PlayerName, out string Error)
{

MutatorPtr.xPrelogin(Options,PlayerName);
}



defaultproperties
{
				bNotifyMessages=True
				bModifyDamage=True
				bHandleDeaths=True
				bHandleMapEvents=true
				bNotifySpawnPoint=True
				bHandleInventory=true
				bNotifyLogin=true
}
