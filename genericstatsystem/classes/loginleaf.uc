class loginleaf extends logindSSFTemplate;

var databaseinterationclass dbobject;


function server_beginplay(playerpawn pp,managerclient mc_instance,string  validateduser )
{
 

}

function morph(playerpawn pp,string  morphcommand )
{

}


function createlogin(playerpawn pp,managerclient mc_instance,string  createloginstring )
{


local genericstatsystem ess;

       foreach AllActors(class'genericstatsystem',ess)
       { // let this nightmare begin!
	   ess.createaccount(pp,createloginstring);
	   }



}









function server_plogin(playerpawn p,managerclient mc_instance, string user)
{ // passed to server side functions.!
local genericstatsystem ess;

       foreach AllActors(class'genericstatsystem',ess)
       { // let this nightmare begin!
	   ess.accountlogin(p,user);
	   } 
}


function int getplayeridfromp( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playerid;

}