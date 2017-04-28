var availableUtilities = new Array(18);
for(i = 0; i < availableUtilities.length; i++)
    availableUtilities[i] = new Array(4);

availableUtilities[0][0] = "electricity";
availableUtilities[0][1] = "Electricity";
availableUtilities[0][2] = "kWh";
availableUtilities[0][3] = "monthly";

availableUtilities[1][0] = "electricityTarget";
availableUtilities[1][1] = "Electricity Target";
availableUtilities[1][2] = "kWh";
availableUtilities[1][3] = "monthly";

availableUtilities[2][0] = "water";
availableUtilities[2][1] = "Water";
availableUtilities[2][2] = "gal";
availableUtilities[2][3] = "monthly";

availableUtilities[3][0] = "waterTarget";
availableUtilities[3][1] = "Water Target";
availableUtilities[3][2] = "gal";
availableUtilities[3][3] = "monthly";

availableUtilities[4][0] = "heatOil";
availableUtilities[4][1] = "Heat Oil";
availableUtilities[4][2] = "gal";
availableUtilities[4][3] = "monthly";

availableUtilities[5][0] = "heatOilTarget";
availableUtilities[5][1] = "Heat Oil Target";
availableUtilities[5][2] = "gal";

availableUtilities[6][0] = "heatGas";
availableUtilities[6][1] = "Heat Gas";
availableUtilities[6][2] = "ccf";
availableUtilities[6][3] = "monthly";

availableUtilities[7][0] = "heatGasTarget";
availableUtilities[7][1] = "Heat Gas Target";
availableUtilities[7][2] = "ccf";
availableUtilities[7][3] = "monthly";

availableUtilities[8][0] = "custom1";
availableUtilities[8][1] = "Custom 1";
availableUtilities[8][2] = "unit";
availableUtilities[8][3] = "monthly";

availableUtilities[9][0] = "custom1Target";
availableUtilities[9][1] = "Custom 1 Target";
availableUtilities[9][2] = "unit";
availableUtilities[9][3] = "monthly";

availableUtilities[10][0] = "custom2";
availableUtilities[10][1] = "Custom 2";
availableUtilities[10][2] = "unit";
availableUtilities[10][3] = "monthly";

availableUtilities[11][0] = "custom2Target";
availableUtilities[11][1] = "Custom 2 Target";
availableUtilities[11][2] = "unit";
availableUtilities[11][3] = "monthly";

availableUtilities[12][0] = "custom3";
availableUtilities[12][1] = "Custom 3";
availableUtilities[12][2] = "unit";
availableUtilities[12][3] = "monthly";

availableUtilities[13][0] = "custom3Target";
availableUtilities[13][1] = "Custom 3 Target";
availableUtilities[13][2] = "unit";
availableUtilities[13][3] = "monthly";

availableUtilities[14][0] = "custom4";
availableUtilities[14][1] = "Custom 4";
availableUtilities[14][2] = "unit";
availableUtilities[14][3] = "monthly";

availableUtilities[15][0] = "custom4Target";
availableUtilities[15][1] = "Custom 4 Target";
availableUtilities[15][2] = "unit";
availableUtilities[15][3] = "monthly";

availableUtilities[16][0] = "custom5";
availableUtilities[16][1] = "Custom 5";
availableUtilities[16][2] = "unit";
availableUtilities[16][3] = "monthly";

availableUtilities[17][0] = "custom5Target";
availableUtilities[17][1] = "Custom 5 Target";
availableUtilities[17][2] = "unit";
availableUtilities[17][3] = "monthly";

