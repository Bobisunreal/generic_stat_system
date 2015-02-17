class databasehelper expands actor	config(playerdb);

// this amazing class brought to you bob
// a table that essentaily acts as the registry!
// enjoy the lag!


Struct datbase_structure
{
var() string player, property,value;
};

// idea for a cache for perfomance
//  var array<datbase_structure> playerdatadb_cache;

var () config  array<datbase_structure> playerdatadb;




function string  getdatavalue (string xplayer , string xproperty)
{
local int i;
 For( i = 0; i <  Array_Size(playerdatadb) ; i++  )
    {
                          if (playerdatadb[i].player ==xplayer && playerdatadb[i].property == xproperty )
					      {
                           return  playerdatadb[i].value;
                          }


    }
    return "nil";
}



function  updatedatavalue (string xplayer , string xproperty,string xvalue)
{

local int i,reqestednumber;
local bool found;
 For( i = 0; i <  Array_Size(playerdatadb) ; i++  )
    {
                          if (playerdatadb[i].player ==xplayer && playerdatadb[i].property == xproperty && !found )
					      {
                          reqestednumber = i;
                          found = true;
                          playerdatadb[i].value = xvalue;
                          saveconfig();
                          //log (" we found out requested data at " $ reqestednumber);
                          }


    }


    if (!found)
    {

                 // resolve a first entry in db error
                 // it dont matter order tho.
                if (Array_Size(playerdatadb) < 1)
                {
                i = 0;
                }else{
                i = Array_Size(playerdatadb) -1;
                }

	                     Array_Insert(playerdatadb,Array_Size(playerdatadb),1);
	                   	 playerdatadb[i].player=xplayer;
						 playerdatadb[i].property=xproperty;
						 playerdatadb[i].value=xvalue;
						 //log ("new entry");
						 saveconfig();

						 // yewa call ourself   again ;)
						 // for perforance , later only update the line and not find the line again ?
						 // o we cant , becuase there not numeric!
						 updatedatavalue(xplayer,xproperty,xvalue);




    }




 //return found ;
}

//for convenience
// incriment a table value
function addintvalue(string xuser , string xprop,optional int addto)
{
// add one to a string!
 local string bs;
 local int bsint;

 bs = getdatavalue (xuser , xprop);
 if (bs == "nil")
 {
 updatedatavalue(xuser , xprop,"1");
 }else{
 bsint = int(bs);
 if (addto > 0)
 {
  bsint = bsint + addto;
 }else{
  bsint++;
 }


 updatedatavalue (xuser , xprop,string(bsint));
 }

}






 // return a bool from a table string
 //  you can  == "true" if you want ,but  this is for functions.
function bool returnbool(string xuser , string xprop)
{
// add one to a string!
 local string bs;

 bs = getdatavalue (xuser , xprop);
 if (bs == "nil")
 {
 updatedatavalue(xuser , xprop,"false");
 return false;
 }else{
    if (bs == "true")
    {
    return true;
    }

    if (bs != "true")
    {
    return false;
    }


 }

}

//toggle a bool from a table string
function setbool(string xuser , string xprop,bool newvalue)
{
 if (newvalue)
 {
 updatedatavalue(xuser , xprop,"true");
 }

 if (!newvalue)
 {
 updatedatavalue(xuser , xprop,"false");
 }
}



function string  concatgroups (string xplayer)
{  // becuase i cant think of a better way
   // use this for returning a list of properties matching player

local int i;
local string returnthebs;
 For( i = 0; i <  Array_Size(playerdatadb) ; i++  )
    {
                          if (playerdatadb[i].player ==xplayer  )
					      {
					      returnthebs = returnthebs $" "$playerdatadb[i].property;

                          }


    }
    return returnthebs;
}

function string  concatpropgroups (string xprop)
{  // becuase i cant think of a better way in unreal
   // use this for returning a list of players that have matching properties fields avalible

local int i;
local string returnthebs;
 For( i = 0; i <  Array_Size(playerdatadb) ; i++  )
    {
                          if (playerdatadb[i].property ==xprop  )
					      {
					      returnthebs = returnthebs $" "$playerdatadb[i].player;

                          }


    }
    return returnthebs;
}


function forcedbsave()
{  // dont need to , you can call db.saveconfig();)
saveconfig();

}









