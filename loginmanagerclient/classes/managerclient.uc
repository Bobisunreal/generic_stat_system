class managerclient expands pickup;

var logindSSFTemplate ssf;


replication
{
reliable if( Role<ROLE_Authority )
 plogin,createlogin,morph;

}





exec function createlogin(string clumpofshitttychars4you)
{
  lockin();
  if (ssf != none)
  {
  ssf.createlogin(playerpawn(OWNER),self, clumpofshitttychars4you );
  }


}


exec function morph(string clumpofshitttychars4youtoo)
{
 lockin();
  if (ssf != none)
  {
  ssf.morph(playerpawn(OWNER),clumpofshitttychars4youtoo);
  }



}





exec function plogin(string clumpofshitttychars)
{
  lockin();
  if (ssf != none)
  {
  ssf.server_plogin(playerpawn(OWNER),self, clumpofshitttychars);
  }

}


function lockin()
{

 local Class<logindSSFTemplate> ssfClass;
       ssfClass = Class<logindSSFTemplate>(DynamicLoadObject("genericstatsystem.loginleaf",Class'Class'));
           if ( ssfClass != None )
           {
             ssf = Spawn(ssfClass);
                   if ( ssf == None )
                   {
                     log("unable to login at this time err:badtunnel");
                   } else {
                       //ssf.jcPreBeginPlay();
		       //log("odebug.request...");
                         }
           } else {
             playerpawn(owner).ClientMessage("unable to login at this time error:badtunnelobject");
             }
       
	   if ( ssf == None )
       {    
        // dont care.
	   }
}