function updateCustomAvailableUtilities()
{
    for(var i = 0; i < availableUtilities.length; i++) 
    {        
        if ((availableUtilities[i][0] == "electricity") || (availableUtilities[i][0] == "electricityTarget"))
        {
            var settingsConsumerElectricityUtilityFreq = getCookieUser("settingsConsumerElectricityUtilityFreq");
            if (settingsConsumerElectricityUtilityFreq != "")         
            {
                availableUtilities[i][3] = settingsConsumerElectricityUtilityFreq;     
            }                  
        }
        
        if ((availableUtilities[i][0] == "water") || (availableUtilities[i][0] == "waterTarget"))
        {
            var settingsConsumerWaterUtilityFreq = getCookieUser("settingsConsumerWaterUtilityFreq");
            if (settingsConsumerWaterUtilityFreq != "")         
            {
                availableUtilities[i][3] = settingsConsumerWaterUtilityFreq;     
            }                  
        }

        if ((availableUtilities[i][0] == "heatOil") || (availableUtilities[i][0] == "heatOilTarget"))
        {
            var settingsConsumerHeatOilUtilityFreq = getCookieUser("settingsConsumerHeatOilUtilityFreq");
            if (settingsConsumerHeatOilUtilityFreq != "")         
            {
                availableUtilities[i][3] = settingsConsumerHeatOilUtilityFreq;     
            }                  
        }

        if ((availableUtilities[i][0] == "heatGas") || (availableUtilities[i][0] == "heatGasTarget"))
        {
            var settingsConsumerHeatGasUtilityFreq = getCookieUser("settingsConsumerHeatGasUtilityFreq");
            if (settingsConsumerHeatGasUtilityFreq != "")         
            {
                availableUtilities[i][3] = settingsConsumerHeatGasUtilityFreq;     
            }                  
        }        
    
        if ((availableUtilities[i][0] == "custom1") || (availableUtilities[i][0] == "custom1Target"))
        {
            var settingsConsumerCustomUtility1Name = getCookieUser("settingsConsumerCustomUtility1Name");
            if (settingsConsumerCustomUtility1Name != "")         
            {
                availableUtilities[i][1] = settingsConsumerCustomUtility1Name;   
                if ((availableUtilities[i][0] == "custom1Target"))
                {
                    availableUtilities[i][1] = settingsConsumerCustomUtility1Name + " Target"; 
                }
            }   

            var settingsConsumerCustomUtility1Units = getCookieUser("settingsConsumerCustomUtility1Units");
            if (settingsConsumerCustomUtility1Units != "")         
            {
                availableUtilities[i][2] = settingsConsumerCustomUtility1Units;     
            }   

            var settingsConsumerCustomUtility1Freq = getCookieUser("settingsConsumerCustomUtility1Freq");
            if (settingsConsumerCustomUtility1Freq != "")         
            {
                availableUtilities[i][3] = settingsConsumerCustomUtility1Freq;     
            }                  
        }
        
        if ((availableUtilities[i][0] == "custom2") || (availableUtilities[i][0] == "custom2Target"))
        {
            var settingsConsumerCustomUtility2Name = getCookieUser("settingsConsumerCustomUtility2Name");
            if (settingsConsumerCustomUtility2Name != "")         
            {
                availableUtilities[i][1] = settingsConsumerCustomUtility2Name;  
                if ((availableUtilities[i][0] == "custom2Target"))
                {
                    availableUtilities[i][1] = settingsConsumerCustomUtility2Name + " Target"; 
                }                
            }   

            var settingsConsumerCustomUtility2Units = getCookieUser("settingsConsumerCustomUtility2Units");
            if (settingsConsumerCustomUtility2Units != "")         
            {
                availableUtilities[i][2] = settingsConsumerCustomUtility2Units;     
            }          

            var settingsConsumerCustomUtility2Freq = getCookieUser("settingsConsumerCustomUtility2Freq");
            if (settingsConsumerCustomUtility2Freq != "")         
            {
                availableUtilities[i][3] = settingsConsumerCustomUtility2Freq;     
            }                      
        }      

        if ((availableUtilities[i][0] == "custom3") || (availableUtilities[i][0] == "custom3Target"))
        {
            var settingsConsumerCustomUtility3Name = getCookieUser("settingsConsumerCustomUtility3Name");
            if (settingsConsumerCustomUtility3Name != "")         
            {
                availableUtilities[i][1] = settingsConsumerCustomUtility3Name;  
                if ((availableUtilities[i][0] == "custom3Target"))
                {
                    availableUtilities[i][1] = settingsConsumerCustomUtility3Name + " Target"; 
                }                
            }   

            var settingsConsumerCustomUtility3Units = getCookieUser("settingsConsumerCustomUtility3Units");
            if (settingsConsumerCustomUtility3Units != "")         
            {
                availableUtilities[i][2] = settingsConsumerCustomUtility3Units;     
            }    

            var settingsConsumerCustomUtility3Freq = getCookieUser("settingsConsumerCustomUtility3Freq");
            if (settingsConsumerCustomUtility3Freq != "")         
            {
                availableUtilities[i][3] = settingsConsumerCustomUtility3Freq;     
            }                      
        }      

        if ((availableUtilities[i][0] == "custom4") || (availableUtilities[i][0] == "custom4Target"))
        {
            var settingsConsumerCustomUtility4Name = getCookieUser("settingsConsumerCustomUtility4Name");
            if (settingsConsumerCustomUtility4Name != "")         
            {
                availableUtilities[i][1] = settingsConsumerCustomUtility4Name;  
                if ((availableUtilities[i][0] == "custom4Target"))
                {
                    availableUtilities[i][1] = settingsConsumerCustomUtility4Name + " Target"; 
                }                
            }   

            var settingsConsumerCustomUtility4Units = getCookieUser("settingsConsumerCustomUtility4Units");
            if (settingsConsumerCustomUtility4Units != "")         
            {
                availableUtilities[i][2] = settingsConsumerCustomUtility4Units;     
            }     

            var settingsConsumerCustomUtility4Freq = getCookieUser("settingsConsumerCustomUtility4Freq");
            if (settingsConsumerCustomUtility4Freq != "")         
            {
                availableUtilities[i][3] = settingsConsumerCustomUtility4Freq;     
            }                      
        }    

        if ((availableUtilities[i][0] == "custom5") || (availableUtilities[i][0] == "custom5Target"))
        {
            var settingsConsumerCustomUtility5Name = getCookieUser("settingsConsumerCustomUtility5Name");
            if (settingsConsumerCustomUtility5Name != "")         
            {
                availableUtilities[i][1] = settingsConsumerCustomUtility5Name;  
                if ((availableUtilities[i][0] == "custom5Target"))
                {
                    availableUtilities[i][1] = settingsConsumerCustomUtility5Name + " Target"; 
                }                
            }   

            var settingsConsumerCustomUtility5Units = getCookieUser("settingsConsumerCustomUtility5Units");
            if (settingsConsumerCustomUtility5Units != "")         
            {
                availableUtilities[i][2] = settingsConsumerCustomUtility5Units;     
            }        

            var settingsConsumerCustomUtility5Freq = getCookieUser("settingsConsumerCustomUtility5Freq");
            if (settingsConsumerCustomUtility5Freq != "")         
            {
                availableUtilities[i][3] = settingsConsumerCustomUtility5Freq;     
            }                      
        }            
    }
}

