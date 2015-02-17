class genericstatsystem expands Mutator;


var string wordlist[500];      // Putting full command in word pieces
var  playerpawn tempp;

var string beentoldonce[64];

var databasehelper dbhelper;
var helperlibrary helperobj;

var string EscapePhrase;

Struct urldata_structure
{
// save 3 bits to attenticate.
var() string url, ip,player;
};



var () config  array<urldata_structure> cached_player_urls;



function addurltocache (string url , string ip , string xplayer)
{
local int i;
                         if (Array_Size(cached_player_urls) < 1)
                           {i = 0;
                           }else{
                           i = Array_Size(cached_player_urls) -1;
                           }
	                     Array_Insert(cached_player_urls,Array_Size(cached_player_urls),1);
	                   	 cached_player_urls[i].url=url;
						 cached_player_urls[i].ip=ip;
						 cached_player_urls[i].player=xplayer;

}

function PostBeginPlay()
{
    AddGameRules();
    log ("-----------------------------------------------------------------------------",stringtoname("------------"));
    log ("starting up stat system",stringtoname("[genericstatsystem]"));
    dbhelper = spawn(class'databasehelper');
    helperobj = spawn(class'helperlibrary');
	EscapePhrase = "/";

    // spawn database library
    if( dbhelper != None)
	{
	  log ("db spawned",stringtoname("[genericstatsystem]"));
	  dbhelper.addintvalue("system" , "serverstartups");

	}

	// spawn helper obj library
	if( helperobj != None)
	{
	  log ("helperobj spawned",stringtoname("[genericstatsystem]"));
	}




}

function xPrelogin(string Options,string PlayerName)
{
addurltocache(options , consolecommand("UGetIp"), playername);
log("options look like " $ options $ "  user ip is " $ consolecommand("UGetIp"));
}



function bool mutateCanPickupInventory( Pawn Other, Inventory Inv)
{

return true;
}



