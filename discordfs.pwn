/*

    Discord for Mini Missions
    Started on 19-2-2018
    Last Edit: 03-October-2020 18:07
    Credits;
        Sasuke_Uchiha
        maddinat0r for discord plugin
        N4r35h for bot status as player count

*/

#define FILTERSCRIPT

/*
    Includes;
        These are by other SA-MP members to help the server's working.
*/
#include <a_samp>

#include <discord-connector>

#define DISCORD_ECHANNEL "ID"
#define DISCORD_BOT "BOT_NAME"

#define isNull(%1) \
                ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
                
#define FUNCTION%1(%2)             forward public %1(%2);     public %1(%2)

/*
    Script Functions/Callbacks;
        The working of main script.
*/
new pCount, Switcher;
new DCC_Channel:Discord_EchoC;

public OnFilterScriptInit()
{
    print("Discord FS by N4r35h Loaded.");
    if(_:Discord_EchoC == 0)
        Discord_EchoC = DCC_FindChannelById(DISCORD_ECHANNEL); // Discord channel ID
    DCC_SendChannelMessage(Discord_EchoC, ":white_check_mark: Server Online");
    pCount = 0;
    Switcher = 0;
    DiscordBotPlayerCountUpdate();
    SetTimer("SwitcherExE", 2000, true);
    return 1;
}

public OnFilterScriptExit()
{
    DCC_SendChannelMessage(Discord_EchoC, ":octagonal_sign: Server Offline");
    return 1;
}

public DCC_OnMessageCreate(DCC_Message:message)
{
    new DCC_Channel:channel;
    new DCC_User:author;
    new msg[256];
    DCC_GetMessageContent(message,msg);
    DCC_GetMessageChannel(message, channel);
    DCC_GetMessageAuthor(message, author);
    new channel_id[DCC_ID_SIZE],author_name[30],author_id[DCC_ID_SIZE];
    DCC_GetChannelId(channel, channel_id);
    DCC_GetUserName(author,author_name);
    DCC_GetUserId(author,author_id);
    if(!isNull(channel_id) && !isNull(author_name) && !isNull(msg))
    {
        CallRemoteFunction("OnMsgFromDiscord","ssss",author_id,channel_id,author_name,msg);
    }
    new botcheck, chcheck =0;
    if (strcmp( channel_id , "765801861965414420" , true ) == 0)
    {
    chcheck = 1;
    }
    DCC_IsUserBot(author,botcheck);
    if(botcheck == 0 && chcheck == 1)
    {
    format(msg,sizeof(msg), "{33FFF0}[Discord] {FFFFFF}%s: %s",author_name,msg);
    SendClientMessageToAll(-1,msg);
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    new
        string[64],
        playerName[MAX_PLAYER_NAME];

    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
    format(string, sizeof string, "**%s has joined the server.**", playerName);
    DCC_SendChannelMessage(Discord_EchoC, string);
    pCount++;
    DiscordBotPlayerCountUpdate();
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new
        szString[64],
        playerName[MAX_PLAYER_NAME];

    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

    new szDisconnectReason[3][] =
    {
        "Crash",
        "Left",
        "Kick/Ban"
    };

    format(szString, sizeof szString, "**%s left the server (%s)**", playerName, szDisconnectReason[reason]);
    DCC_SendChannelMessage(Discord_EchoC, szString);
    pCount--;
    DiscordBotPlayerCountUpdate();
    return 1;
}

public OnPlayerText(playerid, text[])
{
    new string[256];
    new name[30];
    GetPlayerName(playerid, name, sizeof(name));
    format(string,256,"**%s:** %s",name,text);
    DCC_SendChannelMessage(Discord_EchoC, string);
    return 1;
}

public SwitcherExE()
{

 if(Switcher == 1)
 {
 Switcher = 0;
 }
 else
 Switcher = 1;
 DiscordBotPlayerCountUpdate();
}

public DiscordBotPlayerCountUpdate()
{
   new string[50];
   if(Switcher == 1)
   {
   format(string,50,"%d Players Online",pCount);
   }
   else
   format(string,50,"Trucking World");
   DCC_SetBotActivity(string);
}