function getUtilityText(utilityValue)
{
    updateCustomAvailableUtilities();

    for(var i = 0; i < availableUtilities.length; i++) 
    {        
        if (availableUtilities[i][0] == utilityValue)
        {
            return availableUtilities[i][1];
        }
    }
}

function getUtilityUnits(utilityValue)
{
    updateCustomAvailableUtilities();
    
    for(var i = 0; i < availableUtilities.length; i++) 
    {        
        if (availableUtilities[i][0] == utilityValue)
        {
            return availableUtilities[i][2];
        }
    }
}

function getUtilityFreq(utilityValue)
{
    updateCustomAvailableUtilities();
    
    for(var i = 0; i < availableUtilities.length; i++) 
    {        
        if (availableUtilities[i][0] == utilityValue)
        {
            return availableUtilities[i][3];
        }
    }
}
                                           
function setCookie(cname, cvalue) 
{
    // check browser support
    if (typeof(Storage) != "undefined") 
    {
        localStorage.setItem(cname, cvalue);
    } 
    else 
    {
        alert("Sorry, your browser does not support Web Storage...");
    }
}

function getCookie(cname) 
{
    // check browser support
    if (typeof(Storage) != "undefined") 
    {
        var ret = localStorage.getItem(cname);
        if (ret == null)
        {
            ret = "";
        }
        return ret;
    } 
    else 
    {
        alert("Sorry, your browser does not support Web Storage...");
    }
    
    return "";
}

function setCookieUser(cname, cvalue) 
{
    var loginEmail = getCookie("loginEmail");
    setCookie(loginEmail + cname, cvalue);
}

function getCookieUser(cname) 
{
    var loginEmail = getCookie("loginEmail");
    return getCookie(loginEmail + cname);
}