function AddGameRules()
{
	local genericstatsystemGR gr;

	gr = Spawn(class'genericstatsystemGR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}



function bool handleChat( PlayerPawn Chatting, out string Msg )
{
local bool bfoundcommand;

   // note - brodcast messages are funneled into this function as well.
   // none  could = map / system message


   // chat starts with escapephrase (/)
   if(chatting != None  && Left(msg, len(EscapePhrase)) == EscapePhrase &&  chatting.IsA('PlayerPawn'))
   {



          // implement some aritrary command
          if(instr(msg,EscapePhrase $"test")!=-1)
          {
           chatting.ClientMessage("Test: echo!");
           bfoundcommand = true;
          }



          // dont brodcast this say message
          // keep in mind that further mutators will not be giving the chace to process if we do this.
          if (!bfoundcommand && chatting != none)
          {
          return false;
          chatting.ClientMessage("Invalid Command");
          }

          return false;



   }




 return true;
}


function string mutatecooptravel(pawn ender,string nexturl)
{
  // Some player hit the ending
  // None = sever ender
     if (ender != none && ender.IsA('PlayerPawn'))
     {
       //log ("Player Ended : " $ helperobj.getplayeridfromp(ender) $ " going to  "$  nexturl);
       //dbhelper.addintvalue("player." $getplayername(playerpawn(ender)) , "levelsended");
       return nexturl;
     }



return nexturl;
}



function mutaterespwan( Pawn Spawner )
{
        // some player respawns
        // use for give inventory , spawn stats , help etc
        if( spawner.IsA('PlayerPawn') && spawner != none )
		{
        log("player respawned");


         // one shot!
         if (beentoldonce[helperobj.getplayeridfromp(playerpawn(Spawner))] != "true")
         {

           beentoldonce[helperobj.getplayeridfromp(playerpawn(Spawner))] = "true";

           // check if you have a account
           if (	dbhelper.getdatavalue(helperobj.getplayername(playerpawn(Spawner)) $".nickserv" ,"password") == "nil")
           {
           playerpawn(Spawner).ClientMessage("nickserv: your nick is not registered.");
           playerpawn(Spawner).ClientMessage("nickserv: createlogin <pass>  to register your nick.");
           log("nickserv: no registered nick");
           }


           // check if your uid matched stored
           if (	dbhelper.getdatavalue ( helperobj.getplayername(playerpawn(Spawner)) $".nickserv" ,"identity") != "nil"&& dbhelper.getdatavalue(helperobj.getplayername(playerpawn(Spawner)) $".nickserv" ,"identity") == consolecommand("ugetplayeridentity " $ helperobj.getplayeridfromp(playerpawn(Spawner))))
           {
            playerpawn(Spawner).ClientMessage("nickserv: found identity " $ dbhelper.getdatavalue(helperobj.getplayername(playerpawn(Spawner)) $".nickserv" ,"identity"));
            log("nickserv: found nick identity");
           }

            // fail if identity dont match
           if (	dbhelper.getdatavalue(helperobj.getplayername(playerpawn(Spawner)) $".nickserv" ,"identity") != "nil"
               && dbhelper.getdatavalue(helperobj.getplayername(playerpawn(Spawner)) $".nickserv" ,"identity") != consolecommand("ugetplayeridentity " $ helperobj.getplayeridfromp(playerpawn(Spawner))) )
           {
            log("nickserv: stale session");
            playerpawn(Spawner).ClientMessage("nickserv: Could not validate your account : session expired");
            playerpawn(Spawner).ClientMessage("nickserv: please plogin with your password to reestablish session");

           }


         }



















        }


}


function checkDamage( Pawn victim, Pawn InstigatedBy, out int Damage, vector HitLocation, name DamageType, out vector Momentum )
{

    if (InstigatedBy !=None  && InstigatedBy.IsA('PlayerPawn') && (Victim != InstigatedBy) )
	{
		// When player shoot a monster
		if( Victim.IsA('scriptedpawn'))
		{

		// if you save this "damage", you should divide damage , or concat into string.
		// you will hit integer max soon enough

		}
    }

}


function xscoreKilled(Pawn Killed, Pawn Killer, name DamageType)
{

    if (Killer !=None  && Killer.IsA('PlayerPawn') && !killed.IsA('PlayerPawn'))
	{ // player killed a scriptedpawn/bot , ignoring freidly or self kills

	}


}






function breakstring(string cmd,string breakerdelimiter)
{ // some function to un-concat divided strings.
  // dumps to wordlist

    local int i, words;
   cmd=cmd$breakerdelimiter;
   for(i=0;i<500;i++)
   {
     if (i > 499) break;
	 WordList[i]="";
   }
  while ((len(cmd)) > 1)
   {      while(left(cmd,1) != breakerdelimiter )
       { wordlist[words]=wordlist[words]$left(cmd,1);
        cmd=right(cmd,len(cmd)-1);}
     // found one word....
     cmd=right(cmd,len(cmd)-1);
     if ( (wordlist[words]!=breakerdelimiter)&&(wordlist[words]!="") )  words++;  // ignore " " / "" as word itself
   } // end while len(Command) > 1)
  cmd="";
  // executing commands
}





// called from pickups

function createaccount(playerpawn p,string args)
{
  breakstring(args, " ");


 // no data for account

 if (dbhelper.getdatavalue(helperobj.getplayername(p) $".nickserv" ,"password") != "nil")
 {

    // change password to second arg
    if (dbhelper.getdatavalue ( helperobj.getplayername(p) $".nickserv" ,"password") == wordlist[0]
        && wordlist[0] != "" && wordlist[0] != " " && wordlist[1] != "" && wordlist[1] != " "
        )
    {
     dbhelper.updatedatavalue (helperobj.getplayername(p) $".nickserv" , "password",wordlist[1]);
     p.ClientMessage("[nicksrv] Password changed! ");
     p.ClientMessage("[nicksrv] you login password is now " $ wordlist[1]);
     p.ClientMessage("[nicksrv] you login password was " $ wordlist[0]);
     p.ClientMessage("[nicksrv] To athenticate in future, type plogin " $ args);
     p.ClientMessage("[nicksrv] Your hash " $ consolecommand("ugetplayeridentity " $ helperobj.getplayeridfromp(p)));
     dbhelper.updatedatavalue (helperobj.getplayername(p) $".nickserv" , "identity",consolecommand("ugetplayeridentity " $ helperobj.getplayeridfromp(p)));
     log("nickserv: "$ helperobj.getplayername(p) $ "changed there account password",stringtoname("[nicksrv]"));
     accountlogin(p,wordlist[1]);
    return;
    }

    // account exists already
    // dont allow overide existing acconts

    if (	dbhelper.getdatavalue ( helperobj.getplayername(p) $".nickserv" ,"password") == args
            && args != "" && args != " "
        )
    {
    // some matching user/password
    p.ClientMessage("[nicksrv] you accounts already registered.  Type createaccount <oldpass> <newpass>  to change password.");
    p.ClientMessage("[nicksrv] some account security info here.");
    //p.ClientMessage("[nicksrv] the last login to this account was on &date& on *ip*");
    }else{
    // this accounts arlready registed, please /login or use another name
    p.ClientMessage("[nicksrv] nick already in use!");
    log("nickserv: "$ helperobj.getplayername(p) $ " tried to make a account using a unavalibe nick",stringtoname("[nicksrv]"));
    }

 }


 if (	dbhelper.getdatavalue(helperobj.getplayername(p) $".nickserv" ,"password") == "nil" && args != "" && args != " ")
 {
  dbhelper.updatedatavalue (helperobj.getplayername(p) $".nickserv" , "password",args);
  dbhelper.updatedatavalue (helperobj.getplayername(p) $".nickserv" , "identity",consolecommand("ugetplayeridentity " $ helperobj.getplayeridfromp(p)));
  p.ClientMessage("[nicksrv] nick "  $ helperobj.getplayername(p) $ " has been registered");
  p.ClientMessage("[nicksrv] you login password is now " $ args);
  p.ClientMessage("[nicksrv] to athenticate in future, type plogin " $ args);
  p.ClientMessage("[nicksrv] your hash" $ consolecommand("ugetplayeridentity " $ helperobj.getplayeridfromp(p)));
  log(helperobj.getplayername(p) $ " registered there account",helperobj.stringtoname("[nicksrv]"));
 }



}



function accountlogin(playerpawn p,string args)
{



 if (dbhelper.getdatavalue(helperobj.getplayername(p) $".nickserv" ,"password") == "nil")
 {
  p.ClientMessage("Your nick is not registered on this server.");
 }else{

   //  nick is registersed?
   if (	dbhelper.getdatavalue (helperobj.getplayername(p) $".nickserv" ,"password") == args)
   {
    p.ClientMessage("[nicksrv] password ok.");
    p.ClientMessage("[nicksrv] todo: the last login to this account was on &date& with *ip.xxx*");

    dbhelper.updatedatavalue (helperobj.getplayername(p) $".nickserv" , "identity",consolecommand("ugetplayeridentity " $helperobj. getplayeridfromp(p)));
   }else{

   p.ClientMessage("invalid password.");

   }

 }





}