function loadLogin() 
{
    var loginEmail = getCookie("loginEmail");
    if (loginEmail != "") 
    {
        document.getElementById("textBoxLoginEmail").value = loginEmail;
        document.getElementById("buttonLogin").innerHTML = "Logout";   
        document.getElementById("buttonCreateUser").disabled = true;          
        document.getElementById("buttonDeleteUser").disabled = false;  
    } 
    else
    {
        document.getElementById("buttonLogin").innerHTML = "Login";  
        document.getElementById("buttonCreateUser").disabled = false;         
        document.getElementById("buttonDeleteUser").disabled = true;          
    }
    
    var loginPwd = getCookie("loginPwd");
    if (loginPwd != "") 
    {  
        document.getElementById("textBoxLoginPwd").value = loginPwd;
    }     
       
}

function signIn() 
{
    if (document.getElementById("buttonLogin").innerHTML == "Login")
    {     
        if (getCookie("userEmail" + document.getElementById("textBoxLoginEmail").value) == document.getElementById("textBoxLoginEmail").value)
        {                     
            if (getCookie("userPwd" + document.getElementById("textBoxLoginEmail").value) == document.getElementById("textBoxLoginPwd").value)
            {            
                setCookie("loginEmail", document.getElementById("textBoxLoginEmail").value);
                setCookie("loginPwd", document.getElementById("textBoxLoginPwd").value);     
            } 
            else
            {
                alert("Invalid password");
            }  
        }
        else
        {
            alert("Invalid email");
        }
    }
    else
    {
        setCookie("loginEmail", "");
        setCookie("loginPwd", "");    
    }

}

function createUser()
{
    // only if not logged in yet
    var loginEmail = getCookie("loginEmail");
    if (loginEmail == "") 
    {
        setCookie("userEmail" + document.getElementById("textBoxLoginEmail").value, document.getElementById("textBoxLoginEmail").value);
        setCookie("userPwd" + document.getElementById("textBoxLoginEmail").value, document.getElementById("textBoxLoginPwd").value);
        
        setCookie("loginEmail", document.getElementById("textBoxLoginEmail").value);
        setCookie("loginPwd", document.getElementById("textBoxLoginPwd").value);             
    }
}

function deleteUser()
{
    // only if logged in
    var loginEmail = getCookie("loginEmail");
    if (loginEmail != "") 
    {
        var r = confirm("Are you sure you want to delete this user?");
        if (r == true) 
        {
            setCookie("userEmail" + document.getElementById("textBoxLoginEmail").value, "");
            setCookie("userPwd" + document.getElementById("textBoxLoginEmail").value, "");
            
            setCookie("loginEmail", "");
            setCookie("loginPwd", "");                
        }
    }
}

function setGenericSelectedValue(selectObj, valueToSet) 
{
    for (var i = 0; i < selectObj.options.length; i++) 
    {              
        if (selectObj.options[i].value == valueToSet) 
        {
            selectObj.options[i].selected = true;
        }
    }
}     

function loadSettingsConsumer()
{    
    var settingsConsumerElectricityUtilityFreq = getCookieUser("settingsConsumerElectricityUtilityFreq");
    if (settingsConsumerElectricityUtilityFreq != "") 
    {                
        var objSelect = document.getElementById("electricityUtilityFreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerElectricityUtilityFreq);        
    }    
    
    var settingsConsumerWaterUtilityFreq = getCookieUser("settingsConsumerWaterUtilityFreq");
    if (settingsConsumerWaterUtilityFreq != "") 
    {                
        var objSelect = document.getElementById("waterUtilityFreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerWaterUtilityFreq);        
    }    

    var settingsConsumerHeatOilUtilityFreq = getCookieUser("settingsConsumerHeatOilUtilityFreq");
    if (settingsConsumerHeatOilUtilityFreq != "") 
    {                
        var objSelect = document.getElementById("heatOilUtilityFreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerHeatOilUtilityFreq);        
    }    

    var settingsConsumerHeatGasUtilityFreq = getCookieUser("settingsConsumerHeatGasUtilityFreq");
    if (settingsConsumerHeatGasUtilityFreq != "") 
    {                
        var objSelect = document.getElementById("heatGasUtilityFreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerHeatGasUtilityFreq);        
    }        

    var settingsConsumerCustomUtility1Name = getCookieUser("settingsConsumerCustomUtility1Name");
    if (settingsConsumerCustomUtility1Name != "") 
    {
        document.getElementById("customUtility1NameInput").value = settingsConsumerCustomUtility1Name;
    }   
    
    var settingsConsumerCustomUtility1Units = getCookieUser("settingsConsumerCustomUtility1Units");
    if (settingsConsumerCustomUtility1Units != "") 
    {
        document.getElementById("customUtility1UnitsInput").value = settingsConsumerCustomUtility1Units;
    }       
    
    var settingsConsumerCustomUtility1Freq = getCookieUser("settingsConsumerCustomUtility1Freq");
    if (settingsConsumerCustomUtility1Freq != "") 
    {                
        var objSelect = document.getElementById("customUtility1FreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerCustomUtility1Freq);        
    }    
    
    var settingsConsumerCustomUtility2Name = getCookieUser("settingsConsumerCustomUtility2Name");
    if (settingsConsumerCustomUtility2Name != "") 
    {
        document.getElementById("customUtility2NameInput").value = settingsConsumerCustomUtility2Name;
    }   
    
    var settingsConsumerCustomUtility2Units = getCookieUser("settingsConsumerCustomUtility2Units");
    if (settingsConsumerCustomUtility2Units != "") 
    {
        document.getElementById("customUtility2UnitsInput").value = settingsConsumerCustomUtility2Units;
    }      
    
    var settingsConsumerCustomUtility2Freq = getCookieUser("settingsConsumerCustomUtility2Freq");
    if (settingsConsumerCustomUtility2Freq != "") 
    {                
        var objSelect = document.getElementById("customUtility2FreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerCustomUtility2Freq);        
    }  
    
    var settingsConsumerCustomUtility3Name = getCookieUser("settingsConsumerCustomUtility3Name");
    if (settingsConsumerCustomUtility3Name != "") 
    {
        document.getElementById("customUtility3NameInput").value = settingsConsumerCustomUtility3Name;
    }   
    
    var settingsConsumerCustomUtility3Units = getCookieUser("settingsConsumerCustomUtility3Units");
    if (settingsConsumerCustomUtility3Units != "") 
    {
        document.getElementById("customUtility3UnitsInput").value = settingsConsumerCustomUtility3Units;
    }      
    
    var settingsConsumerCustomUtility3Freq = getCookieUser("settingsConsumerCustomUtility3Freq");
    if (settingsConsumerCustomUtility3Freq != "") 
    {                
        var objSelect = document.getElementById("customUtility3FreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerCustomUtility3Freq);        
    }     

    var settingsConsumerCustomUtility4Name = getCookieUser("settingsConsumerCustomUtility4Name");
    if (settingsConsumerCustomUtility4Name != "") 
    {
        document.getElementById("customUtility4NameInput").value = settingsConsumerCustomUtility4Name;
    }   
    
    var settingsConsumerCustomUtility4Units = getCookieUser("settingsConsumerCustomUtility4Units");
    if (settingsConsumerCustomUtility4Units != "") 
    {
        document.getElementById("customUtility4UnitsInput").value = settingsConsumerCustomUtility4Units;
    }      
    
    var settingsConsumerCustomUtility4Freq = getCookieUser("settingsConsumerCustomUtility4Freq");
    if (settingsConsumerCustomUtility4Freq != "") 
    {                
        var objSelect = document.getElementById("customUtility4FreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerCustomUtility4Freq);        
    }     

    var settingsConsumerCustomUtility5Name = getCookieUser("settingsConsumerCustomUtility5Name");
    if (settingsConsumerCustomUtility5Name != "") 
    {
        document.getElementById("customUtility5NameInput").value = settingsConsumerCustomUtility5Name;
    }   
    
    var settingsConsumerCustomUtility5Units = getCookieUser("settingsConsumerCustomUtility5Units");
    if (settingsConsumerCustomUtility5Units != "") 
    {
        document.getElementById("customUtility5UnitsInput").value = settingsConsumerCustomUtility5Units;
    }          
    
    var settingsConsumerCustomUtility5Freq = getCookieUser("settingsConsumerCustomUtility5Freq");
    if (settingsConsumerCustomUtility5Freq != "") 
    {                
        var objSelect = document.getElementById("customUtility5FreqInput");
        setGenericSelectedValue(objSelect, settingsConsumerCustomUtility5Freq);        
    }   
    
    var settingsConsumerHouseholdSize = getCookieUser("settingsConsumerHouseholdSize");
    if (settingsConsumerHouseholdSize != "") 
    {
        document.getElementById("householdSizeInput").value = settingsConsumerHouseholdSize;
    }   

    var settingsConsumerHomeSize = getCookieUser("settingsConsumerHomeSize");
    if (settingsConsumerHomeSize != "") 
    {
        document.getElementById("homeSizeInput").value = settingsConsumerHomeSize;
    }    

    var settingsConsumerCountry = getCookieUser("settingsConsumerCountry");
    if (settingsConsumerCountry != "") 
    {
        document.getElementById("countryInput").value = settingsConsumerCountry;
    }    

    var settingsConsumerState = getCookieUser("settingsConsumerState");
    if (settingsConsumerState != "") 
    {
        document.getElementById("stateInput").value = settingsConsumerState;
    }    

    var settingsConsumerTown = getCookieUser("settingsConsumerTown");
    if (settingsConsumerTown != "") 
    {
        document.getElementById("townInput").value = settingsConsumerTown;
    }    

    var settingsConsumerZip = getCookieUser("settingsConsumerZip");
    if (settingsConsumerZip != "") 
    {
        document.getElementById("zipInput").value = settingsConsumerZip;
    }       

}

function saveSettingsConsumer()
{    
    setCookieUser("settingsConsumerElectricityUtilityFreq", document.getElementById("electricityUtilityFreqInput").value); 
    setCookieUser("settingsConsumerWaterUtilityFreq", document.getElementById("waterUtilityFreqInput").value); 
    setCookieUser("settingsConsumerHeatOilUtilityFreq", document.getElementById("heatOilUtilityFreqInput").value); 
    setCookieUser("settingsConsumerHeatGasUtilityFreq", document.getElementById("heatGasUtilityFreqInput").value); 
    
    setCookieUser("settingsConsumerCustomUtility1Name", document.getElementById("customUtility1NameInput").value);
    setCookieUser("settingsConsumerCustomUtility1Units", document.getElementById("customUtility1UnitsInput").value); 
    setCookieUser("settingsConsumerCustomUtility1Freq", document.getElementById("customUtility1FreqInput").value); 
    
    setCookieUser("settingsConsumerCustomUtility2Name", document.getElementById("customUtility2NameInput").value);
    setCookieUser("settingsConsumerCustomUtility2Units", document.getElementById("customUtility2UnitsInput").value); 
    setCookieUser("settingsConsumerCustomUtility2Freq", document.getElementById("customUtility2FreqInput").value);
    
    setCookieUser("settingsConsumerCustomUtility3Name", document.getElementById("customUtility3NameInput").value);
    setCookieUser("settingsConsumerCustomUtility3Units", document.getElementById("customUtility3UnitsInput").value);
    setCookieUser("settingsConsumerCustomUtility3Freq", document.getElementById("customUtility3FreqInput").value);    
    
    setCookieUser("settingsConsumerCustomUtility4Name", document.getElementById("customUtility4NameInput").value);
    setCookieUser("settingsConsumerCustomUtility4Units", document.getElementById("customUtility4UnitsInput").value);
    setCookieUser("settingsConsumerCustomUtility4Freq", document.getElementById("customUtility4FreqInput").value);    
    
    setCookieUser("settingsConsumerCustomUtility5Name", document.getElementById("customUtility5NameInput").value);
    setCookieUser("settingsConsumerCustomUtility5Units", document.getElementById("customUtility5UnitsInput").value);
    setCookieUser("settingsConsumerCustomUtility5Freq", document.getElementById("customUtility5FreqInput").value);    
    
    setCookieUser("settingsConsumerHouseholdSize", document.getElementById("householdSizeInput").value);
    setCookieUser("settingsConsumerHomeSize", document.getElementById("homeSizeInput").value);
    setCookieUser("settingsConsumerCountry", document.getElementById("countryInput").value);
    setCookieUser("settingsConsumerState", document.getElementById("stateInput").value);
    setCookieUser("settingsConsumerTown", document.getElementById("townInput").value);
    setCookieUser("settingsConsumerZip", document.getElementById("zipInput").value);         
}

function loadDataConsumer()
{
/*     var selectUtility = getCookieUser("selectUtility");
    if (selectUtility == "") 
    {                
        setCookieUser("selectUtility", "electricity") 
        selectUtility = "electricity";        
    }
    
    var settingsConsumerYear = getCookieUser("settingsConsumerYear");
    if (settingsConsumerYear == "") 
    {
        setCookieUser("settingsConsumerYear", new Date().getFullYear());
        settingsConsumerYear = new Date().getFullYear();
    }     
    
    document.getElementById("headerEditDataConsumer").innerHTML = "Edit data - " + settingsConsumerYear + " - " + getUtilityText(selectUtility) + " (" + getUtilityUnits(selectUtility) + ")";    
    
    var interval1 = getCookieUser(settingsConsumerYear + selectUtility + "interval1");
    if (interval1 != "") 
    {
        document.getElementById("interval1Input").value = interval1;
    }      
    
    var interval2 = getCookieUser(settingsConsumerYear + selectUtility + "interval2");
    if (interval2 != "") 
    {
        document.getElementById("interval2Input").value = interval2;
    }   

    var interval3 = getCookieUser(settingsConsumerYear + selectUtility + "interval3");
    if (interval3 != "") 
    {
        document.getElementById("interval3Input").value = interval3;
    }      
    
    var interval4 = getCookieUser(settingsConsumerYear + selectUtility + "interval4");
    if (interval4 != "") 
    {
        document.getElementById("interval4Input").value = interval4;
    }   

    var interval5 = getCookieUser(settingsConsumerYear + selectUtility + "interval5");
    if (interval5 != "") 
    {
        document.getElementById("interval5Input").value = interval5;
    }      
    
    var interval6 = getCookieUser(settingsConsumerYear + selectUtility + "interval6");
    if (interval6 != "") 
    {
        document.getElementById("interval6Input").value = interval6;
    }   

    var interval7 = getCookieUser(settingsConsumerYear + selectUtility + "interval7");
    if (interval7 != "") 
    {
        document.getElementById("interval7Input").value = interval7;
    }      
    
    var interval8 = getCookieUser(settingsConsumerYear + selectUtility + "interval8");
    if (interval8 != "") 
    {
        document.getElementById("interval8Input").value = interval8;
    }   

    var interval9 = getCookieUser(settingsConsumerYear + selectUtility + "interval9");
    if (interval9 != "") 
    {
        document.getElementById("interval9Input").value = interval9;
    }      
    
    var interval10 = getCookieUser(settingsConsumerYear + selectUtility + "interval10");
    if (interval10 != "") 
    {
        document.getElementById("interval10Input").value = interval10;
    }   

    var interval11 = getCookieUser(settingsConsumerYear + selectUtility + "interval11");
    if (interval11 != "") 
    {
        document.getElementById("interval11Input").value = interval11;
    }        

    var interval12 = getCookieUser(settingsConsumerYear + selectUtility + "interval12");
    if (interval12 != "") 
    {
        document.getElementById("interval12Input").value = interval12;
    }      
   
    if (getUtilityFreq(selectUtility) == "monthly")
    {            
        document.getElementById("interval1Label").innerHTML = "Jan:"; 
        document.getElementById("interval2Label").innerHTML = "Feb:"; 
        document.getElementById("interval3Label").innerHTML = "Mar"; 
        document.getElementById("interval4Label").innerHTML = "Apr:";
        document.getElementById("interval5Label").innerHTML = "May:";
        document.getElementById("interval6Label").innerHTML = "Jun:";
        document.getElementById("interval7Label").innerHTML = "Jul:"; 
        document.getElementById("interval8Label").innerHTML = "Aug:";
        document.getElementById("interval9Label").innerHTML = "Sep:";
        document.getElementById("interval10Label").innerHTML = "Oct:";
        document.getElementById("interval11Label").innerHTML = "Nov:";
        document.getElementById("interval12Label").innerHTML = "Dec:";
    }    
    else
    {
        document.getElementById("interval1Label").innerHTML = "1:"; 
        document.getElementById("interval2Label").innerHTML = "2:"; 
        document.getElementById("interval3Label").innerHTML = "3"; 
        document.getElementById("interval4Label").innerHTML = "4:";
        document.getElementById("interval5Label").innerHTML = "5:";
        document.getElementById("interval6Label").innerHTML = "6:";
        document.getElementById("interval7Label").innerHTML = "7:"; 
        document.getElementById("interval8Label").innerHTML = "8:";
        document.getElementById("interval9Label").innerHTML = "9:";
        document.getElementById("interval10Label").innerHTML = "10:";
        document.getElementById("interval11Label").innerHTML = "11:";
        document.getElementById("interval12Label").innerHTML = "12:";    
    } */
}
    
function saveDataConsumer()
{
/*     var selectUtility = getCookieUser("selectUtility");
    var settingsConsumerYear = getCookieUser("settingsConsumerYear");    
    
    setCookieUser(settingsConsumerYear + selectUtility + "interval1", document.getElementById("interval1Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval2", document.getElementById("interval2Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval3", document.getElementById("interval3Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval4", document.getElementById("interval4Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval5", document.getElementById("interval5Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval6", document.getElementById("interval6Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval7", document.getElementById("interval7Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval8", document.getElementById("interval8Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval9", document.getElementById("interval9Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval10", document.getElementById("interval10Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval11", document.getElementById("interval11Input").value);
    setCookieUser(settingsConsumerYear + selectUtility + "interval12", document.getElementById("interval12Input").value); */
}

function setSelectedValue(selectObj, valueToSet) 
{
    for (var i = 0; i < selectObj.options.length; i++) 
    {
        selectObj.options[i].text = getUtilityText(selectObj.options[i].value);
              
        if (selectObj.options[i].value == valueToSet) 
        {
            selectObj.options[i].selected = true;
        }
    }
}        

function setSelectedValueUtilityToCompareWith(selectObj, valueToSet) 
{
    for (var i = 0; i < selectObj.options.length; i++) 
    {              
        if (selectObj.options[i].value == valueToSet) 
        {
            selectObj.options[i].selected = true;
        }
    }
}   

function loadSelectUtility()
{
    var selectUtility = getCookieUser("selectUtility");
    if (selectUtility != "") 
    {                
        var objSelect = document.getElementById("selectUtility");
        setSelectedValue(objSelect, selectUtility);        
    }
    else
    {
        selectUtility = "electricity";
        setCookieUser("selectUtility", selectUtility);
        var objSelect = document.getElementById("selectUtility");
        setSelectedValue(objSelect, selectUtility);            
    }
    
    var settingsConsumerYear = getCookieUser("settingsConsumerYear");
    if (settingsConsumerYear != "") 
    {                
        document.getElementById("yearInput").value = settingsConsumerYear;   
    }
    else
    {
        settingsConsumerYear = new Date().getFullYear();
        setCookieUser("settingsConsumerYear", settingsConsumerYear);
        document.getElementById("yearInput").value = settingsConsumerYear;
    }   

    var selectUtilityToCompareWith = getCookieUser("selectUtilityToCompareWith");
    if (selectUtilityToCompareWith != "") 
    {                
        var objSelect = document.getElementById("selectUtilityToCompareWith");
        setSelectedValueUtilityToCompareWith(objSelect, selectUtilityToCompareWith);        
    }
    else
    {
        selectUtilityToCompareWith = "selectedUtilityTarget";
        setCookieUser("selectUtilityToCompareWith", selectUtilityToCompareWith);
        var objSelect = document.getElementById("selectUtilityToCompareWith");
        setSelectedValueUtilityToCompareWith(objSelect, selectUtilityToCompareWith);            
    }
    
    var settingsConsumerYearToCompareWith = getCookieUser("settingsConsumerYearToCompareWith");
    if (settingsConsumerYearToCompareWith != "") 
    {                
        document.getElementById("yearToCompareWithInput").value = settingsConsumerYearToCompareWith;   
    }
    else
    {
        settingsConsumerYearToCompareWith = new Date().getFullYear();
        setCookieUser("settingsConsumerYearToCompareWith", settingsConsumerYearToCompareWith);
        document.getElementById("yearToCompareWithInput").value = settingsConsumerYearToCompareWith;
    }     
}

function saveSelectUtility()
{
    setCookieUser("selectUtility", document.getElementById("selectUtility").value);
    setCookieUser("settingsConsumerYear", document.getElementById("yearInput").value);    
    
    setCookieUser("selectUtilityToCompareWith", document.getElementById("selectUtilityToCompareWith").value);
    setCookieUser("settingsConsumerYearToCompareWith", document.getElementById("yearToCompareWithInput").value);    
}
